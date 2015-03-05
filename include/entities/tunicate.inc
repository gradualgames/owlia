.linecont +
.ifndef TUNICATE_INC
TUNICATE_INC = 1

TUNICATE_WIDTH = $0f
TUNICATE_HEIGHT = $0f

.enum
TUNICATE_STATE_INIT
TUNICATE_STATE_MAIN
.endenum

.define tunicate_states \
  tunicate_state_init, \
  tunicate_state_main

tunicate_lo:
  .lobytes tunicate_states

tunicate_hi:
  .hibytes tunicate_states

tunicate_update:

  entity_state_switchboard tunicate_lo, tunicate_hi

tunicate_state_init:

  jsr entity_set_drawable

  lda #<tunicate
  sta entity_animation_address_lo,x
  lda #>tunicate
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TUNICATE_WIDTH
  sta entity_width,x
  lda #TUNICATE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_tunicate
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #TUNICATE_STATE_MAIN
  sta entity_state,x

  rts

tunicate_state_main:

  jsr entity_update_animation

  rts

.endif
