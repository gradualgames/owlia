.linecont +
.ifndef SEAHORSE_INC
SEAHORSE_INC = 1

SEAHORSE_WIDTH = $0f
SEAHORSE_HALFWIDTH = (SEAHORSE_WIDTH >> 1)
SEAHORSE_HEIGHT = $1f
SEAHORSE_HALFHEIGHT = (SEAHORSE_HEIGHT >> 1)

SEAHORSE_BOB_ACCELERATION = 10
SEAHORSE_BOB_MAX_VELOCITY = 150

SEAHORSE_SPEED = 100

SEAHORSE_KNOCKBACK_SPEED = 500

SEAHORSE_INITIAL_DIRECTION = SEAHORSE_DIRECTION_LEFT

SEAHORSE_INITIAL_HEALTH = 2

SEAHORSE_ATTACKED_LENGTH = 30

SEAHORSE_KNOCKBACK_LENGTH = 10

SEAHORSE_UNPUFFED_ANIMATION_OFFSET = 0
SEAHORSE_PUFFED_ANIMATION_OFFSET = 4

SEAHORSE_PUFF_COUNTER_LENGTH = 50

;re-use the built in X coordinate because there is no offset
seahorse_shadow_spot_x_lo = entity_x_lo
seahorse_shadow_spot_x_hi = entity_x_hi
seahorse_shadow_spot_x_fine = entity_local0

;supply new Y coordinate; the entity Y coordinate will be computed
;to be offset from this on every frame
seahorse_shadow_spot_y_lo = entity_local1
seahorse_shadow_spot_y_hi = entity_local2
seahorse_shadow_spot_y_fine = entity_local3

;variables for making the seahorse bob slowly up and down over a
;shadow spot
seahorse_bob_altitude_lo = entity_local4
seahorse_bob_altitude_hi = entity_local5
seahorse_bob_altitude_fine = entity_local6
seahorse_bob_velocity_lo = entity_local7
seahorse_bob_velocity_hi = entity_local8

seahorse_random_turnleft_counter = entity_local10
seahorse_random_turnright_counter = entity_local11
seahorse_direction = entity_local14
seahorse_health = entity_local15
seahorse_knockback_counter = entity_local16
seahorse_flash_counter = entity_local17

.enum
SEAHORSE_DIRECTION_RIGHT
SEAHORSE_DIRECTION_LEFT
SEAHORSE_DIRECTION_DOWN
SEAHORSE_DIRECTION_UP
.endenum

.define seahorse_collision_offset_x \
  SEAHORSE_HALFWIDTH+6, \
  SEAHORSE_HALFWIDTH-6, \
  SEAHORSE_HALFWIDTH, \
  SEAHORSE_HALFWIDTH

seahorse_collision_offset_x_lo:
  .lobytes seahorse_collision_offset_x

seahorse_collision_offset_x_hi:
  .hibytes seahorse_collision_offset_x

.define seahorse_collision_offset_y \
  SEAHORSE_HALFWIDTH, \
  SEAHORSE_HALFWIDTH, \
  SEAHORSE_HALFWIDTH+1, \
  SEAHORSE_HALFWIDTH-1

seahorse_collision_offset_y_lo:
  .lobytes seahorse_collision_offset_y

seahorse_collision_offset_y_hi:
  .hibytes seahorse_collision_offset_y

seahorse_turnright_direction:
  .byte SEAHORSE_DIRECTION_DOWN
  .byte SEAHORSE_DIRECTION_UP
  .byte SEAHORSE_DIRECTION_LEFT
  .byte SEAHORSE_DIRECTION_RIGHT

seahorse_turnleft_direction:
  .byte SEAHORSE_DIRECTION_UP
  .byte SEAHORSE_DIRECTION_DOWN
  .byte SEAHORSE_DIRECTION_RIGHT
  .byte SEAHORSE_DIRECTION_LEFT

seahorse_opposite_direction:
  .byte SEAHORSE_DIRECTION_LEFT
  .byte SEAHORSE_DIRECTION_RIGHT
  .byte SEAHORSE_DIRECTION_UP
  .byte SEAHORSE_DIRECTION_DOWN

