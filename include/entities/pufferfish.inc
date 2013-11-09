.linecont +
.ifndef PUFFERFISH_INC
PUFFERFISH_INC = 1

PUFFERFISH_WIDTH = $0f
PUFFERFISH_HALFWIDTH = (PUFFERFISH_WIDTH >> 1)
PUFFERFISH_HEIGHT = $0f
PUFFERFISH_HALFHEIGHT = (PUFFERFISH_HEIGHT >> 1)

PUFFERFISH_BOB_ACCELERATION = 10
PUFFERFISH_BOB_MAX_VELOCITY = 150

PUFFERFISH_SPEED = 100

PUFFERFISH_INITIAL_DIRECTION = PUFFERFISH_DIRECTION_LEFT

PUFFERFISH_INITIAL_HEALTH = 2

PUFFERFISH_ATTACKED_LENGTH = 30

PUFFERFISH_UNPUFFED_ANIMATION_OFFSET = 0
PUFFERFISH_PUFFED_ANIMATION_OFFSET = 4

PUFFERFISH_PUFF_COUNTER_LENGTH = 50

;re-use the built in X coordinate because there is no offset
pufferfish_shadow_spot_x_lo = entity_x_lo
pufferfish_shadow_spot_x_hi = entity_x_hi
pufferfish_shadow_spot_x_fine = entity_local0

;supply new Y coordinate; the entity Y coordinate will be computed
;to be offset from this on every frame
pufferfish_shadow_spot_y_lo = entity_local1
pufferfish_shadow_spot_y_hi = entity_local2
pufferfish_shadow_spot_y_fine = entity_local3

;variables for making the pufferfish bob slowly up and down over a
;shadow spot
bob_altitude_lo = entity_local4
bob_altitude_hi = entity_local5
bob_altitude_fine = entity_local6
bob_velocity_lo = entity_local7
bob_velocity_hi = entity_local8

pufferfish_direction = entity_local9

pufferfish_random_turnleft_counter = entity_local10
pufferfish_random_turnright_counter = entity_local11
pufferfish_pseudo_random_number = entity_local12
pufferfish_animation_offset = entity_local13
pufferfish_puff_counter = entity_local14
pufferfish_health = entity_local18
pufferfish_attacked_counter = entity_local19

.enum
PUFFERFISH_DIRECTION_RIGHT
PUFFERFISH_DIRECTION_LEFT
PUFFERFISH_DIRECTION_DOWN
PUFFERFISH_DIRECTION_UP
.endenum

.define pufferfish_collision_offset_x \
  PUFFERFISH_HALFWIDTH+1, \
  PUFFERFISH_HALFWIDTH-1, \
  PUFFERFISH_HALFWIDTH, \
  PUFFERFISH_HALFWIDTH

pufferfish_collision_offset_x_lo:
  .lobytes pufferfish_collision_offset_x

pufferfish_collision_offset_x_hi:
  .hibytes pufferfish_collision_offset_x

.define pufferfish_collision_offset_y \
  PUFFERFISH_HALFHEIGHT, \
  PUFFERFISH_HALFHEIGHT, \
  PUFFERFISH_HALFHEIGHT+1, \
  PUFFERFISH_HALFHEIGHT-1

pufferfish_collision_offset_y_lo:
  .lobytes pufferfish_collision_offset_y

pufferfish_collision_offset_y_hi:
  .hibytes pufferfish_collision_offset_y

pufferfish_turnright_direction:
  .byte PUFFERFISH_DIRECTION_DOWN
  .byte PUFFERFISH_DIRECTION_UP
  .byte PUFFERFISH_DIRECTION_LEFT
  .byte PUFFERFISH_DIRECTION_RIGHT

pufferfish_turnleft_direction:
  .byte PUFFERFISH_DIRECTION_UP
  .byte PUFFERFISH_DIRECTION_DOWN
  .byte PUFFERFISH_DIRECTION_RIGHT
  .byte PUFFERFISH_DIRECTION_LEFT

