.linecont +
.ifndef RAY_INC
RAY_INC = 1

.include "ray_constants.inc"

ray_opposite_direction:
  .byte ENTITY_DIRECTION_LEFT
  .byte ENTITY_DIRECTION_RIGHT
  .byte ENTITY_DIRECTION_UP
  .byte ENTITY_DIRECTION_DOWN

define_lohi_tables ray_collision_offset_x, \
  {RAY_HALFWIDTH+14,\
  RAY_HALFWIDTH-12,\
  RAY_HALFWIDTH,\
  RAY_HALFWIDTH}

define_lohi_tables ray_collision_offset_y, \
  {RAY_HALFHEIGHT,\
  RAY_HALFHEIGHT,\
  RAY_HALFHEIGHT+9,\
  RAY_HALFHEIGHT-8}

define_lohi_tables ray_meander_x_velocity, \
  {RAY_SPEED,\
  -RAY_SPEED,\
  0,\
  0}

define_lohi_tables ray_meander_y_velocity, \
  {0,\
   0,\
   RAY_SPEED,\
  -RAY_SPEED}

define_lohi_tables ray_rise_animation_addresses, \
  {ray_rise_side,\
   ray_rise_side,\
   ray_rise_down,\
   ray_rise_up}

define_lohi_tables ray_fall_animation_addresses, \
  {ray_fall_side,\
   ray_fall_side,\
   ray_fall_down,\
   ray_fall_up}

ray_rise_sprite_flags:
  .byte %00000000
  .byte %01000000
  .byte %00000000
  .byte %00000000

ray_fall_sprite_flags:
  .byte %00000000
  .byte %01000000
  .byte %00000000
  .byte %00000000

define_lohi_tables ray_fly_animation_addresses, \
  {ray_fly_side,\
   ray_fly_side,\
   ray_fly_down,\
   ray_fly_up}

ray_fly_sprite_flags:
  .byte %00000000
  .byte %01000000
  .byte %00000000
  .byte %00000000

define_lohi_tables ray, \
 {ray_state_init, \
  ray_state_wait_under_sand, \
  ray_state_rise_from_sand, \
  ray_state_rise, \
  ray_state_meander, \
  ray_state_fall, \
  ray_state_fall_under_sand}

ray_update:

  entity_state_switchboard ray_lo, ray_hi

ray_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #RAY_WIDTH
  sta entity_width,x
  lda #RAY_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_ray
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda entity_x_lo,x
  sta ray_x_lo,x
  lda entity_x_hi,x
  sta ray_x_hi,x
  lda #0
  sta ray_x_fine,x

  lda entity_y_lo,x
  sta ray_y_lo,x
  lda entity_y_hi,x
  sta ray_y_hi,x
  lda #0
  sta ray_y_fine,x

  entity_lda16 ray_x_velocity, 0
  entity_lda16 ray_y_velocity, 0

  entity_lda24 ray_altitude, 0

  entity_lda16 ray_altitude_velocity, 0

  lda #RAY_INITIAL_HEALTH
  sta ray_health,x
  lda #0
  sta ray_knockback_counter,x
  sta ray_flash_counter,x

  jsr position_ray

  jsr ray_randomly_change_direction

  jsr ray_load_rise_animation_from_direction

  lda #RAY_STATE_WAIT_UNDER_SAND_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_WAIT_UNDER_SAND
  sta entity_state,x

  rts

ray_state_wait_under_sand:

  jsr ray_advance_flash_state

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  lda #RAY_STATE_RISE_FROM_SAND_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_RISE_FROM_SAND
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

ray_state_rise_from_sand:

  jsr ray_advance_flash_state

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  jsr entity_set_shadow_spot

  jsr ray_load_fly_animation_from_direction

  entity_lda24 ray_altitude, 0

  lda #<RAY_RISE_SPEED
  sta ray_altitude_velocity_lo,x
  lda #>RAY_RISE_SPEED
  sta ray_altitude_velocity_hi,x

  lda #RAY_STATE_RISE_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_RISE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

ray_state_rise:

  jsr ray_advance_flash_state

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  jsr ray_load_meander_velocity_from_direction

  lda #RAY_STATE_MEANDER
  sta entity_state,x

do_not_transition_yet:
  .endscope

  entity_add_velocity ray_altitude, ray_altitude_velocity

  jsr position_ray

  jsr entity_update_animation

  rts

ray_state_meander:

  jsr ray_combat

  .scope
  sec
  lda #<RAY_FLOAT_ALTITUDE
  sbc ray_altitude_lo,x
  lda #>RAY_FLOAT_ALTITUDE
  sbc ray_altitude_hi,x
  bpl float_up
float_down:
  entity_add_acceleration ray_altitude_velocity, (-RAY_FLOAT_ACCELERATION)
  jmp done
float_up:
  entity_add_acceleration ray_altitude_velocity, RAY_FLOAT_ACCELERATION
