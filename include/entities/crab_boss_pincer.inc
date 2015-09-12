.linecont +
.ifndef CRAB_BOSS_PINCER_INC
CRAB_BOSS_PINCER_INC = 1

.include "crab_boss_pincer_constants.inc"

.define crab_boss_pincer_states \
  crab_boss_pincer_state_init, \
  crab_boss_pincer_state_main, \
  crab_boss_pincer_state_punch, \
  crab_boss_pincer_state_idle

;lut using animation frame to index, so every other entry is 0
crab_boss_pincer_height:
  .byte $0f, $00
  .byte $0f + 8, $00
  .byte $0f + 16, $00
  .byte $0f + 8, $00
  .byte $0f, $00

crab_boss_pincer_lo:
  .lobytes crab_boss_pincer_states

crab_boss_pincer_hi:
  .hibytes crab_boss_pincer_states

crab_boss_pincer_update:

  entity_state_switchboard crab_boss_pincer_lo, crab_boss_pincer_hi

crab_boss_pincer_state_init:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  jsr entity_set_is_enemy

  lda #<crab_boss_pincer_open
  sta entity_animation_address_lo,x
  lda #>crab_boss_pincer_open
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_BOSS_PINCER_WIDTH
  sta entity_width,x
  lda #CRAB_BOSS_PINCER_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_crab_boss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #0
  sta crab_boss_pincer_flash_counter,x

  lda #CRAB_BOSS_PINCER_STATE_MAIN
  sta entity_state,x

  rts

crab_boss_pincer_state_main:

  entity_advance_flash_state crab_boss_pincer_flash_counter

  jsr crab_boss_pincer_combat

  .scope
  dec crab_boss_pincer_state_counter,x
  bne do_not_transition_yet

  lda #<crab_boss_pincer_punch
  sta entity_animation_address_lo,x
  lda #>crab_boss_pincer_punch
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda crab_boss_pincer_punch_length,x
  sta crab_boss_pincer_state_counter,x

  lda #CRAB_BOSS_PINCER_STATE_PUNCH
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

crab_boss_pincer_state_punch:

  jsr crab_boss_pincer_combat

  .scope
  dec crab_boss_pincer_state_counter,x
  bne do_not_transition_yet

  lda #<crab_boss_pincer_open
  sta entity_animation_address_lo,x
  lda #>crab_boss_pincer_open
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda crab_boss_pincer_punch_delay,x
  sta crab_boss_pincer_state_counter,x

  lda #CRAB_BOSS_PINCER_STATE_MAIN
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

crab_boss_pincer_state_idle:

  rts

.proc crab_boss_pincer_combat

  ldy entity_animation_frame,x
  lda crab_boss_pincer_height,y
  sta entity_height,x

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  rts

.endproc

.endif
