.linecont +
.ifndef INTRO_INC
INTRO_INC = 1

INTRO_WIDTH = $0f
INTRO_HEIGHT = $0f

.enum
INTRO_STATE_INIT
INTRO_STATE_MAIN
.endenum

.define intro_states \
  intro_state_init, \
  intro_state_main

intro_lo:
  .lobytes intro_states

intro_hi:
  .hibytes intro_states

intro_update:

  entity_state_switchboard intro_lo, intro_hi

intro_state_init:

  jsr entity_set_drawable

  lda #<TytoWake
  sta entity_animation_address_lo,x
  lda #>TytoWake
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #INTRO_WIDTH
  sta entity_width,x
  lda #INTRO_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_tyto
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #INTRO_STATE_MAIN
  sta entity_state,x

  rts

intro_state_main:

  rts

.endif