done:
  .endscope

  entity_add_velocity ray_x, ray_x_velocity
  entity_add_velocity ray_y, ray_y_velocity
  entity_add_velocity ray_altitude, ray_altitude_velocity

  jsr position_ray

  .scope
  ldy ray_direction,x
  clc
  lda ray_x_lo,x
  adc ray_collision_offset_x_lo,y
  sta w0
  lda ray_x_hi,x
  adc ray_collision_offset_x_hi,y
  sta w0+1

  clc
  lda ray_y_lo,x
  adc ray_collision_offset_y_lo,y
  sta w1
  lda ray_y_hi,x
  adc ray_collision_offset_y_hi,y
  sta w1+1

  jsr map_test_collision
  lda b0
  and #FLAG_SOLID
  beq no_collision

  ldy ray_direction,x
  lda ray_opposite_direction,y
  sta ray_direction,x

  jsr ray_load_meander_velocity_from_direction

  jsr ray_load_fly_animation_from_direction

  jsr entity_update_animation

  rts

no_collision:

  .endscope

  .scope
  dec ray_state_counter,x
  lda ray_state_counter,x
  and #%00111111
  bne do_not_change_direction
  jsr ray_randomly_change_direction

  jsr ray_load_meander_velocity_from_direction

  jsr ray_load_fly_animation_from_direction

  jsr entity_update_animation

  rts

do_not_change_direction:
  .endscope

  .scope
  jsr next_rand
  lda rand
  cmp #20
  bne do_not_transition_to_fall_state

  lda #RAY_STATE_FALL_LENGTH
  sta ray_state_counter,x

  entity_lda16 ray_x_velocity, 0
  entity_lda16 ray_y_velocity, 0
  entity_lda16 ray_altitude_velocity, -RAY_RISE_SPEED

  lda #RAY_STATE_FALL
  sta entity_state,x

do_not_transition_to_fall_state:
  .endscope

  jsr entity_update_animation

  rts

ray_state_fall:

  jsr ray_advance_flash_state

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  jsr entity_clear_shadow_spot

  jsr ray_load_fall_animation_from_direction

  lda #RAY_STATE_FALL_UNDER_SAND_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_FALL_UNDER_SAND
  sta entity_state,x

do_not_transition_yet:
  .endscope

  entity_add_velocity ray_altitude, ray_altitude_velocity

  jsr position_ray

  jsr entity_update_animation

  rts

ray_state_fall_under_sand:

  jsr ray_advance_flash_state

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  jsr ray_load_rise_animation_from_direction

  jsr entity_reset_animation

  lda #RAY_STATE_WAIT_UNDER_SAND_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_WAIT_UNDER_SAND
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

.proc ray_combat

  entity_combat_no_direction #RAY_ATTACKED_LENGTH, #RAY_KNOCKBACK_LENGTH, ray_flash_counter, ray_knockback_counter, ray_health, "entity_drop_random_item"

  rts

.endproc

.proc ray_advance_flash_state

  .scope
  lda ray_flash_counter,x
  beq flash_state_machine_not_running

  dec ray_flash_counter,x

  lda ray_flash_counter,x
  and #%00000011
  sta b10

  lda entity_sprite_flags,x
  and #%11111100
  ora b10
  sta entity_sprite_flags,x

flash_state_machine_not_running:
  .endscope

  rts

.endproc

.proc ray_randomly_change_direction

  .scope
try_again:
  jsr next_rand
  lda rand
  and #3
  cmp ray_direction,x
  beq try_again
  sta ray_direction,x
  .endscope

  rts

.endproc

.proc ray_load_meander_velocity_from_direction

  ldy ray_direction,x
  lda ray_meander_x_velocity_lo,y
  sta ray_x_velocity_lo,x
  lda ray_meander_x_velocity_hi,y
  sta ray_x_velocity_hi,x

  lda ray_meander_y_velocity_lo,y
  sta ray_y_velocity_lo,x
  lda ray_meander_y_velocity_hi,y
  sta ray_y_velocity_hi,x

  rts

.endproc

.proc ray_load_fall_animation_from_direction

  ldy ray_direction,x
  lda ray_fall_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda ray_fall_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda ray_fall_sprite_flags,y
  sta entity_sprite_flags,x

  jsr entity_reset_animation

  rts

.endproc

.proc ray_load_rise_animation_from_direction

  ldy ray_direction,x
  lda ray_rise_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda ray_rise_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda ray_rise_sprite_flags,y
  sta entity_sprite_flags,x

  jsr entity_reset_animation

  rts

.endproc

.proc ray_load_fly_animation_from_direction

  ldy ray_direction,x
  lda ray_fly_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda ray_fly_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda ray_fly_sprite_flags,y
  sta entity_sprite_flags,x

  jsr entity_reset_animation

  rts

.endproc

.proc position_ray

  entity_move16 ray_x, entity_x

  sec
  lda ray_y_lo,x
  sbc ray_altitude_lo,x
  sta entity_y_lo,x
  lda ray_y_hi,x
  sbc ray_altitude_hi,x
  sta entity_y_hi,x

  entity_lda16 entity_shadow_spot_x, 4

  entity_move16 ray_altitude, entity_shadow_spot_y

  rts

.endproc

.endif
