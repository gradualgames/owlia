.linecont +
.ifndef SWITCH_PUZZLE_INC
SWITCH_PUZZLE_INC = 1

.include "switch_constants.inc"
.include "switch_puzzle_constants.inc"

define_lohi_tables switch_puzzle, \
 {switch_puzzle_state_init, \
  switch_puzzle_state_main, \
  switch_puzzle_state_victory}

switch_puzzle_update:

  entity_state_switchboard switch_puzzle_lo, switch_puzzle_hi

switch_puzzle_state_init:

  .scope
  lda inventory_dungeon_flags
  and switch_puzzle_entity_dungeon_flags_mask,x
  beq do_not_skip

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
do_not_skip:
  .endscope

  jsr entity_set_not_pausable

  jsr entity_clear_drawable

  lda #SWITCH_PUZZLE_STATE_MAIN
  sta entity_state,x

  rts

switch_puzzle_state_main:

  lda #0
  sta b0

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_switch
  bne skip_entity

  lda entity_state,y
  cmp #SWITCH_STATE_IDLE
  beq skip_entity

  inc b0

skip_entity:

  dey
  bpl next_entity
  .endscope

  .scope
  ;if b0 is 0 here, all switches are down and the puzzle is complete
  lda b0
  bne puzzle_not_solved

  lda #SWITCH_PUZZLE_VICTORY_PAUSE
  sta switch_puzzle_state_counter,x

  lda #SWITCH_PUZZLE_STATE_VICTORY
  sta entity_state,x

puzzle_not_solved:
  .endscope

  rts

switch_puzzle_state_victory:

  .scope
  dec switch_puzzle_state_counter,x
  bne do_not_transition_yet

  jsr switch_puzzle_spawn_treasure_chest_and_die

do_not_transition_yet:
  .endscope

  rts

.proc switch_puzzle_spawn_treasure_chest_and_die

  .scope
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
  lda switch_puzzle_entity_dungeon_flags_mask,x
  sta treasure_chest_dungeon_flags_mask,y
  lda #TREASURE_CHEST_MODE_DUNGEON
  sta treasure_chest_mode,y
  lda switch_puzzle_treasure_chest_type,x
  sta treasure_chest_item_type,y
  lda switch_puzzle_treasure_chest_quantity_lo,x
  sta treasure_chest_item_quantity_lo,y
  lda switch_puzzle_treasure_chest_quantity_hi,x
  sta treasure_chest_item_quantity_hi,y

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

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
  .endscope

  rts

.endproc

.endif
