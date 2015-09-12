.linecont +
.ifndef SHOOTING_GALLERY_INC
SHOOTING_GALLERY_INC = 1

.include "npc_constants.inc"
.include "shooting_gallery_constants.inc"
.include "number_constants.inc"

define_lohi_tables shooting_gallery, \
 {shooting_gallery_state_init, \
  shooting_gallery_state_wait_for_textbox_confirm, \
  shooting_gallery_state_main}

shooting_gallery_update:

  entity_state_switchboard shooting_gallery_lo, shooting_gallery_hi

shooting_gallery_state_init:

  jsr entity_set_not_pausable

  lda #30
  sta shooting_gallery_state_counter,x

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_npc
  beq found_npc
  dey
  bpl next_entity
found_npc:
  tya
  sta shooting_gallery_npc_index,x
  .endscope

  lda #0
  sta shooting_gallery_earned_points,x

  lda #entity_index_number
  sta b0

  lda #<SHOOTING_GALLERY_POINTS_DISPLAY_X
  sta w0
  lda #>SHOOTING_GALLERY_POINTS_DISPLAY_X
  sta w0+1
  lda #<SHOOTING_GALLERY_POINTS_DISPLAY_Y
  sta w1
  lda #>SHOOTING_GALLERY_POINTS_DISPLAY_Y
  sta w1+1

  jsr entity_spawn

  lda spawned_entity
  sta shooting_gallery_number_display_index,x
  tay
  lda shooting_gallery_earned_points,x
  sta number_value_lo,y
  lda #0
  sta number_value_hi,y
  lda #0
  sta number_value_hi_hi,y

  ;make sure this is in the right state before we monitor it for confirm
  lda #TEXTBOX_NO_RESULT
  sta textbox_result

  lda #SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
  sta entity_state,x

  rts

shooting_gallery_state_wait_for_textbox_confirm:

  .scope
  lda textbox_result
  cmp #TEXTBOX_CONFIRM
  bne do_not_transition_to_main_state

  ;check to see if player has enough gp to play the game
  sec
  lda inventory_gp
  sbc #<SHOOTING_GALLERY_PRICE
  lda inventory_gp+1
  sbc #>SHOOTING_GALLERY_PRICE
  lda inventory_gp+2
  sbc #^SHOOTING_GALLERY_PRICE
  bpl continue_with_game
cancel_game:

  lda #TEXTBOX_NO_RESULT
  sta textbox_result

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_target_game_not_enough_gp
  sta state_control_params+play_state_control::param

  rts

continue_with_game:

  jsr shooting_gallery_make_exit_impassable

  jsr shooting_gallery_play_coins_sound

  ;we know there's enough gp, subtract the price from gp
  sec
  lda inventory_gp
  sbc #<SHOOTING_GALLERY_PRICE
  sta inventory_gp
  lda inventory_gp+1
  sbc #>SHOOTING_GALLERY_PRICE
  sta inventory_gp+1
  lda inventory_gp+2
  sbc #^SHOOTING_GALLERY_PRICE
  sta inventory_gp+2

  lda #<SHOOTING_GALLERY_GAME_TIME
  sta shooting_gallery_timer_lo,x
  lda #>SHOOTING_GALLERY_GAME_TIME
  sta shooting_gallery_timer_hi,x

  ;change NPC conversation so that he doesn't start the game
  ;again until the game is done.
  ldy shooting_gallery_npc_index,x
  lda #conversation_index_target_game_during
  sta npc_conversation,y

  ;reset points to 0
  lda #0
  sta shooting_gallery_earned_points,x

  lda #SHOOTING_GALLERY_STATE_MAIN
  sta entity_state,x

do_not_transition_to_main_state:
  .endscope

  rts

shooting_gallery_state_main:

  jsr reinitialize_points_display

  .scope
  sec
  lda shooting_gallery_timer_lo,x
  sbc #<1
  sta shooting_gallery_timer_lo,x
  lda shooting_gallery_timer_hi,x
  sbc #>1
  sta shooting_gallery_timer_hi,x

  lda shooting_gallery_timer_lo,x
  ora shooting_gallery_timer_hi,x
  bne game_not_over_yet

  jsr shooting_gallery_kill_all_targets

  ;change NPC conversation back to intro for game
  ldy shooting_gallery_npc_index,x
  lda #conversation_index_target_game_intro
  sta npc_conversation,y

  .scope
  lda shooting_gallery_earned_points,x
  cmp #SHOOTING_GALLERY_WINNING_POINTS
  bmi lose
win:

  jsr shooting_gallery_make_exit_passable

  ;spawn gold reward
  lda hero_x
  sta w0
  lda hero_x+1
  sta w0+1
  lda hero_y
  sta w1
  lda hero_y+1
  sta w1+1

  lda #entity_index_item
  sta b0

  jsr entity_spawn

  ldy spawned_entity
  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_GP
  sta item_type,y
  lda #<SHOOTING_GALLERY_REWARD
  sta item_quantity_lo,y
  lda #>SHOOTING_GALLERY_REWARD
  sta item_quantity_hi,y
  lda #INVENTORY_DUNGEON_FLAGS_MASK_NOP
  sta item_dungeon_flags_mask,y

  ;run congratulations conversation
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_target_game_win
  sta state_control_params+play_state_control::param

  jmp done
lose:

  jsr shooting_gallery_make_exit_passable

  ;run lose conversation
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_target_game_lose
  sta state_control_params+play_state_control::param
done:
  .endscope

  lda #0
  sta shooting_gallery_earned_points,x
  jsr reinitialize_points_display

  lda #SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
  sta entity_state,x

  rts

