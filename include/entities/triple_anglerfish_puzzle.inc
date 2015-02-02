.linecont +
.ifndef TRIPLE_ANGLERFISH_PUZZLE_INC
TRIPLE_ANGLERFISH_PUZZLE_INC = 1

.include "triple_anglerfish_puzzle_constants.inc"

.define triple_anglerfish_puzzle_states \
  triple_anglerfish_puzzle_state_init, \
  triple_anglerfish_puzzle_state_main, \
  triple_anglerfish_puzzle_state_kill_anglerfish, \
  triple_anglerfish_puzzle_state_spawn_treasure_chest

triple_anglerfish_puzzle_lo:
  .lobytes triple_anglerfish_puzzle_states

triple_anglerfish_puzzle_hi:
  .hibytes triple_anglerfish_puzzle_states

triple_anglerfish_puzzle_update:

  entity_state_switchboard triple_anglerfish_puzzle_lo, triple_anglerfish_puzzle_hi

triple_anglerfish_puzzle_state_init:

  .scope
  lda inventory_dungeon_flags
  and triple_anglerfish_puzzle_dungeon_flags_mask,x
  beq do_not_skip

  .scope
  ;search for all anglerfish and spotlight entities and kill them
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_anglerfish
  beq kill_entity
  cmp #entity_index_spotlight
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

do_not_skip:
  .endscope

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  ;search for all three spotlight entities that participate in this puzzle
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_spotlight
  bne skip_entity

  ;at this point we found one of the three spotlights we want
  tya
  sta triple_anglerfish_puzzle_spotlight0,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_spotlight
  bne skip_entity

  ;at this point we found one of the three spotlights we want
  tya
  sta triple_anglerfish_puzzle_spotlight1,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_spotlight
  bne skip_entity

  ;at this point we found one of the three spotlights we want
  tya
  sta triple_anglerfish_puzzle_spotlight2,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  ;search for all three anglerfish entities that participate in this puzzle
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_anglerfish
  bne skip_entity

  ;at this point we found one of the three anglerfish we want
  tya
  sta triple_anglerfish_puzzle_anglerfish0,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_anglerfish
  bne skip_entity

  ;at this point we found one of the three anglerfish we want
  tya
  sta triple_anglerfish_puzzle_anglerfish1,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  .scope
  dey
  bmi done
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  lda entity_type,y
  cmp #entity_index_anglerfish
  bne skip_entity

  ;at this point we found one of the three anglerfish we want
  tya
  sta triple_anglerfish_puzzle_anglerfish2,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  lda #0
  sta triple_anglerfish_puzzle_spot0_x_hi,x
  sta triple_anglerfish_puzzle_spot0_y_hi,x
  sta triple_anglerfish_puzzle_spot1_x_hi,x
  sta triple_anglerfish_puzzle_spot1_y_hi,x
  sta triple_anglerfish_puzzle_spot2_x_hi,x
  sta triple_anglerfish_puzzle_spot2_y_hi,x

  ;now convert all the spot meta tile coordinates to 16 bit map coordinates
  .scope
  lda triple_anglerfish_puzzle_spot0_x_hi,x
  asl triple_anglerfish_puzzle_spot0_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_x_lo,x
  rol
  sta triple_anglerfish_puzzle_spot0_x_hi,x

  lda triple_anglerfish_puzzle_spot0_y_hi,x
  asl triple_anglerfish_puzzle_spot0_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot0_y_lo,x
  rol
  sta triple_anglerfish_puzzle_spot0_y_hi,x
  .endscope

  .scope
  lda triple_anglerfish_puzzle_spot1_x_hi,x
  asl triple_anglerfish_puzzle_spot1_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_x_lo,x
  rol
  sta triple_anglerfish_puzzle_spot1_x_hi,x

  lda triple_anglerfish_puzzle_spot1_y_hi,x
  asl triple_anglerfish_puzzle_spot1_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot1_y_lo,x
  rol
  sta triple_anglerfish_puzzle_spot1_y_hi,x
  .endscope

  .scope
  lda triple_anglerfish_puzzle_spot2_x_hi,x
  asl triple_anglerfish_puzzle_spot2_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_x_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_x_lo,x
  rol
  sta triple_anglerfish_puzzle_spot2_x_hi,x

  lda triple_anglerfish_puzzle_spot2_y_hi,x
  asl triple_anglerfish_puzzle_spot2_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_y_lo,x
  rol
  asl triple_anglerfish_puzzle_spot2_y_lo,x
  rol
  sta triple_anglerfish_puzzle_spot2_y_hi,x
  .endscope

  lda #TRIPLE_ANGLERFISH_PUZZLE_STATE_MAIN
  sta entity_state,x

  rts

