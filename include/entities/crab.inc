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

.define crab_collision_offset_x \
  CRAB_WIDTH, \
  0, \
  CRAB_HALFWIDTH, \
  CRAB_HALFWIDTH

crab_collision_offset_x_lo:
  .lobytes crab_collision_offset_x

crab_collision_offset_x_hi:
  .hibytes crab_collision_offset_x

.define crab_collision_offset_y \
  CRAB_HALFHEIGHT, \
  CRAB_HALFHEIGHT, \
  CRAB_HEIGHT, \
  0

crab_collision_offset_y_lo:
  .lobytes crab_collision_offset_y

crab_collision_offset_y_hi:
  .hibytes crab_collision_offset_y

.define crab_collision_handlers \
  crab_test_collision_right, \
  crab_test_collision_left, \
  crab_test_collision_down, \
  crab_test_collision_up

crab_test_collision_handlers_lo:
  .lobytes crab_collision_handlers

crab_test_collision_handlers_hi:
  .hibytes crab_collision_handlers

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

  lda rand
  sta crab_random_pause_counter,x

  lda #0
  sta crab_flash_counter,x
  sta crab_knockback_counter,x

  lda #CRAB_STATE_MAIN
  sta entity_state,x

  rts

crab_state_main:

  entity_combat #CRAB_ATTACKED_LENGTH, #CRAB_KNOCKBACK_LENGTH, crab_flash_counter, crab_knockback_counter, crab_health, crab_direction

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

  .scope
  dec crab_random_turnright_counter,x
  bne do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnright_direction,y
  sta crab_direction,x

  ;select random number with an offset
  clc
  lda rand
  adc #128
  sta crab_random_turnleft_counter,x

do_not_turn_crab:
  .endscope

  dec crab_random_pause_counter,x
  bne :+

  lda rand
  adc #196
  sta crab_random_pause_counter,x

:

  ldy crab_direction,x

  lda crab_random_pause_counter,x
  bmi do_not_use_pause_speed

  ldy #8

do_not_use_pause_speed:

  lda crab_knockback_counter,x
  beq do_not_use_knockback_speed

  ldy crab_direction,x
  tya
  clc
  adc #4
  tay

do_not_use_knockback_speed:

  .scope
  lda crab_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_x_fine,x
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_x_fine,x
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x
done:
  .endscope

  .scope
  lda crab_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_y_fine,x
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_y_fine,x
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x
done:
  .endscope

  ldy crab_direction,x
  lda crab_test_collision_handlers_lo,y
  sta w0
  lda crab_test_collision_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  lda b0
  and #FLAG_SOLID
  beq do_not_turn_crab

  lda #255
  sta crab_random_pause_counter,x

  lda #0
  sta crab_knockback_counter,x

  ldy crab_direction,x
  lda crab_opposite_direction,y
  sta crab_direction,x

do_not_turn_crab:

  jsr entity_update_animation

  rts

.proc crab_test_collision_left

  jsr crab_get_collision_point

  sec
  lda w1
  sbc #<8
  sta w1
  lda w1+1
  sbc #>8
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne found_collision

  jsr crab_get_collision_point

  clc
  lda w1
  adc #<8
  sta w1
  lda w1+1
  adc #>8
  sta w1+1

  jsr map_test_collision

found_collision:

  rts

.endproc

crab_test_collision_right = crab_test_collision_left

.proc crab_test_collision_down

  ;test center point
  jsr crab_get_collision_point

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne found_collision

  ;test point to one side
  jsr crab_get_collision_point

  sec
  lda w0
  sbc #<12
  sta w0
  lda w0+1
  sbc #>12
  sta w0+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne found_collision

  ;test point to the other side
  jsr crab_get_collision_point

  clc
  lda w0
  adc #<12
  sta w0
  lda w0+1
  adc #>12
  sta w0+1

  jsr map_test_collision

found_collision:

  rts

.endproc

crab_test_collision_up = crab_test_collision_down

.proc crab_get_collision_point

  ldy crab_direction,x
  clc
  lda entity_x_lo,x
  adc crab_collision_offset_x_lo,y
  sta w0
  lda entity_x_hi,x
  adc crab_collision_offset_x_hi,y
  sta w0+1
  clc
  lda entity_y_lo,x
  adc crab_collision_offset_y_lo,y
  sta w1
  lda entity_y_hi,x
  adc crab_collision_offset_y_hi,y
  sta w1+1

  rts

.endproc

.endif