.define seahorse_animation_addresses \
  seahorse_side, \
  seahorse_side, \
  seahorse_down, \
  seahorse_up

seahorse_animation_addresses_lo:
  .lobytes seahorse_animation_addresses

seahorse_animation_addresses_hi:
  .hibytes seahorse_animation_addresses

seahorse_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.define seahorse_direction_speed_x SEAHORSE_SPEED, -SEAHORSE_SPEED, 0, 0, \
                                     SEAHORSE_KNOCKBACK_SPEED, -SEAHORSE_KNOCKBACK_SPEED, 0, 0

seahorse_direction_speed_x_lo:
  .lobytes seahorse_direction_speed_x

seahorse_direction_speed_x_hi:
  .hibytes seahorse_direction_speed_x

.define seahorse_direction_speed_y 0, 0, SEAHORSE_SPEED, -SEAHORSE_SPEED, \
                                     0, 0, SEAHORSE_KNOCKBACK_SPEED, -SEAHORSE_KNOCKBACK_SPEED

seahorse_direction_speed_y_lo:
  .lobytes seahorse_direction_speed_y

seahorse_direction_speed_y_hi:
  .hibytes seahorse_direction_speed_y

.enum
SEAHORSE_STATE_INIT
SEAHORSE_STATE_BOB_UP
SEAHORSE_STATE_BOB_CREST
SEAHORSE_STATE_BOB_DOWN
SEAHORSE_STATE_BOB_TROUGH
.endenum

.define seahorse_states \
  seahorse_state_init, \
  seahorse_state_seahorse_bob_up, \
  seahorse_state_seahorse_bob_crest, \
  seahorse_state_seahorse_bob_down, \
  seahorse_state_seahorse_bob_trough

seahorse_lo:
  .lobytes seahorse_states

seahorse_hi:
  .hibytes seahorse_states

seahorse_update:

  entity_state_switchboard seahorse_lo, seahorse_hi

seahorse_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  jsr entity_set_shadow_spot

  lda #<seahorse_side
  sta entity_animation_address_lo,x
  lda #>seahorse_side
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SEAHORSE_WIDTH
  sta entity_width,x
  lda #SEAHORSE_HEIGHT
  sta entity_height,x

  lda #sprite_chr_group_index_seahorse
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  ;initialize how high above the ground the seahorse "bobs"
  lda #0
  sta seahorse_bob_altitude_fine,x
  lda #40
  sta seahorse_bob_altitude_lo,x
  lda #0
  sta seahorse_bob_altitude_hi,x

  ;initialize how fast the seahorse will bob up and down
  lda #<0
  sta seahorse_bob_velocity_lo,x
  lda #>0
  sta seahorse_bob_velocity_hi,x

  ;initialize seahorse's coordinates
  lda entity_y_lo,x
  sta seahorse_shadow_spot_y_lo,x
  lda entity_y_hi,x
  sta seahorse_shadow_spot_y_hi,x

  jsr seahorse_compute_coordinates

  lda #$00
  sta seahorse_shadow_spot_x_fine,x
  sta seahorse_shadow_spot_y_fine,x

  jsr seahorse_set_shadow_spot

  lda #SEAHORSE_INITIAL_DIRECTION
  sta seahorse_direction,x

  lda #SEAHORSE_INITIAL_HEALTH
  sta seahorse_health,x

  lda #0
  sta seahorse_flash_counter,x
  sta seahorse_knockback_counter,x

  ;initialize random turn counters. Each time they count
  ;down the seahorse will turn, and then a new value will
  ;be selected via a pseudo random number generator.
  lda #255
  sta seahorse_random_turnright_counter,x

  lda #100
  sta seahorse_random_turnleft_counter,x

  jsr seahorse_get_animation_params_from_direction

  lda #SEAHORSE_STATE_BOB_UP
  sta entity_state,x

  rts

