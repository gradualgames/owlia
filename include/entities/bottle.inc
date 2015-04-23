.linecont +
.ifndef BOTTLE_INC
BOTTLE_INC = 1

.include "bottle_constants.inc"

define_lohi_tables bottle, \
 {bottle_state_init, \
  bottle_state_ring_off, \
  bottle_state_place_ring_on, \
  bottle_state_ring_on}

bottle_update:

  entity_state_switchboard bottle_lo, bottle_hi

bottle_state_init:

  jsr entity_set_drawable

  lda #<bottle
  sta entity_animation_address_lo,x
  lda #>bottle
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #BOTTLE_WIDTH
  sta entity_width,x
  lda #BOTTLE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  clc
  lda entity_x_lo,x
  adc bottle_initial_x_offset,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #0
  sta entity_x_hi,x

  lda #BOTTLE_STATE_RING_OFF
  sta entity_state,x

  rts

bottle_state_ring_off:

  jsr entity_update_animation

  rts

bottle_state_place_ring_on:

  lda #<bottle_ring
  sta entity_animation_address_lo,x
  lda #>bottle_ring
  sta entity_animation_address_hi,x

  lda #BOTTLE_STATE_RING_ON
  sta entity_state,x

  rts

bottle_state_ring_on:

  jsr entity_update_animation

  rts

.endif
