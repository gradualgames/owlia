.linecont +
.ifndef CRAB_BOSS_BODY_INC
CRAB_BOSS_BODY_INC = 1

.include "crab_boss_body_constants.inc"
.include "crab_boss_eye_constants.inc"
.include "crab_boss_pincer_constants.inc"

.define crab_boss_body_states \
  crab_boss_body_state_init, \
  crab_boss_body_state_walk_left, \
  crab_boss_body_state_walk_right, \
  crab_boss_body_state_init_rush, \
  crab_boss_body_state_rush, \
  crab_boss_body_state_rush_back

crab_boss_body_lo:
  .lobytes crab_boss_body_states

crab_boss_body_hi:
  .hibytes crab_boss_body_states

crab_boss_body_update:

  entity_state_switchboard crab_boss_body_lo, crab_boss_body_hi

crab_boss_body_state_init:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  jsr entity_set_is_enemy

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

  ;spawn and track crab boss's first eye
  .scope
  lda #entity_index_crab_boss_eye
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta crab_boss_body_eye0,x

  ;configure the eye
  ldy spawned_entity
  lda #CRAB_BOSS_BODY_EYE0_OFFSET_X
  sta crab_boss_eye_x_offset,y
  lda #CRAB_BOSS_BODY_EYE0_OFFSET_Y
  sta crab_boss_eye_y_offset,y

  ;tell the eye about its parent, which is this body entity
  txa
  sta crab_boss_eye_body,y
  .endscope

  ;spawn and track crab boss's second eye
  .scope
  lda #entity_index_crab_boss_eye
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta crab_boss_body_eye1,x

  ;configure the eye
  ldy spawned_entity
  lda #CRAB_BOSS_BODY_EYE1_OFFSET_X
  sta crab_boss_eye_x_offset,y
  lda #CRAB_BOSS_BODY_EYE1_OFFSET_Y
  sta crab_boss_eye_y_offset,y

  ;tell the eye about its parent, which is this body entity
  txa
  sta crab_boss_eye_body,y
  .endscope

  ;spawn and track crab boss's first pincer
  .scope
  lda #entity_index_crab_boss_pincer
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta crab_boss_body_pincer0,x

  ;configure the pincer
  ldy spawned_entity
  lda #CRAB_BOSS_BODY_PINCER0_PUNCH_DELAY
  sta crab_boss_pincer_punch_delay,y
  lda #CRAB_BOSS_BODY_PINCER0_PUNCH_LENGTH
  sta crab_boss_pincer_punch_length,y
  lda #CRAB_BOSS_BODY_PINCER0_INITIAL_STATE_COUNTER
  sta crab_boss_pincer_state_counter,y
  .endscope

  ;spawn and track crab boss's second pincer
  .scope
  lda #entity_index_crab_boss_pincer
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta crab_boss_body_pincer1,x

  ;configure the pincer
  ldy spawned_entity
  lda #CRAB_BOSS_BODY_PINCER1_PUNCH_DELAY
  sta crab_boss_pincer_punch_delay,y
  lda #CRAB_BOSS_BODY_PINCER1_PUNCH_LENGTH
  sta crab_boss_pincer_punch_length,y
  lda #CRAB_BOSS_BODY_PINCER1_INITIAL_STATE_COUNTER
  sta crab_boss_pincer_state_counter,y
  .endscope

  jsr crab_boss_position_pincers

  lda #%01000000
  sta entity_sprite_flags,x

  lda #0
  sta crab_boss_body_flash_counter,x

  lda #CRAB_BOSS_BODY_TIME_TIL_RUSH
  sta crab_boss_body_state_rush_counter,x

  lda #CRAB_BOSS_BODY_WALK_RIGHT_LENGTH
  sta crab_boss_body_state_counter,x

  lda #CRAB_BOSS_BODY_STATE_WALK_RIGHT
  sta entity_state,x

  rts

crab_boss_body_state_walk_left:

  jsr crab_boss_combat

  .scope
  dec crab_boss_body_state_rush_counter,x
  bne do_not_transition_yet

  lda #CRAB_BOSS_BODY_STATE_WALK_LEFT
  sta crab_boss_body_previous_state,x

  lda #CRAB_BOSS_BODY_STATE_INIT_RUSH_LENGTH
  sta crab_boss_body_state_rush_counter,x

  lda #CRAB_BOSS_BODY_STATE_INIT_RUSH
  sta entity_state,x

  rts
do_not_transition_yet:
  .endscope

  .scope
  dec crab_boss_body_state_counter,x
  bne do_not_transition_yet

  lda #%01000000
  sta entity_sprite_flags,x

  lda #CRAB_BOSS_BODY_WALK_RIGHT_LENGTH
  sta crab_boss_body_state_counter,x

  lda #CRAB_BOSS_BODY_STATE_WALK_RIGHT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  sec
  lda entity_x_lo,x
  sbc #<CRAB_BOSS_BODY_WALK_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>CRAB_BOSS_BODY_WALK_SPEED
  sta entity_x_hi,x

  jsr crab_boss_position_pincers

  jsr entity_update_animation

  rts

