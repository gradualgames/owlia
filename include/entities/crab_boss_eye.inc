.linecont +
.ifndef CRAB_BOSS_EYE_INC
CRAB_BOSS_EYE_INC = 1

.include "crab_boss_eye_constants.inc"

.define crab_boss_eye_states \
  crab_boss_eye_state_init, \
  crab_boss_eye_state_main, \
  crab_boss_eye_state_wait_til_not_fetched

crab_boss_eye_lo:
  .lobytes crab_boss_eye_states

crab_boss_eye_hi:
  .hibytes crab_boss_eye_states

crab_boss_eye_update:

  entity_state_switchboard crab_boss_eye_lo, crab_boss_eye_hi

crab_boss_eye_state_init:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  lda #<crab_boss_eye_open
  sta entity_animation_address_lo,x
  lda #>crab_boss_eye_open
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

  ldy crab_boss_eye_body,x

  clc
  lda entity_x_lo,y
  adc crab_boss_eye_x_offset,x
  sta entity_x_lo,x
  lda entity_x_hi,y
  adc #0
  sta entity_x_hi,x

  clc
  lda entity_y_lo,y
  adc crab_boss_eye_y_offset,x
  sta entity_y_lo,x
  lda entity_y_hi,y
  adc #0
  sta entity_y_hi,x

  .scope
  lda familiar_carried_entity_index
  bpl familiar_already_fetching
  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_FETCH
  bne familiar_not_fetching

  jsr entity_test_entity_action_rect2
  bne familiar_not_intersecting

  ;store offsets for this entity when it is being fetched by familiar
  lda #CRAB_BOSS_EYE_FETCH_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #CRAB_BOSS_EYE_FETCH_Y_OFFSET
  sta familiar_carried_entity_y_offset

  ;tell the familiar to return to the hero with the fetched item.
  far_call #FAMILIAR_BANK, familiar_fetch_current_item

  lda #CRAB_BOSS_EYE_STATE_WAIT_TIL_NOT_FETCHED
  sta entity_state,x

familiar_not_intersecting:
familiar_not_fetching:
familiar_already_fetching:
  .endscope

  jsr entity_update_animation

  rts

crab_boss_eye_state_wait_til_not_fetched:

  rts

.endif
