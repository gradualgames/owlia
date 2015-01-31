.linecont +
.ifndef MONOLITH_PUZZLE_INC
MONOLITH_PUZZLE_INC = 1

.include "monolith_puzzle_constants.inc"

.define monolith_puzzle_states \
  monolith_puzzle_state_init, \
  monolith_puzzle_state_main, \
  monolith_puzzle_state_error_init, \
  monolith_puzzle_state_error, \
  monolith_puzzle_state_reset, \
  monolith_puzzle_state_solved, \
  monolith_puzzle_state_spawn_treasure_chest, \
  monolith_puzzle_state_lower_all_monoliths_and_die

monolith_puzzle_lo:
  .lobytes monolith_puzzle_states

monolith_puzzle_hi:
  .hibytes monolith_puzzle_states

monolith_puzzle_update:

  entity_state_switchboard monolith_puzzle_lo, monolith_puzzle_hi

monolith_puzzle_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  ;find all four monoliths that participate in this puzzle
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity

  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda monolith_goto_location_action,y
  cmp #ACTION_NOP
  bne skip_entity

  ;at this point we found one of the four monoliths we want
  tya
  sta monolith_puzzle_monolith0,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  ;find all four monoliths that participate in this puzzle
  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity

  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda monolith_goto_location_action,y
  cmp #ACTION_NOP
  bne skip_entity

  ;at this point we found one of the four monoliths we want
  tya
  sta monolith_puzzle_monolith1,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  ;find all four monoliths that participate in this puzzle
  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity

  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda monolith_goto_location_action,y
  cmp #ACTION_NOP
  bne skip_entity

  ;at this point we found one of the four monoliths we want
  tya
  sta monolith_puzzle_monolith2,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  ;find all four monoliths that participate in this puzzle
  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity

  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda monolith_goto_location_action,y
  cmp #ACTION_NOP
  bne skip_entity

  ;at this point we found one of the four monoliths we want
  tya
  sta monolith_puzzle_monolith3,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  ;now check to see if this puzzle is already solved. If so,
  ;tell all the monoliths in this puzzle to fall and kill off the
  ;puzzle entity.
  .scope
  lda inventory_dungeon_flags
  and monolith_puzzle_dungeon_flags_mask,x
  beq do_not_skip

  lda #MONOLITH_PUZZLE_STATE_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_LOWER_ALL_MONOLITHS_AND_DIE
  sta entity_state,x

  rts

do_not_skip:
  .endscope

  lda #0
  sta monolith_puzzle_solution_buffer,x
  sta monolith_puzzle_solution_flags,x

  lda #MONOLITH_PUZZLE_STATE_MAIN
  sta entity_state,x

  rts

monolith_puzzle_state_main:

  ;check to see if any of the monoliths have gone down
  .scope
  lda monolith_puzzle_solution_flags,x
  and #%00000001
  bne skip

  ldy monolith_puzzle_monolith0,x
  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  bne not_down

  lda #(0 << 6)
  rol
  rol monolith_puzzle_solution_buffer,x
  rol
  rol monolith_puzzle_solution_buffer,x

  lda monolith_puzzle_solution_flags,x
  ora #%00000001
  sta monolith_puzzle_solution_flags,x
not_down:
skip:
  .endscope

  .scope
  lda monolith_puzzle_solution_flags,x
  and #%00000010
  bne skip

  ldy monolith_puzzle_monolith1,x
  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  bne not_down

  lda #(1 << 6)
  rol
  rol monolith_puzzle_solution_buffer,x
  rol
  rol monolith_puzzle_solution_buffer,x

  lda monolith_puzzle_solution_flags,x
  ora #%00000010
  sta monolith_puzzle_solution_flags,x

not_down:
skip:
  .endscope

  .scope
  lda monolith_puzzle_solution_flags,x
  and #%00000100
  bne skip

  ldy monolith_puzzle_monolith2,x
  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  bne not_down

  lda #(2 << 6)
  rol
  rol monolith_puzzle_solution_buffer,x
  rol
  rol monolith_puzzle_solution_buffer,x

  lda monolith_puzzle_solution_flags,x
  ora #%00000100
  sta monolith_puzzle_solution_flags,x

not_down:
skip:
  .endscope

  .scope
  lda monolith_puzzle_solution_flags,x
  and #%00001000
  bne skip

  ldy monolith_puzzle_monolith3,x
  lda monolith_flags,y
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  bne not_down

  lda #(3 << 6)
  rol
  rol monolith_puzzle_solution_buffer,x
  rol
  rol monolith_puzzle_solution_buffer,x

  lda monolith_puzzle_solution_flags,x
  ora #%00001000
  sta monolith_puzzle_solution_flags,x

