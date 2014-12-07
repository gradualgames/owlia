.linecont +
.ifndef JELLYFISH_INC
JELLYFISH_INC = 1

JELLYFISH_WIDTH = $0f
JELLYFISH_HEIGHT = $0f

JELLYFISH_INITIAL_HEALTH = 3

JELLYFISH_INITIAL_Y_OFFSET = 40

JELLYFISH_OFFSET_MIDPOINT = 35

JELLYFISH_UNDULATION_ACCELERATION = 5

JELLYFISH_ATTACKED_LENGTH = 30

JELLYFISH_KNOCKBACK_LENGTH = 30

JELLYFISH_FOLLOW_X_OFFSET = 0
JELLYFISH_FOLLOW_Y_OFFSET = 32

;supply new set of x and y coordinates, because
;we compute the coordinates of the jellyfish as
;floating above this point.
jellyfish_x_lo = entity_local0
jellyfish_x_hi = entity_local1
jellyfish_x_fine = entity_local2
jellyfish_y_lo = entity_local3
jellyfish_y_hi = entity_local4
jellyfish_y_fine = entity_local5
jellyfish_x_velocity_lo = entity_local6
jellyfish_x_velocity_hi = entity_local7
jellyfish_y_velocity_lo = entity_local8
jellyfish_y_velocity_hi = entity_local9
jellyfish_y_offset_lo = entity_local10
jellyfish_y_offset_hi = entity_local11
jellyfish_y_offset_fine = entity_local12
jellyfish_y_offset_velocity_lo = entity_local13
jellyfish_y_offset_velocity_hi = entity_local14
jellyfish_direction = entity_local15
jellyfish_health = entity_local16
jellyfish_knockback_counter = entity_local17
jellyfish_flash_counter = entity_local18
jellyfish_frame_counter = entity_local19

.enum
JELLYFISH_STATE_INIT
JELLYFISH_STATE_MAIN
.endenum

.define jellyfish_states \
  jellyfish_state_init, \
  jellyfish_state_main

jellyfish_lo:
  .lobytes jellyfish_states

jellyfish_hi:
  .hibytes jellyfish_states

jellyfish_update:

  entity_state_switchboard jellyfish_lo, jellyfish_hi

jellyfish_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<jellyfish
  sta entity_animation_address_lo,x
  lda #>jellyfish
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #JELLYFISH_WIDTH
  sta entity_width,x
  lda #JELLYFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_jellyfish
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda entity_x_lo,x
  sta jellyfish_x_lo,x
  lda entity_x_hi,x
  sta jellyfish_x_hi,x
  lda #0
  sta jellyfish_x_fine,x

  clc
  lda entity_y_lo,x
  adc #<JELLYFISH_INITIAL_Y_OFFSET
  sta jellyfish_y_lo,x
  lda entity_y_hi,x
  adc #>JELLYFISH_INITIAL_Y_OFFSET
  sta jellyfish_y_hi,x
  lda #0
  sta jellyfish_y_fine,x

  lda #<JELLYFISH_INITIAL_Y_OFFSET
  sta jellyfish_y_offset_lo,x
  lda #>JELLYFISH_INITIAL_Y_OFFSET
  sta jellyfish_y_offset_hi,x
  lda #0
  sta jellyfish_y_offset_fine,x

  lda #0
  sta jellyfish_y_offset_velocity_lo,x
  sta jellyfish_y_offset_velocity_hi,x

  lda #0
  sta jellyfish_x_velocity_lo,x
  sta jellyfish_x_velocity_hi,x
  sta jellyfish_y_velocity_lo,x
  sta jellyfish_y_velocity_hi,x

  jsr jellyfish_add_shadow_spot

  lda #0
  sta jellyfish_flash_counter,x
  sta jellyfish_frame_counter,x
  sta jellyfish_knockback_counter,x
  sta jellyfish_direction,x

  lda #JELLYFISH_INITIAL_HEALTH
  sta jellyfish_health,x

  lda #JELLYFISH_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_state_main:

  entity_combat #JELLYFISH_ATTACKED_LENGTH, #JELLYFISH_KNOCKBACK_LENGTH, jellyfish_flash_counter, jellyfish_knockback_counter, jellyfish_health, jellyfish_direction

  ;transfer jellyfish coordinates to entity coordinates
  lda jellyfish_x_lo,x
  sta entity_x_lo,x
  lda jellyfish_x_hi,x
  sta entity_x_hi,x

  ;compute y coordinate from jellyfish y coordinate and y offset
  sec
  lda jellyfish_y_lo,x
  sbc jellyfish_y_offset_lo,x
  sta entity_y_lo,x
  lda jellyfish_y_hi,x
  sbc jellyfish_y_offset_hi,x
  sta entity_y_hi,x

  ;add velocity to the y offset with sign extension
  .scope
  lda #0
  sta b0
  lda jellyfish_y_offset_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  clc
  lda jellyfish_y_offset_fine,x
  adc jellyfish_y_offset_velocity_lo,x
  sta jellyfish_y_offset_fine,x

  lda jellyfish_y_offset_lo,x
  adc jellyfish_y_offset_velocity_hi,x
  sta jellyfish_y_offset_lo,x

  lda jellyfish_y_offset_hi,x
  adc b0
  sta jellyfish_y_offset_hi,x
  .endscope

  ;accelerate the velocity depending on the offset
  .scope
  sec
  lda #<JELLYFISH_OFFSET_MIDPOINT
  sbc jellyfish_y_offset_lo,x
  lda #>JELLYFISH_OFFSET_MIDPOINT
  sbc jellyfish_y_offset_hi,x
  bmi undulate_up
