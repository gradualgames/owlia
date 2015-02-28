.linecont +
.ifndef CRAB_BOSS_EYE_INC
CRAB_BOSS_EYE_INC = 1

.include "crab_boss_eye_constants.inc"

.define crab_boss_eye_states \
  crab_boss_eye_state_init, \
  crab_boss_eye_state_wait_til_fetched, \
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

  jsr entity_set_is_enemy

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

  lda #0
  sta crab_boss_eye_flash_counter,x
  sta crab_boss_eye_knockback_counter,x
  sta crab_boss_eye_direction,x

  lda #CRAB_BOSS_EYE_INITIAL_HEALTH
  sta crab_boss_eye_health,x

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

  lda #CRAB_BOSS_EYE_STATE_WAIT_TIL_FETCHED
  sta entity_state,x

  rts

crab_boss_eye_state_wait_til_fetched:

  entity_advance_flash_state crab_boss_eye_flash_counter

  jsr crab_boss_eye_float_back_to_body

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

  entity_harmless_combat #CRAB_BOSS_EYE_ATTACKED_LENGTH, #CRAB_BOSS_EYE_KNOCKBACK_LENGTH, crab_boss_eye_flash_counter, crab_boss_eye_knockback_counter, crab_boss_eye_health, crab_boss_eye_direction

  .scope
  cpx familiar_carried_entity_index
  beq still_fetched
no_longer_fetched:

  jsr crab_boss_eye_float_back_to_body

  lda #0
  sta crab_boss_eye_x_fine,x
  sta crab_boss_eye_y_fine,x

  lda #CRAB_BOSS_EYE_STATE_WAIT_TIL_FETCHED
  sta entity_state,x

still_fetched:
  .endscope

  rts

.proc crab_boss_eye_float_back_to_body

  ;calculate goal of where eye will float to (end of stalk on crab body)
  ldy crab_boss_eye_body,x

  clc
  lda entity_x_lo,y
  adc crab_boss_eye_x_offset,x
  sta w0
  lda entity_x_hi,y
  adc #0
  sta w0+1

  clc
  lda entity_y_lo,y
  adc crab_boss_eye_y_offset,x
  sta w1
  lda entity_y_hi,y
  adc #0
  sta w1+1

  ;calculate initial velocity as distance between goal and current location of eye
  sec
  lda w0
  sbc entity_x_lo,x
  sta crab_boss_eye_x_velocity_lo,x
  lda w0+1
  sbc entity_x_hi,x
  sta crab_boss_eye_x_velocity_hi,x

  sec
  lda w1
  sbc entity_y_lo,x
  sta crab_boss_eye_y_velocity_lo,x
  lda w1+1
  sbc entity_y_hi,x
  sta crab_boss_eye_y_velocity_hi,x

  ;now modify velocity so the eye floats towards the eye stalk slowly
  lda crab_boss_eye_x_velocity_hi,x
  asl crab_boss_eye_x_velocity_lo,x
  rol
  asl crab_boss_eye_x_velocity_lo,x
  rol
  asl crab_boss_eye_x_velocity_lo,x
  rol
  asl crab_boss_eye_x_velocity_lo,x
  rol
  asl crab_boss_eye_x_velocity_lo,x
  rol
  asl crab_boss_eye_x_velocity_lo,x
  rol
  sta crab_boss_eye_x_velocity_hi,x

  lda crab_boss_eye_y_velocity_hi,x
  asl crab_boss_eye_y_velocity_lo,x
  rol
  asl crab_boss_eye_y_velocity_lo,x
  rol
  asl crab_boss_eye_y_velocity_lo,x
  rol
  asl crab_boss_eye_y_velocity_lo,x
  rol
  asl crab_boss_eye_y_velocity_lo,x
  rol
  asl crab_boss_eye_y_velocity_lo,x
  rol
  sta crab_boss_eye_y_velocity_hi,x

  ;add x and y velocity to the coordinates with sign extension
  .scope
  lda #0
  sta b0
  lda crab_boss_eye_x_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  clc
  lda crab_boss_eye_x_fine,x
  adc crab_boss_eye_x_velocity_lo,x
  sta crab_boss_eye_x_fine,x

  lda entity_x_lo,x
  adc crab_boss_eye_x_velocity_hi,x
  sta entity_x_lo,x

  lda entity_x_hi,x
  adc b0
  sta entity_x_hi,x
  .endscope

  .scope
  lda #0
  sta b0
  lda crab_boss_eye_y_velocity_hi,x
  bpl sign_extend_positive
sign_extend_negative:
  lda #$ff
  sta b0
sign_extend_positive:

  clc
  lda crab_boss_eye_y_fine,x
  adc crab_boss_eye_y_velocity_lo,x
  sta crab_boss_eye_y_fine,x

  lda entity_y_lo,x
  adc crab_boss_eye_y_velocity_hi,x
  sta entity_y_lo,x

  lda entity_y_hi,x
  adc b0
  sta entity_y_hi,x
  .endscope

  rts

.endproc

.endif
