.linecont +
.ifndef SILMARAN_INC
SILMARAN_INC = 1

SILMARAN_WIDTH = $0f
SILMARAN_HEIGHT = $0f

.enum
SILMARAN_STATE_INIT
SILMARAN_STATE_MAIN
.endenum

.define silmaran_states \
  silmaran_state_init, \
  silmaran_state_main

silmaran_lo:
  .lobytes silmaran_states

silmaran_hi:
  .hibytes silmaran_states

silmaran_update:

  entity_state_switchboard silmaran_lo, silmaran_hi

silmaran_state_init:

  jsr entity_set_drawable

  lda #<SilmaranDescend
  sta entity_animation_address_lo,x
  lda #>SilmaranDescend
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SILMARAN_WIDTH
  sta entity_width,x
  lda #SILMARAN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_silmaran
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #SILMARAN_STATE_MAIN
  sta entity_state,x

  rts

silmaran_state_main:

  jsr entity_update_animation

  rts

.endif