.define pufferfish_animation_addresses \
  PufferFishUnpuffedSide, \
  PufferFishUnpuffedSide, \
  PufferFishUnpuffedDown, \
  PufferFishUnpuffedUp, \
  PufferFishPuffedSide, \
  PufferFishPuffedSide, \
  PufferFishPuffedDown, \
  PufferFishPuffedUp

pufferfish_animation_addresses_lo:
  .lobytes pufferfish_animation_addresses

pufferfish_animation_addresses_hi:
  .hibytes pufferfish_animation_addresses

pufferfish_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.define pufferfish_direction_speed_x PUFFERFISH_SPEED, -PUFFERFISH_SPEED, 0, 0

pufferfish_direction_speed_x_lo:
  .lobytes pufferfish_direction_speed_x

pufferfish_direction_speed_x_hi:
  .hibytes pufferfish_direction_speed_x

.define pufferfish_direction_speed_y 0, 0, PUFFERFISH_SPEED, -PUFFERFISH_SPEED

pufferfish_direction_speed_y_lo:
  .lobytes pufferfish_direction_speed_y

pufferfish_direction_speed_y_hi:
  .hibytes pufferfish_direction_speed_y

.enum
PUFFERFISH_STATE_INIT
PUFFERFISH_STATE_BOB_UP
PUFFERFISH_STATE_BOB_CREST
PUFFERFISH_STATE_BOB_DOWN
PUFFERFISH_STATE_BOB_TROUGH
.endenum

.define pufferfish_states \
  pufferfish_state_init, \
  pufferfish_state_bob_up, \
  pufferfish_state_bob_crest, \
  pufferfish_state_bob_down, \
  pufferfish_state_bob_trough

pufferfish_lo:
  .lobytes pufferfish_states

pufferfish_hi:
  .hibytes pufferfish_states

pufferfish_update:

  entity_state_switchboard pufferfish_lo, pufferfish_hi

pufferfish_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<PufferFishPuffedSide
  sta entity_animation_address_lo,x
  lda #>PufferFishPuffedSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #PUFFERFISH_WIDTH
  sta entity_width,x
  lda #PUFFERFISH_HEIGHT
  sta entity_height,x

  ldy #sprite_chr_group_index_pufferfish
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;initialize how high above the ground the pufferfish "bobs"
  lda #0
  sta bob_altitude_fine,x
  lda #20
  sta bob_altitude_lo,x
  lda #0
  sta bob_altitude_hi,x

  ;initialize how fast the pufferfish will bob up and down
  lda #<0
  sta bob_velocity_lo,x
  lda #>0
  sta bob_velocity_hi,x

  ;initialize pufferfish's coordinates
  lda entity_y_lo,x
  sta pufferfish_shadow_spot_y_lo,x
  lda entity_y_hi,x
  sta pufferfish_shadow_spot_y_hi,x

  jsr pufferfish_compute_coordinates

  lda #PUFFERFISH_INITIAL_DIRECTION
  sta pufferfish_direction,x

  lda #PUFFERFISH_INITIAL_HEALTH
  sta pufferfish_health,x

  lda #0
  sta pufferfish_attacked_counter,x

  ;initialize random turn counters. Each time they count
  ;down the pufferfish will turn, and then a new value will
  ;be selected via a pseudo random number generator.
  lda #255
  sta pufferfish_random_turnright_counter,x

  lda #100
  sta pufferfish_random_turnleft_counter,x

  ;initialize animation offset
  lda #PUFFERFISH_PUFFED_ANIMATION_OFFSET
  sta pufferfish_animation_offset,x

  ;initialize puff counter
  lda #PUFFERFISH_PUFF_COUNTER_LENGTH
  sta pufferfish_puff_counter,x

  jsr pufferfish_get_animation_params_from_direction

  lda #PUFFERFISH_STATE_BOB_UP
  sta entity_state,x

  rts

