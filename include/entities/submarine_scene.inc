.linecont +
.ifndef SUBMARINE_SCENE_INC
SUBMARINE_SCENE_INC = 1

SUBMARINE_SCENE_STATE_CRASH_LENGTH = 20
SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS = 2000

define_entity_properties submarine_scene_state_counter_lo,\
                         submarine_scene_state_counter_hi

.enum
SUBMARINE_SCENE_STATE_INIT
SUBMARINE_SCENE_STATE_PAUSE_UNTIL_CRASH
SUBMARINE_SCENE_STATE_CRASH
SUBMARINE_SCENE_STATE_IDLE
.endenum

define_lohi_tables submarine_scene, \
 {submarine_scene_state_init, \
  submarine_scene_state_pause_until_crash, \
  submarine_scene_state_crash, \
  submarine_scene_state_idle}

submarine_scene_update:

  entity_state_switchboard submarine_scene_lo, submarine_scene_hi

submarine_scene_state_init:

  jsr entity_set_drawable

  lda #sprite_chr_group_index_npc_commodore
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #<npc_commodore_walk_side
  sta entity_animation_address_lo,x
  lda #>npc_commodore_walk_side
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #0
  sta entity_sprite_flags,x

  lda #<SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS
  sta submarine_scene_state_counter_lo,x
  lda #>SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS
  sta submarine_scene_state_counter_hi,x

  lda #SUBMARINE_SCENE_STATE_PAUSE_UNTIL_CRASH
  sta entity_state,x

  rts

submarine_scene_state_pause_until_crash:

  jsr entity_set_sorted

  .scope
  sec
  lda submarine_scene_state_counter_lo,x
  sbc #<1
  sta submarine_scene_state_counter_lo,x
  lda submarine_scene_state_counter_hi,x
  sbc #>1
  sta submarine_scene_state_counter_hi,x

  lda submarine_scene_state_counter_lo,x
  ora submarine_scene_state_counter_hi,x
  bne do_not_transition_yet

  far_call #SOUND_BANK, sound_stop

  ;play a sound
  lda #<sfx_boom
  sta sound_param_word_0
  lda #>sfx_boom
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  lda #SUBMARINE_SCENE_STATE_CRASH_LENGTH
  sta submarine_scene_state_counter_lo,x

  lda #SUBMARINE_SCENE_STATE_CRASH
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

submarine_scene_state_crash:

  jsr entity_set_sorted

  lda camera_y
  eor #$04
  sta camera_y
  lda camera_scroll_y
  eor #$04
  sta camera_scroll_y

  .scope
  dec submarine_scene_state_counter_lo,x
  bne do_not_transition_yet

  .scope
  ;search for monolith entity and make it fall
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda #MONOLITH_STATE_FALL_INIT
  sta entity_state,y
  jmp done

not_monolith:

  dey
  bpl next_entity
done:
  .endscope

  ;put hero into a passive state so she cannot
  ;get input from the controller immediately upon
  ;finishing the conversation.
  lda #3
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  lda entity_sprite_flags,x
  ora #%01000000
  sta entity_sprite_flags,x

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_what_was_that
  sta state_control_params+play_state_control::param

  lda #SUBMARINE_SCENE_STATE_IDLE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

submarine_scene_state_idle:

  jsr entity_set_sorted

  rts

.endif
