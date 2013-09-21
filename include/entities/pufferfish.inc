.linecont +
.ifndef PUFFERFISH_INC
PUFFERFISH_INC = 1

PUFFERFISH_WIDTH = $0f
PUFFERFISH_HEIGHT = $0f

.enum
PUFFERFISH_STATE_INIT
PUFFERFISH_STATE_MAIN
.endenum

.define pufferfish_states \
  pufferfish_state_init, \
  pufferfish_state_main

pufferfish_lo:
  .lobytes pufferfish_states

pufferfish_hi:
  .hibytes pufferfish_states

pufferfish_update:

  entity_state_switchboard pufferfish_lo, pufferfish_hi

pufferfish_state_init:

  jsr entity_set_drawable

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

  lda #PUFFERFISH_STATE_MAIN
  sta entity_state,x

  rts

pufferfish_state_main:

  jsr entity_update_animation

  rts

.endif
