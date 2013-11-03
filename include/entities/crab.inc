.linecont +
.ifndef CRAB_INC
CRAB_INC = 1

CRAB_WIDTH = $0f
CRAB_HEIGHT = $0f

.enum
CRAB_STATE_INIT
CRAB_STATE_MAIN
.endenum

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

  lda #<CrabWalk
  sta entity_animation_address_lo,x
  lda #>CrabWalk
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_WIDTH
  sta entity_width,x
  lda #CRAB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_crab
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #CRAB_STATE_MAIN
  sta entity_state,x

  rts

crab_state_main:

  jsr entity_update_animation

  rts

.endif
