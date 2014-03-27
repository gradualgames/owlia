.linecont +
.ifndef SPOTLIGHT_INC
SPOTLIGHT_INC = 1

SPOTLIGHT_WIDTH = $0f
SPOTLIGHT_HEIGHT = $0f

.enum
SPOTLIGHT_STATE_INIT
SPOTLIGHT_STATE_MAIN
.endenum

.define spotlight_states \
  spotlight_state_init, \
  spotlight_state_main

spotlight_lo:
  .lobytes spotlight_states

spotlight_hi:
  .hibytes spotlight_states

spotlight_update:

  entity_state_switchboard spotlight_lo, spotlight_hi

spotlight_state_init:

  lda #<SpotLight
  sta entity_animation_address_lo,x
  lda #>SpotLight
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SPOTLIGHT_WIDTH
  sta entity_width,x
  lda #SPOTLIGHT_HEIGHT
  sta entity_height,x

  lda #sprite_chr_group_index_spotlight
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #SPOTLIGHT_STATE_MAIN
  sta entity_state,x

  rts

spotlight_state_main:

  lda entity_flags,x
  eor #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  jsr entity_update_animation

  rts

.endif
