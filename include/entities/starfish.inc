.linecont +
.ifndef STARFISH_INC
STARFISH_INC = 1

STARFISH_WIDTH = $0f
STARFISH_HEIGHT = $0f
STARFISH_RISE_ACCELERATION = -5
STARFISH_RISE_LENGTH = 50
STARFISH_FLOAT_ACCELERATION = 25
STARFISH_FLOAT_ALTITUDE = 25
STARFISH_MEANDER_ACCELERATION = 5

starfish_x_lo = entity_local0
starfish_x_hi = entity_local1
starfish_x_fine = entity_local2
starfish_y_lo = entity_local3
starfish_y_hi = entity_local4
starfish_y_fine = entity_local5
starfish_x_velocity_lo = entity_local6
starfish_x_velocity_hi = entity_local7
starfish_y_velocity_lo = entity_local8
starfish_y_velocity_hi = entity_local9
starfish_altitude_lo = entity_local10
starfish_altitude_hi = entity_local11
starfish_altitude_fine = entity_local12
starfish_altitude_velocity_lo = entity_local13
starfish_altitude_velocity_hi = entity_local14
starfish_state_counter = entity_local15

.enum
STARFISH_STATE_INIT
STARFISH_STATE_REST
STARFISH_STATE_RISE
STARFISH_STATE_FLOAT
.endenum

.define starfish_states \
  starfish_state_init, \
  starfish_state_rest, \
  starfish_state_rise, \
  starfish_state_float

starfish_lo:
  .lobytes starfish_states

starfish_hi:
  .hibytes starfish_states

starfish_update:

  entity_state_switchboard starfish_lo, starfish_hi

starfish_state_init:

  jsr entity_set_drawable

  jsr entity_set_shadow_spot

  lda #<starfish
  sta entity_animation_address_lo,x
  lda #>starfish
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #STARFISH_WIDTH
  sta entity_width,x
  lda #STARFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_starfish
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda entity_x_lo,x
  sta starfish_x_lo,x
  lda entity_x_hi,x
  sta starfish_x_hi,x
  lda #0
  sta starfish_x_fine,x

  lda entity_y_lo,x
  sta starfish_y_lo,x
  lda entity_y_hi,x
  sta starfish_y_hi,x
  lda #0
  sta starfish_y_fine,x

  lda16 starfish_x_velocity, 0
  lda16 starfish_y_velocity, 0

  lda24 starfish_altitude, 0

  lda16 starfish_altitude_velocity, 0

  jsr position_starfish

  lda rand
  ora #1
  sta starfish_state_counter,x

  lda #STARFISH_STATE_REST
  sta entity_state,x

  rts

starfish_state_rest:

  .scope
  dec starfish_state_counter,x
  bne do_not_transition_yet

  lda #STARFISH_RISE_LENGTH
  sta starfish_state_counter,x

  lda #STARFISH_STATE_RISE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

starfish_state_rise:

  .scope
  dec starfish_state_counter,x
  bne do_not_transition_yet

  lda #STARFISH_STATE_FLOAT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  add_acceleration starfish_altitude_velocity, STARFISH_RISE_ACCELERATION

  jsr starfish_move

  jsr position_starfish

  jsr entity_update_animation

  rts

starfish_state_float:

  .scope
  sec
  lda #<STARFISH_FLOAT_ALTITUDE
  sbc starfish_altitude_lo,x
  lda #>STARFISH_FLOAT_ALTITUDE
  sbc starfish_altitude_hi,x
  bmi float_up
float_down:
  add_acceleration starfish_altitude_velocity, (-STARFISH_FLOAT_ACCELERATION)
  jmp done
float_up:
  add_acceleration starfish_altitude_velocity, STARFISH_FLOAT_ACCELERATION
done:
  .endscope

  jsr starfish_move

  jsr position_starfish

  jsr entity_update_animation

  rts

.proc starfish_move

  add_velocity starfish_altitude, starfish_altitude_velocity
  add_velocity starfish_x, starfish_x_velocity
  add_velocity starfish_y, starfish_y_velocity

  rts

.endproc

.proc position_starfish

  move16 starfish_x, entity_x

  sec
  lda starfish_y_lo,x
  sbc starfish_altitude_lo,x
  sta entity_y_lo,x
  lda starfish_y_hi,x
  sbc starfish_altitude_hi,x
  sta entity_y_hi,x

  lda16 entity_shadow_spot_x, 8

  move16 starfish_altitude, entity_shadow_spot_y

  rts

.endproc

.endif