crab_boss_body_state_walk_right:

  jsr crab_boss_combat

  .scope
  dec crab_boss_body_state_rush_counter,x
  bne do_not_transition_yet

  lda #CRAB_BOSS_BODY_STATE_WALK_RIGHT
  sta crab_boss_body_previous_state,x

  lda #CRAB_BOSS_BODY_STATE_INIT_RUSH_LENGTH
  sta crab_boss_body_state_rush_counter,x

  lda #CRAB_BOSS_BODY_STATE_INIT_RUSH
  sta entity_state,x

  rts
do_not_transition_yet:
  .endscope

  .scope
  dec crab_boss_body_state_counter,x
  bne do_not_transition_yet

  lda #%00000000
  sta entity_sprite_flags,x

  lda #CRAB_BOSS_BODY_WALK_LEFT_LENGTH
  sta crab_boss_body_state_counter,x

  lda #CRAB_BOSS_BODY_STATE_WALK_LEFT
  sta entity_state,x

do_not_transition_yet:
  .endscope

  clc
  lda entity_x_lo,x
  adc #<CRAB_BOSS_BODY_WALK_SPEED
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>CRAB_BOSS_BODY_WALK_SPEED
  sta entity_x_hi,x

  jsr crab_boss_position_pincers

  jsr entity_update_animation

  rts

crab_boss_body_state_init_rush:

  jsr crab_boss_combat

  .scope
  dec crab_boss_body_state_rush_counter,x
  bne do_not_transition_yet

  lda #CRAB_BOSS_BODY_STATE_RUSH_LENGTH
  sta crab_boss_body_state_rush_counter,x

  lda #CRAB_BOSS_BODY_STATE_RUSH
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

crab_boss_body_state_rush:

  jsr crab_boss_combat

  clc
  lda entity_y_lo,x
  adc #<CRAB_BOSS_BODY_RUSH_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>CRAB_BOSS_BODY_RUSH_SPEED
  sta entity_y_hi,x

  .scope
  dec crab_boss_body_state_rush_counter,x
  bne do_not_transition_yet

  lda #CRAB_BOSS_BODY_STATE_RUSH_BACK_LENGTH
  sta crab_boss_body_state_rush_counter,x

  lda #CRAB_BOSS_BODY_STATE_RUSH_BACK
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

crab_boss_body_state_rush_back:

  jsr crab_boss_combat

  clc
  lda entity_y_lo,x
  adc #<(-CRAB_BOSS_BODY_RUSH_SPEED)
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>(-CRAB_BOSS_BODY_RUSH_SPEED)
  sta entity_y_hi,x

  .scope
  dec crab_boss_body_state_rush_counter,x
  bne do_not_transition_yet

  lda #CRAB_BOSS_BODY_TIME_TIL_RUSH
  sta crab_boss_body_state_rush_counter,x

  lda crab_boss_body_previous_state,x
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

.proc crab_boss_combat

  entity_advance_flash_state crab_boss_body_flash_counter

  .scope
  lda crab_boss_body_flash_counter,x
  cmp #(CRAB_BOSS_BODY_FLASH_LENGTH-1)
  bne do_not_tell_pincers_to_flash

  ldy crab_boss_body_pincer0,x
  lda #CRAB_BOSS_PINCER_FLASH_LENGTH
  sta crab_boss_pincer_flash_counter,y

  ldy crab_boss_body_pincer1,x
  lda #CRAB_BOSS_PINCER_FLASH_LENGTH
  sta crab_boss_pincer_flash_counter,y

do_not_tell_pincers_to_flash:
  .endscope

  jsr crab_boss_position_pincers

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  rts

.endproc

.proc crab_boss_position_pincers

  ldy crab_boss_body_pincer0,x
  clc
  lda entity_x_lo,x
  adc #<CRAB_BOSS_BODY_PINCER0_OFFSET_X
  sta entity_x_lo,y
  lda entity_x_hi,x
  adc #>CRAB_BOSS_BODY_PINCER0_OFFSET_X
  sta entity_x_hi,y

  clc
  lda entity_y_lo,x
  adc #<CRAB_BOSS_BODY_PINCER0_OFFSET_Y
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>CRAB_BOSS_BODY_PINCER0_OFFSET_Y
  sta entity_y_hi,y

  lda #%01000000
  sta entity_sprite_flags,y

  ldy crab_boss_body_pincer1,x
  clc
  lda entity_x_lo,x
  adc #<CRAB_BOSS_BODY_PINCER1_OFFSET_X
  sta entity_x_lo,y
  lda entity_x_hi,x
  adc #>CRAB_BOSS_BODY_PINCER1_OFFSET_X
  sta entity_x_hi,y

  clc
  lda entity_y_lo,x
  adc #<CRAB_BOSS_BODY_PINCER1_OFFSET_Y
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>CRAB_BOSS_BODY_PINCER1_OFFSET_Y
  sta entity_y_hi,y

  lda #%00000000
  sta entity_sprite_flags,y

  rts

.endproc

.endif
