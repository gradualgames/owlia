.linecont +
.ifndef JELLYFISH_INC
JELLYFISH_INC = 1

JELLYFISH_WIDTH = $0f
JELLYFISH_HEIGHT = $0f

.enum
JELLYFISH_STATE_INIT
JELLYFISH_STATE_MAIN
.endenum

.define jellyfish_states \
  jellyfish_state_init, \
  jellyfish_state_main

jellyfish_lo:
  .lobytes jellyfish_states

jellyfish_hi:
  .hibytes jellyfish_states

jellyfish_update:

  entity_state_switchboard jellyfish_lo, jellyfish_hi

jellyfish_state_init:

  jsr entity_set_drawable

  lda #<jellyfish
  sta entity_animation_address_lo,x
  lda #>jellyfish
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #JELLYFISH_WIDTH
  sta entity_width,x
  lda #JELLYFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_jellyfish
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #JELLYFISH_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_state_main:

  jsr entity_update_animation

  rts

.endif