not_down:
skip:
  .endscope

  .scope
  lda monolith_puzzle_solution_flags,x
  cmp #%00001111
  bne monoliths_not_all_down

  lda monolith_puzzle_solution_buffer,x
  cmp #MONOLITH_PUZZLE_SOLUTION
  bne error
solved:

  lda #MONOLITH_PUZZLE_STATE_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_SOLVED
  sta entity_state,x

  jmp done
error:

  lda #MONOLITH_PUZZLE_STATE_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_ERROR_INIT
  sta entity_state,x

done:

monoliths_not_all_down:
  .endscope

  rts

monolith_puzzle_state_error_init:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  ;play error sound and raise all monoliths
  ;play a sound
  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  lda #MONOLITH_PUZZLE_STATE_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_ERROR
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

monolith_puzzle_state_error:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  ;re-raise all monoliths in the puzzle
  ldy monolith_puzzle_monolith0,x
  lda #MONOLITH_STATE_RISE_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  ora #MONOLITH_FLAGS_UP_SET
  sta monolith_flags,y

  ldy monolith_puzzle_monolith1,x
  lda #MONOLITH_STATE_RISE_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  ora #MONOLITH_FLAGS_UP_SET
  sta monolith_flags,y

  ldy monolith_puzzle_monolith2,x
  lda #MONOLITH_STATE_RISE_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  ora #MONOLITH_FLAGS_UP_SET
  sta monolith_flags,y

  ldy monolith_puzzle_monolith3,x
  lda #MONOLITH_STATE_RISE_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  ora #MONOLITH_FLAGS_UP_SET
  sta monolith_flags,y

  lda #0
  sta monolith_puzzle_solution_flags,x
  sta monolith_puzzle_solution_buffer,x

  lda #MONOLITH_PUZZLE_STATE_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_RESET
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

monolith_puzzle_state_reset:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  lda #MONOLITH_PUZZLE_STATE_MAIN
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

monolith_puzzle_state_solved:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  ;play victory sound and create treasure chest with key
  ;play a sound
  lda #<sfx_solved_puzzle_instrument_one
  sta sound_param_word_0
  lda #>sfx_solved_puzzle_instrument_one
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  ;play a sound
  lda #<sfx_solved_puzzle_instrument_two
  sta sound_param_word_0
  lda #>sfx_solved_puzzle_instrument_two
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0
  lda #soundeffect_two
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  lda #0
  sta monolith_puzzle_solution_flags,x
  sta monolith_puzzle_solution_buffer,x

  lda #MONOLITH_PUZZLE_TREASURE_CHEST_PAUSE
  sta monolith_puzzle_state_counter,x

  lda #MONOLITH_PUZZLE_STATE_SPAWN_TREASURE_CHEST
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

monolith_puzzle_state_spawn_treasure_chest:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  ;play a sound
  lda #<sfx_chest_melody
  sta sound_param_word_0
  lda #>sfx_chest_melody
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1
  far_call #SOUND_BANK, stream_initialize

  ;spawn a treasure chest with the forwarded parameters
  lda #entity_index_treasure_chest
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  ;parameterize the treasure chest
  ldy spawned_entity
  lda monolith_puzzle_dungeon_flags_mask,x
  sta treasure_chest_dungeon_flags_mask,y
  lda #TREASURE_CHEST_MODE_DUNGEON
  sta treasure_chest_mode,y
  lda monolith_puzzle_treasure_chest_type,x
  sta treasure_chest_item_type,y
  lda monolith_puzzle_treasure_chest_quantity_lo,x
  sta treasure_chest_item_quantity_lo,y
  lda monolith_puzzle_treasure_chest_quantity_hi,x
  sta treasure_chest_item_quantity_hi,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
do_not_transition_yet:
  .endscope

  rts

monolith_puzzle_state_lower_all_monoliths_and_die:

  .scope
  dec monolith_puzzle_state_counter,x
  bne do_not_transition_yet

  ldy monolith_puzzle_monolith0,x
  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  and #MONOLITH_FLAGS_DOWN_CLEAR
  sta monolith_flags,y

  ldy monolith_puzzle_monolith1,x
  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  and #MONOLITH_FLAGS_DOWN_CLEAR
  sta monolith_flags,y

  ldy monolith_puzzle_monolith2,x
  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  and #MONOLITH_FLAGS_DOWN_CLEAR
  sta monolith_flags,y

  ldy monolith_puzzle_monolith3,x
  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y
  lda monolith_flags,y
  and #MONOLITH_FLAGS_DOWN_CLEAR
  sta monolith_flags,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
do_not_transition_yet:
  .endscope

  rts

.endif
