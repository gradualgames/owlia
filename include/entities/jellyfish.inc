.linecont +
.ifndef JELLYFISH_INC
JELLYFISH_INC = 1

.include "jellyfish_constants.inc"

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

  jsr entity_set_shadow_spot

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

  lda #0
  sta jellyfish_flash_counter,x
  sta jellyfish_frame_counter,x
  sta jellyfish_knockback_counter,x
  sta jellyfish_direction,x

  jsr jellyfish_set_shadow_spot

  lda #JELLYFISH_INITIAL_HEALTH
  sta jellyfish_health,x

  lda #JELLYFISH_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_state_main:

  entity_combat #JELLYFISH_ATTACKED_LENGTH, #JELLYFISH_KNOCKBACK_LENGTH, jellyfish_flash_counter, jellyfish_knockback_counter, jellyfish_health, jellyfish_direction, "entity_drop_random_item", "entity_spawn_explosion"

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

.proc jellyfish_set_shadow_spot

  lda #4
  sta entity_shadow_spot_x_lo,x
  lda #0
  sta entity_shadow_spot_x_hi,x

  lda #32
  sta entity_shadow_spot_y_lo,x
  lda #0
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

.endif
