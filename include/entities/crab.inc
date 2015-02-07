.linecont +
.ifndef CRAB_INC
CRAB_INC = 1

CRAB_WIDTH = (8 * 3 - 1)
CRAB_HALFWIDTH = (CRAB_WIDTH>>1)
CRAB_HEIGHT = (8 * 2 - 1)
CRAB_HALFHEIGHT = (CRAB_HEIGHT>1)

CRAB_SPEED = 200

CRAB_KNOCKBACK_SPEED = 500

CRAB_PAUSE_SPEED = 0

CRAB_ATTACKED_LENGTH = 30

CRAB_KNOCKBACK_LENGTH = 10

CRAB_INITIAL_DIRECTION = ENTITY_DIRECTION_DOWN
CRAB_INITIAL_HEALTH = 3

crab_random_turnleft_counter = entity_local0
crab_random_turnright_counter = entity_local1
crab_random_pause_counter = entity_local2
crab_x_fine = entity_local3
crab_y_fine = entity_local4
crab_direction = entity_local5
crab_health = entity_local6
crab_knockback_counter = entity_local7
crab_flash_counter = entity_local8

.enum
CRAB_STATE_INIT
CRAB_STATE_MAIN
.endenum

crab_turnright_direction:
  .byte ENTITY_DIRECTION_DOWN
  .byte ENTITY_DIRECTION_UP
  .byte ENTITY_DIRECTION_LEFT
  .byte ENTITY_DIRECTION_RIGHT

crab_turnleft_direction:
  .byte ENTITY_DIRECTION_UP
  .byte ENTITY_DIRECTION_DOWN
  .byte ENTITY_DIRECTION_RIGHT
  .byte ENTITY_DIRECTION_LEFT

crab_opposite_direction:
  .byte ENTITY_DIRECTION_LEFT
  .byte ENTITY_DIRECTION_RIGHT
  .byte ENTITY_DIRECTION_UP
  .byte ENTITY_DIRECTION_DOWN

.define crab_direction_speed_x CRAB_SPEED, -CRAB_SPEED, 0, 0, \
                               CRAB_KNOCKBACK_SPEED, -CRAB_KNOCKBACK_SPEED, 0, 0, \
                               CRAB_PAUSE_SPEED

crab_direction_speed_x_lo:
  .lobytes crab_direction_speed_x

crab_direction_speed_x_hi:
  .hibytes crab_direction_speed_x

.define crab_direction_speed_y 0, 0, CRAB_SPEED, -CRAB_SPEED, \
                               0, 0, CRAB_KNOCKBACK_SPEED, -CRAB_KNOCKBACK_SPEED, \
                               CRAB_PAUSE_SPEED

crab_direction_speed_y_lo:
  .lobytes crab_direction_speed_y

crab_direction_speed_y_hi:
  .hibytes crab_direction_speed_y

.define crab_collision_offset_point0_x CRAB_WIDTH, 0, 0, 0
.define crab_collision_offset_point0_y 0, 0, CRAB_HEIGHT, 0
.define crab_collision_offset_point1_x CRAB_WIDTH, 0, CRAB_HALFWIDTH, CRAB_HALFWIDTH
.define crab_collision_offset_point1_y CRAB_HALFHEIGHT, CRAB_HALFHEIGHT, CRAB_HEIGHT, 0
.define crab_collision_offset_point2_x CRAB_WIDTH, 0, CRAB_WIDTH, CRAB_WIDTH
.define crab_collision_offset_point2_y CRAB_HEIGHT, CRAB_HEIGHT, CRAB_HEIGHT, 0

crab_collision_offset_point0_x_lo: .lobytes crab_collision_offset_point0_x
crab_collision_offset_point1_x_lo: .lobytes crab_collision_offset_point1_x
crab_collision_offset_point2_x_lo: .lobytes crab_collision_offset_point2_x

crab_collision_offset_point0_x_hi: .hibytes crab_collision_offset_point0_x
crab_collision_offset_point1_x_hi: .hibytes crab_collision_offset_point1_x
crab_collision_offset_point2_x_hi: .hibytes crab_collision_offset_point2_x