triple_anglerfish_puzzle_state_main:

  .scope
  ;now test for puzzle conditions, which are:
  ;if any of these are false, we skip checking for the other conditions

  ;spotlight 0 intersects spot 0
  ldy triple_anglerfish_puzzle_anglerfish0,x
  lda anglerfish_is_paused,y
  beq puzzle_not_solved
  jsr compare_spotlight0_spot0
  bne puzzle_not_solved

  ;spotlight 1 intersects spot 1
  ldy triple_anglerfish_puzzle_anglerfish1,x
  lda anglerfish_is_paused,y
  beq puzzle_not_solved
  jsr compare_spotlight1_spot1
  bne puzzle_not_solved

  ;spotlight 2 intersects spot 2
  ldy triple_anglerfish_puzzle_anglerfish2,x
  lda anglerfish_is_paused,y
  beq puzzle_not_solved
  jsr compare_spotlight2_spot2
  bne puzzle_not_solved

puzzle_solved:

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

  lda #150
  sta triple_anglerfish_puzzle_state_counter,x

  lda #TRIPLE_ANGLERFISH_PUZZLE_STATE_KILL_ANGLERFISH
  sta entity_state,x

puzzle_not_solved:
  .endscope

  rts

triple_anglerfish_puzzle_state_kill_anglerfish:

  .scope
  dec triple_anglerfish_puzzle_state_counter,x
  bne do_not_transition_yet

  ;kill off anglerfish (will kill off spotlights too)
  ldy triple_anglerfish_puzzle_anglerfish0,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  ldy triple_anglerfish_puzzle_anglerfish1,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  ldy triple_anglerfish_puzzle_anglerfish2,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  lda #60
  sta triple_anglerfish_puzzle_state_counter,x

  lda #TRIPLE_ANGLERFISH_PUZZLE_STATE_SPAWN_TREASURE_CHEST
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

triple_anglerfish_puzzle_state_spawn_treasure_chest:

  .scope
  dec triple_anglerfish_puzzle_state_counter,x
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
  lda triple_anglerfish_puzzle_dungeon_flags_mask,x
  sta treasure_chest_dungeon_flags_mask,y
  lda #TREASURE_CHEST_MODE_DUNGEON
  sta treasure_chest_mode,y
  lda #TREASURE_CHEST_ITEM_TYPE_KEY
  sta treasure_chest_item_type,y
  lda #<1
  sta treasure_chest_item_quantity_lo,y
  lda #>1
  sta treasure_chest_item_quantity_hi,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  rts

.proc compare_spotlight0_spot0

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy triple_anglerfish_puzzle_spotlight0,x
  lda entity_x_lo,y
  sta w2
  lda entity_x_hi,y
  sta w2+1
  lda entity_y_lo,y
  sta w3
  lda entity_y_hi,y
  sta w3+1
  lda entity_width,y
  sta b2
  lda entity_height,y
  sta b3

  ;transfer spot rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda triple_anglerfish_puzzle_spot0_x_lo,x
  sta w4
  lda triple_anglerfish_puzzle_spot0_x_hi,x
  sta w4+1
  lda triple_anglerfish_puzzle_spot0_y_lo,x
  sta w5
  lda triple_anglerfish_puzzle_spot0_y_hi,x
  sta w5+1
  lda #16
  sta b4
  lda #16
  sta b5

  jsr geotests_rect_in_rect_size

  rts

.endproc

.proc compare_spotlight1_spot1

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy triple_anglerfish_puzzle_spotlight1,x
  lda entity_x_lo,y
  sta w2
  lda entity_x_hi,y
  sta w2+1
  lda entity_y_lo,y
  sta w3
  lda entity_y_hi,y
  sta w3+1
  lda entity_width,y
  sta b2
  lda entity_height,y
  sta b3

  ;transfer spot rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda triple_anglerfish_puzzle_spot1_x_lo,x
  sta w4
  lda triple_anglerfish_puzzle_spot1_x_hi,x
  sta w4+1
  lda triple_anglerfish_puzzle_spot1_y_lo,x
  sta w5
  lda triple_anglerfish_puzzle_spot1_y_hi,x
  sta w5+1
  lda #16
  sta b4
  lda #16
  sta b5

  jsr geotests_rect_in_rect_size

  rts

.endproc

.proc compare_spotlight2_spot2

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy triple_anglerfish_puzzle_spotlight2,x
  lda entity_x_lo,y
  sta w2
  lda entity_x_hi,y
  sta w2+1
  lda entity_y_lo,y
  sta w3
  lda entity_y_hi,y
  sta w3+1
  lda entity_width,y
  sta b2
  lda entity_height,y
  sta b3

  ;transfer spot rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda triple_anglerfish_puzzle_spot2_x_lo,x
  sta w4
  lda triple_anglerfish_puzzle_spot2_x_hi,x
  sta w4+1
  lda triple_anglerfish_puzzle_spot2_y_lo,x
  sta w5
  lda triple_anglerfish_puzzle_spot2_y_hi,x
  sta w5+1
  lda #16
  sta b4
  lda #16
  sta b5

  jsr geotests_rect_in_rect_size

  rts

.endproc

.endif