undulate_down:

  clc
  lda jellyfish_y_offset_velocity_lo,x
  adc #<JELLYFISH_UNDULATION_ACCELERATION
  sta jellyfish_y_offset_velocity_lo,x
  lda jellyfish_y_offset_velocity_hi,x
  adc #>JELLYFISH_UNDULATION_ACCELERATION
  sta jellyfish_y_offset_velocity_hi,x

  jmp done
undulate_up:

  sec
  lda jellyfish_y_offset_velocity_lo,x
  sbc #<JELLYFISH_UNDULATION_ACCELERATION
  sta jellyfish_y_offset_velocity_lo,x
  lda jellyfish_y_offset_velocity_hi,x
  sbc #>JELLYFISH_UNDULATION_ACCELERATION
  sta jellyfish_y_offset_velocity_hi,x

done:
  .endscope

  .scope
  inc jellyfish_frame_counter,x
  lda jellyfish_frame_counter,x
  and #%00001000
  bne do_not_move_jellyfish

  ;choose whether to recede or advance based on knockback counter
  .scope
  lda jellyfish_knockback_counter,x
  beq advance
recede:

  jsr jellyfish_recede

  jmp done

advance:

  jsr jellyfish_advance

done:
  .endscope

do_not_move_jellyfish:
  .endscope

  ;determine new x and y velocity based on relative position of hero
  clc
  lda hero_x
  adc #<JELLYFISH_FOLLOW_X_OFFSET
  sta w0
  lda hero_x+1
  adc #>JELLYFISH_FOLLOW_X_OFFSET
  sta w0+1

  clc
  lda hero_y
  adc #<JELLYFISH_FOLLOW_Y_OFFSET
  sta w1
  lda hero_y+1
  adc #>JELLYFISH_FOLLOW_Y_OFFSET
  sta w1+1

  sec
  lda w0
  sbc jellyfish_x_lo,x
  sta jellyfish_x_velocity_lo,x
  lda w0+1
  sbc jellyfish_x_hi,x
  sta jellyfish_x_velocity_hi,x

  sec
  lda w1
  sbc jellyfish_y_lo,x
  sta jellyfish_y_velocity_lo,x
  lda w1+1
  sbc jellyfish_y_hi,x
  sta jellyfish_y_velocity_hi,x

  clc
  rol jellyfish_x_velocity_lo,x
  rol jellyfish_x_velocity_hi,x
  rol jellyfish_x_velocity_lo,x
  rol jellyfish_x_velocity_hi,x
  rol jellyfish_x_velocity_lo,x
  rol jellyfish_x_velocity_hi,x

  clc
  rol jellyfish_y_velocity_lo,x
  rol jellyfish_y_velocity_hi,x
  rol jellyfish_y_velocity_lo,x
  rol jellyfish_y_velocity_hi,x
  rol jellyfish_y_velocity_lo,x
  rol jellyfish_y_velocity_hi,x

  jsr jellyfish_add_shadow_spot

  jsr entity_update_animation

  rts

.proc jellyfish_advance

  ;add x and y velocity to the coordinates with sign extension
  .scope
  lda #0
  sta b0
  lda jellyfish_x_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  clc
  lda jellyfish_x_fine,x
  adc jellyfish_x_velocity_lo,x
  sta jellyfish_x_fine,x

  lda jellyfish_x_lo,x
  adc jellyfish_x_velocity_hi,x
  sta jellyfish_x_lo,x

  lda jellyfish_x_hi,x
  adc b0
  sta jellyfish_x_hi,x
  .endscope

  .scope
  lda #0
  sta b0
  lda jellyfish_y_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  clc
  lda jellyfish_y_fine,x
  adc jellyfish_y_velocity_lo,x
  sta jellyfish_y_fine,x

  lda jellyfish_y_lo,x
  adc jellyfish_y_velocity_hi,x
  sta jellyfish_y_lo,x

  lda jellyfish_y_hi,x
  adc b0
  sta jellyfish_y_hi,x
  .endscope

  rts

.endproc

.proc jellyfish_recede

  ;sub x and y velocity to the coordinates with sign extension
  .scope
  lda #0
  sta b0
  lda jellyfish_x_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  sec
  lda jellyfish_x_fine,x
  sbc jellyfish_x_velocity_lo,x
  sta jellyfish_x_fine,x

  lda jellyfish_x_lo,x
  sbc jellyfish_x_velocity_hi,x
  sta jellyfish_x_lo,x

  lda jellyfish_x_hi,x
  sbc b0
  sta jellyfish_x_hi,x
  .endscope

  .scope
  lda #0
  sta b0
  lda jellyfish_y_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  sec
  lda jellyfish_y_fine,x
  sbc jellyfish_y_velocity_lo,x
  sta jellyfish_y_fine,x

  lda jellyfish_y_lo,x
  sbc jellyfish_y_velocity_hi,x
  sta jellyfish_y_lo,x

  lda jellyfish_y_hi,x
  sbc b0
  sta jellyfish_y_hi,x
  .endscope

  rts

.endproc

.proc jellyfish_add_shadow_spot

  clc
  lda jellyfish_x_lo,x
  adc #4
  sta w0
  lda jellyfish_x_hi,x
  adc #0
  sta w0+1

  lda jellyfish_y_lo,x
  sta w1
  lda jellyfish_y_hi,x
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.endif
