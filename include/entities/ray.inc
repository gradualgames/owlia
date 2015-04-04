.linecont +
.ifndef RAY_INC
RAY_INC = 1

RAY_WIDTH = $0f
RAY_HEIGHT = $0f

.enum
RAY_STATE_INIT
RAY_STATE_MAIN
.endenum

define_lohi_tables ray, \
 {ray_state_init, \
  ray_state_main}

ray_update:

  entity_state_switchboard ray_lo, ray_hi

ray_state_init:

  jsr entity_set_drawable

  lda #<ray_fly_down
  sta entity_animation_address_lo,x
  lda #>ray_fly_down
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #RAY_WIDTH
  sta entity_width,x
  lda #RAY_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_ray
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #RAY_STATE_MAIN
  sta entity_state,x

  rts

ray_state_main:

  jsr entity_update_animation

  rts

.endif
