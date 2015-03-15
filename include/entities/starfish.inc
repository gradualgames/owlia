.linecont +
.ifndef STARFISH_INC
STARFISH_INC = 1

STARFISH_INITIAL_HEALTH = 3
STARFISH_WIDTH = 23
STARFISH_HEIGHT = 15
STARFISH_TIME_TIL_RISE = 50
STARFISH_RISE_ACCELERATION = 5
STARFISH_RISE_LENGTH = 50
STARFISH_FLOAT_ACCELERATION = 25
STARFISH_FLOAT_ALTITUDE = 25
STARFISH_MEANDER_VELOCITY = 200
STARFISH_ATTACKED_LENGTH = 20
STARFISH_KNOCKBACK_LENGTH = 20

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
starfish_meander_direction = entity_local16
starfish_flash_counter = entity_local17
starfish_knockback_counter = entity_local18
starfish_health = entity_local19

define_lohi_tables \
  starfish_meander_x_velocity, \
  {STARFISH_MEANDER_VELOCITY, \
  -STARFISH_MEANDER_VELOCITY, \
   0, \
   0}

define_lohi_tables \
  starfish_meander_y_velocity, \
  {0, \
  0, \
  -STARFISH_MEANDER_VELOCITY, \
  STARFISH_MEANDER_VELOCITY}

.enum
STARFISH_STATE_INIT
STARFISH_STATE_REST
STARFISH_STATE_RISE
STARFISH_STATE_FLOAT
.endenum

  define_lohi_tables starfish, \
    {starfish_state_init, \
    starfish_state_rest, \
    starfish_state_rise, \
    starfish_state_float}

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

  entity_lda16 starfish_x_velocity, 0
  entity_lda16 starfish_y_velocity, 0

  entity_lda24 starfish_altitude, 0

  entity_lda16 starfish_altitude_velocity, 0

  lda #0
  sta starfish_meander_direction,x
  sta starfish_flash_counter,x
  sta starfish_knockback_counter,x

  lda #STARFISH_INITIAL_HEALTH
  sta starfish_health,x

  jsr position_starfish

  lda #STARFISH_TIME_TIL_RISE
  sta starfish_state_counter,x

  lda #STARFISH_STATE_REST
  sta entity_state,x

  rts

starfish_state_rest:

  jsr starfish_combat

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

  jsr starfish_combat

  .scope
  dec starfish_state_counter,x
  bne do_not_transition_yet

  lda #STARFISH_STATE_FLOAT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  entity_add_acceleration starfish_altitude_velocity, STARFISH_RISE_ACCELERATION

  jsr starfish_move

  jsr position_starfish

  jsr entity_update_animation

  rts

starfish_state_float:

  jsr starfish_combat

  dec starfish_state_counter,x
  lda starfish_state_counter,x
  and #%01100000
  beq :+
  lda rand
  and #%01100000
  rol
  rol
  rol
  rol
  and #%00000011
  sta starfish_meander_direction,x
:

  ldy starfish_meander_direction,x
  lda starfish_meander_x_velocity_lo,y
  sta starfish_x_velocity_lo,x
  lda starfish_meander_x_velocity_hi,y
  sta starfish_x_velocity_hi,x

  lda starfish_meander_y_velocity_lo,y
  sta starfish_y_velocity_lo,x
  lda starfish_meander_y_velocity_hi,y
  sta starfish_y_velocity_hi,x

  .scope
  sec
  lda #<STARFISH_FLOAT_ALTITUDE
  sbc starfish_altitude_lo,x
  lda #>STARFISH_FLOAT_ALTITUDE
  sbc starfish_altitude_hi,x
  bpl float_up
float_down:
  entity_add_acceleration starfish_altitude_velocity, (-STARFISH_FLOAT_ACCELERATION)
  jmp done
float_up:
  entity_add_acceleration starfish_altitude_velocity, STARFISH_FLOAT_ACCELERATION
done:
  .endscope

  jsr starfish_move

  jsr position_starfish

  jsr entity_update_animation

  rts

.proc starfish_combat

  entity_combat #STARFISH_ATTACKED_LENGTH, #STARFISH_KNOCKBACK_LENGTH, starfish_flash_counter, starfish_knockback_counter, starfish_health, starfish_meander_direction
  rts

.endproc

.proc starfish_move

  entity_add_velocity starfish_altitude, starfish_altitude_velocity
  entity_add_velocity starfish_x, starfish_x_velocity
  entity_add_velocity starfish_y, starfish_y_velocity

  rts

.endproc

.proc position_starfish

  entity_move16 starfish_x, entity_x

  sec
  lda starfish_y_lo,x
  sbc starfish_altitude_lo,x
  sta entity_y_lo,x
  lda starfish_y_hi,x
  sbc starfish_altitude_hi,x
  sta entity_y_hi,x

  entity_lda16 entity_shadow_spot_x, 8

  entity_move16 starfish_altitude, entity_shadow_spot_y

  rts

.endproc

.endif