pufferfish_state_bob_up:

  clc
  lda bob_velocity_lo,x
  adc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  adc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #<(PUFFERFISH_BOB_MAX_VELOCITY)
  lda bob_velocity_hi,x
  sbc #>(PUFFERFISH_BOB_MAX_VELOCITY)
  bmi do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_CREST
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_crest:

  sec
  lda bob_velocity_lo,x
  sbc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  sbc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #0
  lda bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_DOWN
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_down:

  sec
  lda bob_velocity_lo,x
  sbc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  sbc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #<(-(PUFFERFISH_BOB_MAX_VELOCITY-PUFFERFISH_BOB_ACCELERATION))
  lda bob_velocity_hi,x
  sbc #>(-(PUFFERFISH_BOB_MAX_VELOCITY-PUFFERFISH_BOB_ACCELERATION))
  bpl do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_TROUGH
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

pufferfish_state_bob_trough:

  clc
  lda bob_velocity_lo,x
  adc #<PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_lo,x
  lda bob_velocity_hi,x
  adc #>PUFFERFISH_BOB_ACCELERATION
  sta bob_velocity_hi,x

  .scope
  sec
  lda bob_velocity_lo,x
  sbc #0
  lda bob_velocity_hi,x
  sbc #0
  bne do_not_switch_state

  lda #PUFFERFISH_STATE_BOB_UP
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr pufferfish_main

  rts

.proc pufferfish_main

  lda #PUFFERFISH_ATTACKED_LENGTH
  sta b0
  jsr entity_combat

  ;test for collision offset from pufferfish
  ldy pufferfish_direction,x
  clc
  lda pufferfish_shadow_spot_x_lo,x
  adc pufferfish_collision_offset_x_lo,y
  sta w0
  lda pufferfish_shadow_spot_x_hi,x
  adc pufferfish_collision_offset_x_hi,y
  sta w0+1
  clc
  lda pufferfish_shadow_spot_y_lo,x
  adc pufferfish_collision_offset_y_lo,y
  sta w1
  lda pufferfish_shadow_spot_y_hi,x
  adc pufferfish_collision_offset_y_hi,y
  sta w1+1
  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq do_not_turn_pufferfish

  ldy pufferfish_direction,x
  lda pufferfish_turnleft_direction,y
  sta pufferfish_direction,x

do_not_turn_pufferfish:

  ;permute the pseudo random number
  .scope
: lda pufferfish_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor stream_read_address_lo
noEor:
  sta pufferfish_pseudo_random_number,x
  dey
  bne :-

  sta pufferfish_pseudo_random_number,x
  .endscope

  .scope
  dec pufferfish_random_turnleft_counter,x
  bne do_not_turn_pufferfish

  ldy pufferfish_direction,x
  lda pufferfish_turnleft_direction,y
  sta pufferfish_direction,x

  lda pufferfish_pseudo_random_number,x
  sta pufferfish_random_turnleft_counter,x

do_not_turn_pufferfish:
  .endscope

  .scope
  dec pufferfish_random_turnright_counter,x
  bne do_not_turn_pufferfish

  ldy pufferfish_direction,x
  lda pufferfish_turnright_direction,y
  sta pufferfish_direction,x

  ;select random number with an offset
  clc
  lda pufferfish_pseudo_random_number,x
  adc #128
  sta pufferfish_random_turnleft_counter,x

do_not_turn_pufferfish:
  .endscope

  ldy pufferfish_direction,x

  .scope
  lda pufferfish_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda pufferfish_shadow_spot_x_fine,x
  adc pufferfish_direction_speed_x_lo,y
  sta pufferfish_shadow_spot_x_fine,x
  lda pufferfish_shadow_spot_x_lo,x
  adc pufferfish_direction_speed_x_hi,y
  sta pufferfish_shadow_spot_x_lo,x
  lda pufferfish_shadow_spot_x_hi,x
  adc #$00
  sta pufferfish_shadow_spot_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda pufferfish_shadow_spot_x_fine,x
  adc pufferfish_direction_speed_x_lo,y
  sta pufferfish_shadow_spot_x_fine,x
  lda pufferfish_shadow_spot_x_lo,x
  adc pufferfish_direction_speed_x_hi,y
  sta pufferfish_shadow_spot_x_lo,x
  lda pufferfish_shadow_spot_x_hi,x
  adc #$ff
  sta pufferfish_shadow_spot_x_hi,x