seahorse_state_seahorse_bob_up:

  clc
  lda seahorse_bob_velocity_lo,x
  adc #<SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_lo,x
  lda seahorse_bob_velocity_hi,x
  adc #>SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_hi,x

  .scope
  sec
  lda seahorse_bob_velocity_lo,x
  sbc #<(SEAHORSE_BOB_MAX_VELOCITY)
  lda seahorse_bob_velocity_hi,x
  sbc #>(SEAHORSE_BOB_MAX_VELOCITY)
  bmi do_not_switch_state

  lda #SEAHORSE_STATE_BOB_CREST
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr seahorse_main

  rts

seahorse_state_seahorse_bob_crest:

  sec
  lda seahorse_bob_velocity_lo,x
  sbc #<SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_lo,x
  lda seahorse_bob_velocity_hi,x
  sbc #>SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_hi,x

  .scope
  sec
  lda seahorse_bob_velocity_lo,x
  sbc #0
  lda seahorse_bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #SEAHORSE_STATE_BOB_DOWN
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr seahorse_main

  rts

seahorse_state_seahorse_bob_down:

  sec
  lda seahorse_bob_velocity_lo,x
  sbc #<SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_lo,x
  lda seahorse_bob_velocity_hi,x
  sbc #>SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_hi,x

  .scope
  sec
  lda seahorse_bob_velocity_lo,x
  sbc #<(-(SEAHORSE_BOB_MAX_VELOCITY-SEAHORSE_BOB_ACCELERATION))
  lda seahorse_bob_velocity_hi,x
  sbc #>(-(SEAHORSE_BOB_MAX_VELOCITY-SEAHORSE_BOB_ACCELERATION))
  bpl do_not_switch_state

  lda #SEAHORSE_STATE_BOB_TROUGH
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr seahorse_main

  rts

seahorse_state_seahorse_bob_trough:

  clc
  lda seahorse_bob_velocity_lo,x
  adc #<SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_lo,x
  lda seahorse_bob_velocity_hi,x
  adc #>SEAHORSE_BOB_ACCELERATION
  sta seahorse_bob_velocity_hi,x

  .scope
  sec
  lda seahorse_bob_velocity_lo,x
  sbc #0
  lda seahorse_bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #SEAHORSE_STATE_BOB_UP
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr seahorse_main

  rts

.proc seahorse_main

  entity_combat #SEAHORSE_ATTACKED_LENGTH, #SEAHORSE_KNOCKBACK_LENGTH, seahorse_flash_counter, seahorse_knockback_counter, seahorse_health, seahorse_direction

  ;test for collision offset from seahorse
  ldy seahorse_direction,x
  clc
  lda seahorse_shadow_spot_x_lo,x
  adc seahorse_collision_offset_x_lo,y
  sta w0
  lda seahorse_shadow_spot_x_hi,x
  adc seahorse_collision_offset_x_hi,y
  sta w0+1
  clc
  lda seahorse_shadow_spot_y_lo,x
  adc seahorse_collision_offset_y_lo,y
  sta w1
  lda seahorse_shadow_spot_y_hi,x
  adc seahorse_collision_offset_y_hi,y
  sta w1+1
  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq do_not_turn_seahorse

  lda #0
  sta seahorse_knockback_counter,x

  ldy seahorse_direction,x
  lda seahorse_opposite_direction,y
  sta seahorse_direction,x

do_not_turn_seahorse:

  .scope
  dec seahorse_random_turnleft_counter,x
  bne do_not_turn_seahorse

  ldy seahorse_direction,x
  lda seahorse_turnleft_direction,y
  sta seahorse_direction,x

  lda rand
  sta seahorse_random_turnleft_counter,x

do_not_turn_seahorse:
  .endscope

  .scope
  dec seahorse_random_turnright_counter,x
  bne do_not_turn_seahorse

  ldy seahorse_direction,x
  lda seahorse_turnright_direction,y
  sta seahorse_direction,x

  ;select random number with an offset
  clc
  lda rand
  adc #128
  sta seahorse_random_turnleft_counter,x

do_not_turn_seahorse:
  .endscope

  .scope
  ldy seahorse_direction,x

  lda seahorse_knockback_counter,x
  beq do_not_use_knockback_speed

  tya
  clc
  adc #4
  tay

