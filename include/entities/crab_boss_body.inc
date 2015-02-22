.linecont +
.ifndef CRAB_BOSS_BODY_INC
CRAB_BOSS_BODY_INC = 1

CRAB_BOSS_BODY_WIDTH = $0f
CRAB_BOSS_BODY_HEIGHT = $0f

.enum
CRAB_BOSS_BODY_STATE_INIT
CRAB_BOSS_BODY_STATE_MAIN
.endenum

.define crab_boss_body_states \
  crab_boss_body_state_init, \
  crab_boss_body_state_main

crab_boss_body_lo:
  .lobytes crab_boss_body_states

crab_boss_body_hi:
  .hibytes crab_boss_body_states

crab_boss_body_update:

  entity_state_switchboard crab_boss_body_lo, crab_boss_body_hi

crab_boss_body_state_init:

  jsr entity_set_drawable

  lda #<crab_boss_walk
  sta entity_animation_address_lo,x
  lda #>crab_boss_walk
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_BOSS_BODY_WIDTH
  sta entity_width,x
  lda #CRAB_BOSS_BODY_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_crab_boss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%01000000
  sta entity_sprite_flags,x

  lda #CRAB_BOSS_BODY_STATE_MAIN
  sta entity_state,x

  rts

crab_boss_body_state_main:

  jsr entity_update_animation

  rts

.endif
