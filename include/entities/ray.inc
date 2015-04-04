.linecont +
.ifndef RAY_INC
RAY_INC = 1

.include "ray_constants.inc"

define_lohi_tables ray_rise_animation_addresses, \
  {ray_rise_side,\
   ray_rise_side,\
   ray_rise_down,\
   ray_rise_up}

ray_rise_sprite_flags:
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
  ray_state_rise}

ray_update:

  entity_state_switchboard ray_lo, ray_hi

ray_state_init:

  jsr entity_set_drawable

  lda #RAY_WIDTH
  sta entity_width,x
  lda #RAY_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_ray
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda ray_initial_direction,x
  sta ray_direction,x

  jsr ray_load_rise_animation_from_direction

  lda #RAY_STATE_WAIT_UNDER_SAND_LENGTH
  sta ray_state_counter,x

  lda #RAY_STATE_WAIT_UNDER_SAND
  sta entity_state,x

  rts

ray_state_wait_under_sand:

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

  .scope
  dec ray_state_counter,x
  bne do_not_transition_yet

  jsr ray_load_fly_animation_from_direction

  lda #RAY_STATE_RISE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

ray_state_rise:

  jsr entity_update_animation

  rts

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

.endif
