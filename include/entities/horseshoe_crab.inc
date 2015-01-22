.linecont +
.ifndef HORSESHOE_CRAB_INC
HORSESHOE_CRAB_INC = 1

HORSESHOE_CRAB_WIDTH = $0f
HORSESHOE_CRAB_HEIGHT = $0f

.enum
HORSESHOE_CRAB_STATE_INIT
HORSESHOE_CRAB_STATE_MAIN
.endenum

.define horseshoe_crab_states \
  horseshoe_crab_state_init, \
  horseshoe_crab_state_main

horseshoe_crab_lo:
  .lobytes horseshoe_crab_states

horseshoe_crab_hi:
  .hibytes horseshoe_crab_states

horseshoe_crab_update:

  entity_state_switchboard horseshoe_crab_lo, horseshoe_crab_hi

horseshoe_crab_state_init:

  jsr entity_set_drawable

  lda #<horseshoe_crab_walk_side
  sta entity_animation_address_lo,x
  lda #>horseshoe_crab_walk_side
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #HORSESHOE_CRAB_WIDTH
  sta entity_width,x
  lda #HORSESHOE_CRAB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_horseshoe_crab
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #HORSESHOE_CRAB_STATE_MAIN
  sta entity_state,x

  rts

horseshoe_crab_state_main:

  jsr entity_update_animation

  rts

.endif
