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

  jsr entity_set_drawable

  lda #<SpotLight
  sta entity_animation_address_lo,x
  lda #>SpotLight
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SPOTLIGHT_WIDTH
  sta entity_width,x
  lda #SPOTLIGHT_HEIGHT
  sta entity_height,x

  ldy #sprite_chr_group_index_spotlight
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #SPOTLIGHT_STATE_MAIN
  sta entity_state,x

  rts

spotlight_state_main:

  jsr entity_update_animation

  rts

.endif
