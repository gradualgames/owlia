.linecont +
.ifndef KEYEDDOOR_INC
KEYEDDOOR_INC = 1

keyeddoor_floating_solid_metatile_y_offset = entity_local0

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

  jsr entity_set_drawable_unsorted

  lda #<KeyedDoor
  sta entity_animation_address_lo,x
  lda #>KeyedDoor
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #$0f
  sta entity_width,x
  lda #$1f
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;ldy #sprite_chr_group_index_keyeddoor
  ;lda sprite_chr_group_offsets,y
  ;sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #KEYEDDOOR_STATE_MAIN
  sta entity_state,x

  rts

keyeddoor_state_main:

  jsr entity_test_hero_rect
  bne not_touching_hero

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc keyeddoor_floating_solid_metatile_y_offset,x
  sta w1
  lda entity_y_hi,x
  adc #$00
  sta w1+1

  jsr entity_grab_floating_solid_metatile

  lda buffer_controller+buttons::_a

  and #%00000011
  cmp #%00000001
  bne do_not_unlock_door

  jsr hero_cancel_attack

  ;this location is locked, test to see if the hero has a key
  jsr inventory_can_use_key
  bne hero_can_use_key

  ;if the hero does not have a key, we start a conversation
  ;saying the door is locked
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_door_is_locked
  sta state_control_params+play_state_control::param

  jmp hero_cannot_use_key

hero_can_use_key:

  jsr inventory_use_key

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

  jsr entity_update_animation

  rts

.endif
