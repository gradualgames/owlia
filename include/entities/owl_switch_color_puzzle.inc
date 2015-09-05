.linecont +
.ifndef OWL_SWITCH_COLOR_PUZZLE_INC
OWL_SWITCH_COLOR_PUZZLE_INC = 1

.include "owl_switch_color_puzzle_constants.inc"
.include "owl_switch_constants.inc"

define_lohi_tables owl_switch_color_puzzle, \
 {owl_switch_color_puzzle_state_init, \
  owl_switch_color_puzzle_state_main, \
  owl_switch_color_puzzle_state_victory}

owl_switch_color_puzzle_update:

  entity_state_switchboard owl_switch_color_puzzle_lo, owl_switch_color_puzzle_hi

owl_switch_color_puzzle_state_init:

  .scope
  lda inventory_dungeon_flags
  and owl_switch_color_puzzle_dungeon_flags_mask,x
  beq do_not_skip_puzzle

  .scope
  ;search for all owl switches and kill them
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_owl_switch
  beq kill_entity
  jmp do_not_kill_entity
kill_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y
do_not_kill_entity:

  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

do_not_skip_puzzle:
  .endscope

  jsr entity_set_not_pausable

  lda #0
  sta owl_switch_color_puzzle_solution,x
  sta owl_switch_color_puzzle_state_counter,x

  lda #OWL_SWITCH_COLOR_PUZZLE_STATE_MAIN
  sta entity_state,x

  rts

owl_switch_color_puzzle_state_main:

  ;search for owl switch entities, and rotate the low two bits of their
  ;entity_sprite_flags variable into the puzzle_solution variable. When
  ;this variable matches OWL_SWITCH_COLOR_PUZZLE_SOLUTION, the puzzle is
  ;solved.

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  cmp #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  bne skip_entity

  lda entity_type,y
  cmp #entity_index_owl_switch
  bne skip_entity

  bit_shift_counter = b0
  owl_switch_color = b1
  owl_switch_color_puzzle_bit_mask = b2

  lda entity_sprite_flags,y
  and #%00000011
  sta owl_switch_color

  lda #%00000011
  sta owl_switch_color_puzzle_bit_mask

  lda owl_switch_id,y
  sta bit_shift_counter
  beq shifting_done
keep_shifting:

  asl owl_switch_color
  asl owl_switch_color

  asl owl_switch_color_puzzle_bit_mask
  asl owl_switch_color_puzzle_bit_mask

  dec bit_shift_counter
  bne keep_shifting
shifting_done:

  lda owl_switch_color_puzzle_bit_mask
  eor #%11111111
  sta owl_switch_color_puzzle_bit_mask

  lda owl_switch_color_puzzle_solution,x
  and owl_switch_color_puzzle_bit_mask
  ora owl_switch_color
  sta owl_switch_color_puzzle_solution,x

skip_entity:

  dey
  bpl next_entity
  .endscope

  .scope
  lda owl_switch_color_puzzle_solution,x
  cmp #OWL_SWITCH_COLOR_PUZZLE_SOLUTION
  bne not_solved_yet

  lda #OWL_SWITCH_COLOR_PUZZLE_STATE_VICTORY_LENGTH
  sta owl_switch_color_puzzle_state_counter,x

  lda #OWL_SWITCH_COLOR_PUZZLE_STATE_VICTORY
  sta entity_state,x

not_solved_yet:
  .endscope

  rts

owl_switch_color_puzzle_state_victory:

  .scope
  dec owl_switch_color_puzzle_state_counter,x
  bne do_not_be_solved_yet

  jsr owl_switch_color_puzzle_play_victory_sound

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
  lda owl_switch_color_puzzle_dungeon_flags_mask,x
  sta treasure_chest_dungeon_flags_mask,y
  lda #TREASURE_CHEST_MODE_DUNGEON
  sta treasure_chest_mode,y
  lda owl_switch_color_puzzle_treasure_chest_type,x
  sta treasure_chest_item_type,y
  lda owl_switch_color_puzzle_treasure_chest_quantity_lo,x
  sta treasure_chest_item_quantity_lo,y
  lda owl_switch_color_puzzle_treasure_chest_quantity_hi,x
  sta treasure_chest_item_quantity_hi,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
do_not_be_solved_yet:

  .endscope

  rts

.proc owl_switch_color_puzzle_play_victory_sound

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

  rts

.endproc

.endif