game_not_over_yet:
  .endscope

  .scope
  dec shooting_gallery_state_counter,x
  bne do_not_spawn_target

  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_target
  bne skip_entity
  inc b0
skip_entity:

  dey
  bpl next_entity
  .endscope

  sec
  lda #SHOOTING_GALLERY_MAX_TARGETS
  sbc b0
  bmi do_not_spawn_target

  ;choose left or right side of screen
  .scope
  lda rand
  and #%00000001
  bne odd
even:

  jsr spawn_target_left

  jmp done
odd:

  jsr spawn_target_right

done:
  .endscope

  jsr next_rand
  lda rand
  and #%00011111
  ora #1
  sta shooting_gallery_state_counter,x

do_not_spawn_target:
  .endscope

  rts

.proc reinitialize_points_display

  ldy shooting_gallery_number_display_index,x
  lda shooting_gallery_earned_points,x
  sta number_value_lo,y
  lda #0
  sta number_value_hi,y
  lda #0
  sta number_value_hi_hi,y
  lda #NUMBER_STATE_INIT
  sta entity_state,y
  rts

.endproc

.proc spawn_target_left

  lda #entity_index_target
  sta b0

  lda #<(-16)
  sta w0
  lda #>(-16)
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_RIGHT
  sta target_direction,y

  txa
  sta target_shooting_gallery_index,y

  jsr parameterize_new_target

  rts

.endproc

.proc spawn_target_right

  lda #entity_index_target
  sta b0

  lda #<256
  sta w0
  lda #>256
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_LEFT
  sta target_direction,y

  txa
  sta target_shooting_gallery_index,y

  jsr parameterize_new_target

  rts

.endproc

.proc parameterize_new_target

  ldy spawned_entity

  jsr next_rand
  lda rand
  and #%00000001
  sta target_mode,y

  jsr next_rand
  lda rand
  and #%00000011
  sta target_type,y

  jsr next_rand
  lda rand
  and #%00000011
  ora #1
  sta target_speed,y

  jsr next_rand
  lda rand
  and #%00000111
  sta target_random_speed_mask,y

  lda #1
  sta target_health,y

  .scope
  lda target_mode,y
  cmp #TARGET_MODE_NORMAL
  beq normal
  cmp #TARGET_MODE_RANDOM_SPEED
  beq random_speed
normal:

  .scope
  lda target_speed,y
  cmp #1
  beq one
  cmp #2
  beq two
  cmp #3
  beq three
one:

  lda #<1
  sta target_points,y

  jmp done
two:

  lda #<2
  sta target_points,y

  jmp done
three:

  lda #<3
  sta target_points,y

done:
  .endscope

  jmp done
random_speed:

  .scope
  lda target_random_speed_mask,y
  and #%00000001
  bne one
  lda target_random_speed_mask,y
  and #%00000010
  bne two
  lda target_random_speed_mask,y
  and #%00000100
  bne three
one:

  lda #<1
  sta target_points,y

  jmp done
two:

  lda #<2
  sta target_points,y

  jmp done
three:

  lda #<3
  sta target_points,y

done:
  .endscope

done:
  .endscope

  rts

.endproc

.proc shooting_gallery_play_coins_sound

  ;play a sound
  lda #<sfx_coins_square1
  sta sound_param_word_0
  lda #>sfx_coins_square1
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  ;play a sound
  lda #<sfx_coins_square2
  sta sound_param_word_0
  lda #>sfx_coins_square2
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0

  lda #soundeffect_two
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  rts

.endproc

.proc shooting_gallery_make_exit_impassable

  lda #<SHOOTING_GALLERY_EXIT_BLOCK1_X
  sta w0
  lda #>SHOOTING_GALLERY_EXIT_BLOCK1_X
  sta w0+1

  lda #<SHOOTING_GALLERY_EXIT_BLOCK1_Y
  sta w1
  lda #>SHOOTING_GALLERY_EXIT_BLOCK1_Y
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda #<SHOOTING_GALLERY_EXIT_BLOCK2_X
  sta w0
  lda #>SHOOTING_GALLERY_EXIT_BLOCK2_X
  sta w0+1

  lda #<SHOOTING_GALLERY_EXIT_BLOCK2_Y
  sta w1
  lda #>SHOOTING_GALLERY_EXIT_BLOCK2_Y
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  rts

.endproc

.proc shooting_gallery_make_exit_passable

  lda #<SHOOTING_GALLERY_EXIT_BLOCK1_X
  sta w0
  lda #>SHOOTING_GALLERY_EXIT_BLOCK1_X
  sta w0+1

  lda #<SHOOTING_GALLERY_EXIT_BLOCK1_Y
  sta w1
  lda #>SHOOTING_GALLERY_EXIT_BLOCK1_Y
  sta w1+1

  jsr clear_dynamic_single_screen_collision_field_bit

  lda #<SHOOTING_GALLERY_EXIT_BLOCK2_X
  sta w0
  lda #>SHOOTING_GALLERY_EXIT_BLOCK2_X
  sta w0+1

  lda #<SHOOTING_GALLERY_EXIT_BLOCK2_Y
  sta w1
  lda #>SHOOTING_GALLERY_EXIT_BLOCK2_Y
  sta w1+1

  jsr clear_dynamic_single_screen_collision_field_bit

  rts

.endproc

.proc shooting_gallery_kill_all_targets

  ;kill off all targets
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_target
  bne skip_entity

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

skip_entity:
  dey
  bpl next_entity
  .endscope

  rts

.endproc

.endif
