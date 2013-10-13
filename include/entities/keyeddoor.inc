.linecont +
.ifndef KEYEDDOOR_INC
KEYEDDOOR_INC = 1

keyeddoor_location_index = entity_local0

.enum
KEYEDDOOR_STATE_INIT
KEYEDDOOR_STATE_MAIN
.endenum

.define keyeddoor_states \
  keyeddoor_state_init, \
  keyeddoor_state_main

keyeddoor_lo:
  .lobytes keyeddoor_states

keyeddoor_hi:
  .hibytes keyeddoor_states

keyeddoor_update:

  entity_state_switchboard keyeddoor_lo, keyeddoor_hi

keyeddoor_state_init:

  jsr entity_clear_drawable

  lda #$0f
  sta entity_width,x
  lda #$01
  sta entity_height,x

  lda #KEYEDDOOR_STATE_MAIN
  sta entity_state,x

  rts

keyeddoor_state_main:

  jsr entity_test_hero_rect
  bne not_touching_hero

  jsr hero_is_attacking
  bne do_not_unlock_door

  jsr hero_cancel_attack

  ;this location is locked, test to see if the hero has a key
  jsr inventory_can_use_key
  bne hero_can_use_key

  ;make the hero wait one frame to prevent a held-down A button
  ;from immediately re-activating this door and showing the
  ;locked door textbox again.
  lda #1
  sta b0
  jsr hero_wait_frames

  ;if the hero does not have a key, we start a conversation
  ;saying the door is locked
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_door_is_locked
  sta state_control_params+play_state_control::param

  jmp hero_cannot_use_key

hero_can_use_key:

  jsr inventory_use_key

  ;tell the play state to goto destination location
  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  lda keyeddoor_location_index,x
  sta state_control_params+play_state_control::param

  ;play a sound
  txa
  pha

  lda #<sfx_door
  sta sound_param_word_0
  lda #>sfx_door
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_unlock_door:

not_touching_hero:

hero_cannot_use_key:

  rts

.endif
