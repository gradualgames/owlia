.linecont +
.ifndef CRAB_BOSS_EYE_INC
CRAB_BOSS_EYE_INC = 1

CRAB_BOSS_EYE_WIDTH = $0f
CRAB_BOSS_EYE_HEIGHT = $0f

.enum
CRAB_BOSS_EYE_STATE_INIT
CRAB_BOSS_EYE_STATE_MAIN
.endenum

.define crab_boss_eye_states \
  crab_boss_eye_state_init, \
  crab_boss_eye_state_main

crab_boss_eye_lo:
  .lobytes crab_boss_eye_states

crab_boss_eye_hi:
  .hibytes crab_boss_eye_states

crab_boss_eye_update:

  entity_state_switchboard crab_boss_eye_lo, crab_boss_eye_hi

crab_boss_eye_state_init:

  jsr entity_set_drawable

  lda #<crab_boss_eye
  sta entity_animation_address_lo,x
  lda #>crab_boss_eye
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_BOSS_EYE_WIDTH
  sta entity_width,x
  lda #CRAB_BOSS_EYE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_crab_boss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #CRAB_BOSS_EYE_STATE_MAIN
  sta entity_state,x

  rts

crab_boss_eye_state_main:

  jsr entity_update_animation

  rts

.endif