crab_collision_offset_point0_y_lo: .lobytes crab_collision_offset_point0_y
crab_collision_offset_point1_y_lo: .lobytes crab_collision_offset_point1_y
crab_collision_offset_point2_y_lo: .lobytes crab_collision_offset_point2_y

crab_collision_offset_point0_y_hi: .hibytes crab_collision_offset_point0_y
crab_collision_offset_point1_y_hi: .hibytes crab_collision_offset_point1_y
crab_collision_offset_point2_y_hi: .hibytes crab_collision_offset_point2_y

.define ejector_address crab_eject_left, crab_eject_right, crab_eject_up, crab_eject_down

ejector_address_lo: .lobytes ejector_address
ejector_address_hi: .hibytes ejector_address

.define crab_states \
  crab_state_init, \
  crab_state_main

crab_lo:
  .lobytes crab_states

crab_hi:
  .hibytes crab_states

crab_update:

  entity_state_switchboard crab_lo, crab_hi

crab_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<crab_walk
  sta entity_animation_address_lo,x
  lda #>crab_walk
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_WIDTH
  sta entity_width,x
  lda #CRAB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_crab
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta crab_x_fine,x
  sta crab_y_fine,x

  lda #CRAB_INITIAL_DIRECTION
  sta crab_direction,x
  lda #1
  sta crab_random_turnleft_counter,x
  sta crab_random_turnright_counter,x

  lda #CRAB_INITIAL_HEALTH
  sta crab_health,x

  lda #10
  sta crab_random_pause_counter,x

  lda #0
  sta crab_flash_counter,x
  sta crab_knockback_counter,x

  lda #CRAB_STATE_MAIN
  sta entity_state,x

  rts

crab_state_main:

  entity_combat #CRAB_ATTACKED_LENGTH, #CRAB_KNOCKBACK_LENGTH, crab_flash_counter, crab_knockback_counter, crab_health, crab_direction

  ;advance random turn left state
  .scope
  dec crab_random_turnleft_counter,x
  bne do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnleft_direction,y
  sta crab_direction,x

  lda rand
  sta crab_random_turnleft_counter,x

do_not_turn_crab:
  .endscope

  ;advance random turn right state
  .scope
  dec crab_random_turnright_counter,x
  bne do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnright_direction,y
  sta crab_direction,x

  lda rand
  sta crab_random_turnleft_counter,x

do_not_turn_crab:
  .endscope

  ;advance random pause state
  .scope
  dec crab_random_pause_counter,x
  bne do_not_reset_random_pause_counter

  lda rand
  and #%00001111
  sta crab_random_pause_counter,x
do_not_reset_random_pause_counter:
  .endscope

  ;load current crab direction
  ldy crab_direction,x

  ;override this with pause speed index if pause counter is active
  .scope
  lda crab_random_pause_counter,x
  bmi do_not_use_pause_speed
  ldy #8
do_not_use_pause_speed:
  .endscope

  ;override with knockback counter if active
  .scope
  lda crab_knockback_counter,x
  beq do_not_use_knockback_speed
  ldy crab_direction,x
  tya
  clc
  adc #4
  tay
do_not_use_knockback_speed:
  .endscope

crab_new_x_fine = b10
crab_new_y_fine = b11
crab_new_x = w10
crab_new_y = w11
crab_collision_x = w12
crab_collision_y = w13

  .scope
  lda crab_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_new_x_fine
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta crab_new_x
  lda entity_x_hi,x
  adc #$00
  sta crab_new_x+1
  jmp done
sign_extend_negative:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_new_x_fine
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta crab_new_x
  lda entity_x_hi,x
  adc #$ff
  sta crab_new_x+1
done:
  .endscope

  .scope
  lda crab_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_new_y_fine
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta crab_new_y
  lda entity_y_hi,x
  adc #$00
  sta crab_new_y+1
  jmp done
sign_extend_negative:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_new_y_fine
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta crab_new_y
  lda entity_y_hi,x
  adc #$ff
  sta crab_new_y+1
done:
  .endscope

  .scope
  ;test collision points
  jsr crab_test_point0

  lda b0
  and #FLAG_SOLID
  bne eject

  jsr crab_test_point1

  lda b0
  and #FLAG_SOLID
  bne eject

  jsr crab_test_point2

  lda b0
  and #FLAG_SOLID
  bne eject

  jmp done