do_not_use_knockback_speed:
  .endscope

  .scope
  lda seahorse_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda seahorse_shadow_spot_x_fine,x
  adc seahorse_direction_speed_x_lo,y
  sta seahorse_shadow_spot_x_fine,x
  lda seahorse_shadow_spot_x_lo,x
  adc seahorse_direction_speed_x_hi,y
  sta seahorse_shadow_spot_x_lo,x
  lda seahorse_shadow_spot_x_hi,x
  adc #$00
  sta seahorse_shadow_spot_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda seahorse_shadow_spot_x_fine,x
  adc seahorse_direction_speed_x_lo,y
  sta seahorse_shadow_spot_x_fine,x
  lda seahorse_shadow_spot_x_lo,x
  adc seahorse_direction_speed_x_hi,y
  sta seahorse_shadow_spot_x_lo,x
  lda seahorse_shadow_spot_x_hi,x
  adc #$ff
  sta seahorse_shadow_spot_x_hi,x
done:
  .endscope

  .scope
  lda seahorse_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda seahorse_shadow_spot_y_fine,x
  adc seahorse_direction_speed_y_lo,y
  sta seahorse_shadow_spot_y_fine,x
  lda seahorse_shadow_spot_y_lo,x
  adc seahorse_direction_speed_y_hi,y
  sta seahorse_shadow_spot_y_lo,x
  lda seahorse_shadow_spot_y_hi,x
  adc #$00
  sta seahorse_shadow_spot_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda seahorse_shadow_spot_y_fine,x
  adc seahorse_direction_speed_y_lo,y
  sta seahorse_shadow_spot_y_fine,x
  lda seahorse_shadow_spot_y_lo,x
  adc seahorse_direction_speed_y_hi,y
  sta seahorse_shadow_spot_y_lo,x
  lda seahorse_shadow_spot_y_hi,x
  adc #$ff
  sta seahorse_shadow_spot_y_hi,x
done:
  .endscope

  jsr seahorse_get_animation_params_from_direction

  .scope
  lda seahorse_bob_velocity_hi,x
  bmi velocity_negative
velocity_positive:
  clc
  lda seahorse_bob_altitude_fine,x
  adc seahorse_bob_velocity_lo,x
  sta seahorse_bob_altitude_fine,x
  lda seahorse_bob_altitude_lo,x
  adc seahorse_bob_velocity_hi,x
  sta seahorse_bob_altitude_lo,x
  lda seahorse_bob_altitude_hi,x
  adc #0
  sta seahorse_bob_altitude_hi,x
  jmp done
velocity_negative:
  clc
  lda seahorse_bob_altitude_fine,x
  adc seahorse_bob_velocity_lo,x
  sta seahorse_bob_altitude_fine,x
  lda seahorse_bob_altitude_lo,x
  adc seahorse_bob_velocity_hi,x
  sta seahorse_bob_altitude_lo,x
  lda seahorse_bob_altitude_hi,x
  adc #$ff
  sta seahorse_bob_altitude_hi,x
done:
  .endscope

  jsr seahorse_compute_coordinates

  jsr seahorse_set_shadow_spot

  jsr entity_update_animation

  rts

.endproc

.proc seahorse_set_shadow_spot

  lda #4
  sta entity_shadow_spot_x_lo,x
  lda #0
  sta entity_shadow_spot_x_hi,x

  sec
  lda seahorse_shadow_spot_y_lo,x
  sbc entity_y_lo,x
  sta entity_shadow_spot_y_lo,x
  lda seahorse_shadow_spot_y_hi,x
  sbc entity_y_hi,x
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

.proc seahorse_get_animation_params_from_direction

  lda seahorse_direction,x
  tay
  lda seahorse_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda seahorse_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda entity_sprite_flags,x
  and #%10111111
  ora seahorse_sprite_flags_direction,y
  sta entity_sprite_flags,x

  rts

.endproc

.proc seahorse_compute_coordinates

  sec
  lda seahorse_shadow_spot_y_lo,x
  sbc seahorse_bob_altitude_lo,x
  sta entity_y_lo,x
  lda seahorse_shadow_spot_y_hi,x
  sbc seahorse_bob_altitude_hi,x
  sta entity_y_hi,x

  rts

.endproc

.endif
