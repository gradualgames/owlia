.linecont +
.ifndef URCHIN_INC
URCHIN_INC = 1

URCHIN_WIDTH = $0f
URCHIN_HEIGHT = $0f

.enum
URCHIN_STATE_INIT
URCHIN_STATE_MAIN
.endenum

.define urchin_states \
  urchin_state_init, \
  urchin_state_main

urchin_lo:
  .lobytes urchin_states

urchin_hi:
  .hibytes urchin_states

urchin_update:

  entity_state_switchboard urchin_lo, urchin_hi

urchin_state_init:

  jsr entity_set_drawable

  lda #<urchin
  sta entity_animation_address_lo,x
  lda #>urchin
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #URCHIN_WIDTH
  sta entity_width,x
  lda #URCHIN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_urchin
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #URCHIN_STATE_MAIN
  sta entity_state,x

  rts

urchin_state_main:

  jsr entity_update_animation

  rts

.endif