eject:
  ;otherwise, eject and then change direction
  ldy crab_direction,x
  lda ejector_address_lo,y
  sta w0
  lda ejector_address_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  ldy crab_direction,x
  lda crab_opposite_direction,y
  sta crab_direction,x
done:

  ;assign the new position to the crab
  lda crab_new_x_fine
  sta crab_x_fine,x
  lda crab_new_x
  sta entity_x_lo,x
  lda crab_new_x+1
  sta entity_x_hi,x
  lda crab_new_y_fine
  sta crab_y_fine,x
  lda crab_new_y
  sta entity_y_lo,x
  lda crab_new_y+1
  sta entity_y_hi,x
  .endscope

  jsr entity_update_animation

  rts

.proc crab_test_point0

  ldy crab_direction,x
  clc
  lda crab_new_x
  adc crab_collision_offset_point0_x_lo,y
  sta crab_collision_x
  lda crab_new_x+1
  adc crab_collision_offset_point0_x_hi,y
  sta crab_collision_x+1

  clc
  lda crab_new_y
  adc crab_collision_offset_point0_y_lo,y
  sta crab_collision_y
  lda crab_new_y+1
  adc crab_collision_offset_point0_y_hi,y
  sta crab_collision_y+1

  lda crab_collision_x
  sta w0
  lda crab_collision_x+1
  sta w0+1

  lda crab_collision_y
  sta w1
  lda crab_collision_y+1
  sta w1+1

  jsr map_test_collision

  rts

.endproc

.proc crab_test_point1

  ldy crab_direction,x
  clc
  lda crab_new_x
  adc crab_collision_offset_point1_x_lo,y
  sta crab_collision_x
  lda crab_new_x+1
  adc crab_collision_offset_point1_x_hi,y
  sta crab_collision_x+1

  clc
  lda crab_new_y
  adc crab_collision_offset_point1_y_lo,y
  sta crab_collision_y
  lda crab_new_y+1
  adc crab_collision_offset_point1_y_hi,y
  sta crab_collision_y+1

  lda crab_collision_x
  sta w0
  lda crab_collision_x+1
  sta w0+1

  lda crab_collision_y
  sta w1
  lda crab_collision_y+1
  sta w1+1

  jsr map_test_collision

  rts

.endproc

.proc crab_test_point2

  ldy crab_direction,x
  clc
  lda crab_new_x
  adc crab_collision_offset_point2_x_lo,y
  sta crab_collision_x
  lda crab_new_x+1
  adc crab_collision_offset_point2_x_hi,y
  sta crab_collision_x+1

  clc
  lda crab_new_y
  adc crab_collision_offset_point2_y_lo,y
  sta crab_collision_y
  lda crab_new_y+1
  adc crab_collision_offset_point2_y_hi,y
  sta crab_collision_y+1

  lda crab_collision_x
  sta w0
  lda crab_collision_x+1
  sta w0+1

  lda crab_collision_y
  sta w1
  lda crab_collision_y+1
  sta w1+1

  jsr map_test_collision

  rts

.endproc

.proc crab_eject_left

  lda crab_collision_x
  and #%00001111
  sta b0

  sec
  lda crab_new_x
  sbc b0
  sta crab_new_x
  lda crab_new_x+1
  sbc #0
  sta crab_new_x+1

  rts

.endproc


.proc crab_eject_right

  lda crab_collision_x
  and #%00001111
  sta b0

  sec
  lda #16
  sbc b0
  sta b0

  clc
  lda crab_new_x
  adc b0
  sta crab_new_x
  lda crab_new_x+1
  adc #0
  sta crab_new_x+1

  rts

.endproc


.proc crab_eject_up

  lda crab_collision_y
  and #%00001111
  sta b0

  sec
  lda crab_new_y
  sbc b0
  sta crab_new_y
  lda crab_new_y+1
  sbc #0
  sta crab_new_y+1

  rts

.endproc


.proc crab_eject_down

  lda crab_collision_y
  and #%00001111
  sta b0

  sec
  lda #16
  sbc b0
  sta b0

  clc
  lda crab_new_y
  adc b0
  sta crab_new_y
  lda crab_new_y+1
  adc #0
  sta crab_new_y+1

  rts

.endproc

.endif