done:
  .endscope

  .scope
  lda pufferfish_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda pufferfish_shadow_spot_y_fine,x
  adc pufferfish_direction_speed_y_lo,y
  sta pufferfish_shadow_spot_y_fine,x
  lda pufferfish_shadow_spot_y_lo,x
  adc pufferfish_direction_speed_y_hi,y
  sta pufferfish_shadow_spot_y_lo,x
  lda pufferfish_shadow_spot_y_hi,x
  adc #$00
  sta pufferfish_shadow_spot_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda pufferfish_shadow_spot_y_fine,x
  adc pufferfish_direction_speed_y_lo,y
  sta pufferfish_shadow_spot_y_fine,x
  lda pufferfish_shadow_spot_y_lo,x
  adc pufferfish_direction_speed_y_hi,y
  sta pufferfish_shadow_spot_y_lo,x
  lda pufferfish_shadow_spot_y_hi,x
  adc #$ff
  sta pufferfish_shadow_spot_y_hi,x
done:
  .endscope

  jsr pufferfish_get_animation_params_from_direction

  .scope
  lda bob_velocity_hi,x
  bmi velocity_negative
velocity_positive:
  clc
  lda bob_altitude_fine,x
  adc bob_velocity_lo,x
  sta bob_altitude_fine,x
  lda bob_altitude_lo,x
  adc bob_velocity_hi,x
  sta bob_altitude_lo,x
  lda bob_altitude_hi,x
  adc #0
  sta bob_altitude_hi,x
  jmp done
velocity_negative:
  clc
  lda bob_altitude_fine,x
  adc bob_velocity_lo,x
  sta bob_altitude_fine,x
  lda bob_altitude_lo,x
  adc bob_velocity_hi,x
  sta bob_altitude_lo,x
  lda bob_altitude_hi,x
  adc #$ff
  sta bob_altitude_hi,x
done:
  .endscope

  jsr pufferfish_compute_coordinates

  clc
  lda pufferfish_shadow_spot_x_lo,x
  adc #4
  sta w0
  lda pufferfish_shadow_spot_x_hi,x
  adc #0
  sta w0+1

  lda pufferfish_shadow_spot_y_lo,x
  sta w1
  lda pufferfish_shadow_spot_y_hi,x
  sta w1+1

  jsr sprite_add_shadow_spot

  jsr entity_update_animation

  rts

.endproc

.proc pufferfish_get_animation_params_from_direction

  ;advance puff counter logic
  dec pufferfish_puff_counter,x
  bne :+

  ;flip between offset of 0 and 4 to select puffed and unpuffed animation sets
  lda pufferfish_animation_offset,x
  eor #4
  sta pufferfish_animation_offset,x

  ;reset the puff counter
  lda #PUFFERFISH_PUFF_COUNTER_LENGTH
  sta pufferfish_puff_counter,x

:

  clc
  lda pufferfish_direction,x
  adc pufferfish_animation_offset,x
  tay
  lda pufferfish_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda pufferfish_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda entity_sprite_flags,x
  and #%10111111
  ora pufferfish_sprite_flags_direction,y
  sta entity_sprite_flags,x

  rts

.endproc

.proc pufferfish_compute_coordinates

  sec
  lda pufferfish_shadow_spot_y_lo,x
  sbc bob_altitude_lo,x
  sta entity_y_lo,x
  lda pufferfish_shadow_spot_y_hi,x
  sbc bob_altitude_hi,x
  sta entity_y_hi,x

  rts

.endproc

.endif
