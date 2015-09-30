.linecont +
.ifndef SIMULTANEOUS_DEFEAT_PUZZLE_INC
SIMULTANEOUS_DEFEAT_PUZZLE_INC = 1

.include "simultaneous_defeat_puzzle_constants.inc"

.define simultaneous_defeat_puzzle_states \
  simultaneous_defeat_puzzle_state_init, \
  simultaneous_defeat_puzzle_state_wait_for_first_kill, \
  simultaneous_defeat_puzzle_state_wait_for_both_dead, \
  simultaneous_defeat_puzzle_state_victory, \
  simultaneous_defeat_puzzle_state_spawn_treasure_chest

simultaneous_defeat_puzzle_lo:
  .lobytes simultaneous_defeat_puzzle_states

simultaneous_defeat_puzzle_hi:
  .hibytes simultaneous_defeat_puzzle_states

simultaneous_defeat_puzzle_update:

  entity_state_switchboard simultaneous_defeat_puzzle_lo, simultaneous_defeat_puzzle_hi

simultaneous_defeat_puzzle_state_init:

  .scope
  lda inventory_dungeon_flags
  and simultaneous_defeat_puzzle_dungeon_flags_mask,x
  beq do_not_skip

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
do_not_skip:
  .endscope

  jsr entity_clear_drawable

  ;find two living entity instances that are not this entity. We're going to track
  ;the lifetimes of these entities from this puzzle and determine if they were
  ;both defeated within a short time window.
  .scope
  ldy #(MAX_ENTITIES-1)

  .scope
next_entity:
  ;skip dead entities
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity1
  ;skip entities marked for kill
  lda entity_flags,y
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity1
  ;skip the puzzle entity
  lda entity_type,y
  cmp #entity_index_simultaneous_defeat_puzzle
  beq skip_entity1
  ;skip monolith entities
  cmp #entity_index_monolith
  beq skip_entity1

  tya
  sta simultaneous_defeat_puzzle_entity_instance0,x
  jmp found_first_entity

skip_entity1:

  dey
  bpl next_entity
  .endscope
found_first_entity:

  ;make sure to advance to next entity
  dey

  .scope
next_entity:
  ;skip dead entities
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity2
  ;skip entities marked for kill
  lda entity_flags,y
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  bne skip_entity2
  ;skip the puzzle entity
  lda entity_type,y
  cmp #entity_index_simultaneous_defeat_puzzle
  beq skip_entity2
  ;skip monolith entities
  cmp #entity_index_monolith
  beq skip_entity2

  tya
  sta simultaneous_defeat_puzzle_entity_instance1,x
  jmp found_second_entity

skip_entity2:

  dey
  bpl next_entity
  .endscope
found_second_entity:

  .endscope

  lda #0
  sta simultaneous_defeat_puzzle_entity_timer,x

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_STATE_WAIT_FOR_FIRST_KILL
  sta entity_state,x

  rts

simultaneous_defeat_puzzle_state_wait_for_first_kill:

  ;detect if either entity is dead and start the timer if not already started
  .scope
  ldy simultaneous_defeat_puzzle_entity_instance0,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_still_alive

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_TIMER_LENGTH
  sta simultaneous_defeat_puzzle_entity_timer,x

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_STATE_WAIT_FOR_BOTH_DEAD
  sta entity_state,x
  rts

entity_still_alive:
  .endscope

  .scope
  ldy simultaneous_defeat_puzzle_entity_instance1,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_still_alive

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_TIMER_LENGTH
  sta simultaneous_defeat_puzzle_entity_timer,x

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_STATE_WAIT_FOR_BOTH_DEAD
  sta entity_state,x
  rts

entity_still_alive:
  .endscope


  rts

simultaneous_defeat_puzzle_state_wait_for_both_dead:

  dec simultaneous_defeat_puzzle_entity_timer,x
  beq simultaneous_defeat_puzzle_failed

  ;if timer hasn't run out, check to see if both enemies have been defeated. if so,
  ;the puzzle is solved
  .scope
  ldy simultaneous_defeat_puzzle_entity_instance0,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_still_alive

  ldy simultaneous_defeat_puzzle_entity_instance1,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_still_alive

  lda #PUZZLE_VICTORY_MELODY_DELAY
  sta simultaneous_defeat_puzzle_state_counter,x

  ;if we reach here, both entities have been defeated within the alotted time frame.
  ;transition to victory state.
  lda #SIMULTANEOUS_DEFEAT_PUZZLE_STATE_VICTORY
  sta entity_state,x

entity_still_alive:
  .endscope

  rts

simultaneous_defeat_puzzle_failed:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

simultaneous_defeat_puzzle_state_victory:

  .scope
  dec simultaneous_defeat_puzzle_state_counter,x
  bne do_not_transition_yet

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

  lda #PUZZLE_TREASURE_CHEST_DELAY
  sta simultaneous_defeat_puzzle_state_counter,x

  lda #SIMULTANEOUS_DEFEAT_PUZZLE_STATE_SPAWN_TREASURE_CHEST
  sta entity_state,x
do_not_transition_yet:
  .endscope

  rts

simultaneous_defeat_puzzle_state_spawn_treasure_chest:

  .scope
  dec simultaneous_defeat_puzzle_state_counter,x
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

  .scope
  ;spawn a treasure chest with a key inside
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
  lda simultaneous_defeat_puzzle_dungeon_flags_mask,x
  sta treasure_chest_dungeon_flags_mask,y
  lda #TREASURE_CHEST_MODE_DUNGEON
  sta treasure_chest_mode,y
  lda #TREASURE_CHEST_ITEM_TYPE_KEY
  sta treasure_chest_item_type,y
  lda #<1
  sta treasure_chest_item_quantity_lo,y
  lda #>1
  sta treasure_chest_item_quantity_hi,y
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  rts

.endif
