.linecont +
.ifndef SPOTLIGHT_PUZZLE_INC
SPOTLIGHT_PUZZLE_INC = 1

.include "spotlight_puzzle_constants.inc"
.include "anglerfish_constants.inc"
.include "spotlight_constants.inc"

.define spotlight_puzzle_states \
  spotlight_puzzle_state_init, \
  spotlight_puzzle_state_single_anglerfish, \
  spotlight_puzzle_state_twin_anglerfish, \
  spotlight_puzzle_state_play_solved_melody

spotlight_puzzle_lo:
  .lobytes spotlight_puzzle_states

spotlight_puzzle_hi:
  .hibytes spotlight_puzzle_states

spotlight_puzzle_update:

  entity_state_switchboard spotlight_puzzle_lo, spotlight_puzzle_hi

spotlight_puzzle_state_init:

  lda inventory_dungeon_flags
  and spotlight_dungeon_flags_mask,x
  beq do_not_skip_spotlight_puzzle

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

do_not_skip_spotlight_puzzle:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  ;find both spotlight entities
  spotlight_counter = b0
  lda #0
  sta spotlight_counter
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_type,y
  cmp #entity_index_spotlight
  bne not_spotlight
is_spotlight:
  lda spotlight_counter
  cmp #0
  beq found_first_spotlight
  cmp #1
  beq found_second_spotlight

not_spotlight:
  dey
  bpl next_entity
  jmp done
found_first_spotlight:
  inc spotlight_counter
  tya
  sta spotlight_index0,x
  dey
  bpl next_entity
  jmp done
found_second_spotlight:
  tya
  sta spotlight_index1,x
done:
  .endscope

  ;find both anglerfish entities
  anglerfish_counter = b0
  lda #0
  sta anglerfish_counter
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_type,y
  cmp #entity_index_anglerfish
  bne not_anglerfish
is_anglerfish:
  lda anglerfish_counter
  cmp #0
  beq found_first_anglerfish
  cmp #1
  beq found_second_anglerfish

not_anglerfish:
  dey
  bpl next_entity
  jmp done
found_first_anglerfish:
  inc anglerfish_counter
  tya
  sta anglerfish_index0,x
  dey
  bpl next_entity
  jmp done
found_second_anglerfish:
  tya
  sta anglerfish_index1,x
done:
  .endscope

  ;compute location of key tile
  jsr compute_key_tile_location_in_map_coordinates

  jsr ppu_disable_palette_cycling

  lda spotlight_puzzle_initial_state,x
  sta entity_state,x

  rts

spotlight_puzzle_state_single_anglerfish:

  lda #$08
  sta dynamic_palette+15

  ;check whether the single spotlight entity is
  ;intersecting the destination key tile. This
  ;is used when the spotlight puzzle is configured
  ;for a single anglerfish and spotlight entity.

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy spotlight_index0,x
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

  ;transfer destination key meta tile rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda spotlight_puzzle_key_tile_x_lo,x
  sta w4
  lda spotlight_puzzle_key_tile_x_hi,x
  sta w4+1
  lda spotlight_puzzle_key_tile_y_lo,x
  sta w5
  lda spotlight_puzzle_key_tile_y_hi,x
  sta w5+1
  lda #$0f
  sta b4
  lda #$0f
  sta b5

  jsr geotests_rect_in_rect_size

  bne not_intersecting

  lda #$28
  sta dynamic_palette+15

  ;check to see if the one angler fish has a non-zero
  ;flash counter. This means it is stunned, and is one of
  ;the conditions of this puzzle that must be satisfied
  ldy anglerfish_index0,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_stunned

  lda #$08
  sta dynamic_palette+15

  ;kill the one anglerfish (this will also kill the spotlight)
  ldy anglerfish_index0,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  jsr spawn_key

  lda #SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY_DELAY
  sta spotlight_puzzle_state_counter,x
  lda #SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY
  sta entity_state,x

not_intersecting:

anglerfish_not_stunned:

  rts

spotlight_puzzle_state_twin_anglerfish:

  lda #$08
  sta dynamic_palette+15

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy spotlight_index0,x
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

  ;transfer destination key meta tile rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda spotlight_puzzle_key_tile_x_lo,x
  sta w4
  lda spotlight_puzzle_key_tile_x_hi,x
  sta w4+1
  lda spotlight_puzzle_key_tile_y_lo,x
  sta w5
  lda spotlight_puzzle_key_tile_y_hi,x
  sta w5+1
  lda #$0f
  sta b4
  lda #$0f
  sta b5

  jsr geotests_rect_in_rect_size
  bne spotlight0_not_intersecting

  clc
  lda dynamic_palette+15
  adc #$10
  sta dynamic_palette+15

spotlight0_not_intersecting:

  ;transfer spotlight rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy spotlight_index1,x
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

  ;transfer destination key meta tile rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda spotlight_puzzle_key_tile_x_lo,x
  sta w4
  lda spotlight_puzzle_key_tile_x_hi,x
  sta w4+1
  lda spotlight_puzzle_key_tile_y_lo,x
  sta w5
  lda spotlight_puzzle_key_tile_y_hi,x
  sta w5+1
  lda #$0f
  sta b4
  lda #$0f
  sta b5

  jsr geotests_rect_in_rect_size
  bne spotlight1_not_intersecting

  clc
  lda dynamic_palette+15
  adc #$10
  sta dynamic_palette+15

spotlight1_not_intersecting:

  ;first check to see if both angler fish have a non zero attack
  ;counter. This means they are both stunned, and is one of the
  ;conditions of this puzzle that must be satisfied
  ldy anglerfish_index0,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_both_stunned

  ldy anglerfish_index1,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_both_stunned

  lda dynamic_palette+15
  cmp #$28
  bne puzzle_not_solved

  lda #$08
  sta dynamic_palette+15

  ;kill the two anglerfish (this will also kill the spotlights)
  ldy anglerfish_index0,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  ldy anglerfish_index1,x
  lda #ANGLERFISH_STATE_DIE
  sta entity_state,y

  jsr spawn_key

  lda #SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY_DELAY
  sta spotlight_puzzle_state_counter,x
  lda #SPOTLIGHT_PUZZLE_STATE_PLAY_SOLVED_MELODY
  sta entity_state,x

puzzle_not_solved:
anglerfish_not_both_stunned:

  rts

spotlight_puzzle_state_play_solved_melody:

  .scope
  dec spotlight_puzzle_state_counter,x
  bne not_dead_yet

  jsr spotlight_puzzle_play_solved_melody

  ;puzzle is done, no need to do anything else
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

not_dead_yet:
  .endscope

  rts

.proc spotlight_puzzle_play_solved_melody

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

.proc spawn_key

  lda spotlight_puzzle_key_tile_x_lo,x
  sta w0
  lda spotlight_puzzle_key_tile_x_hi,x
  sta w0+1

  lda spotlight_puzzle_key_tile_y_lo,x
  sta w1
  lda spotlight_puzzle_key_tile_y_hi,x
  sta w1+1

  ;spawn a key entity where the spotlights meet
  lda #entity_index_key
  sta b0

  jsr entity_spawn

  ;forward the puzzle done mask to the key so the key
  ;can mark the puzzle as done when picked up
  ldy spawned_entity
  lda spotlight_dungeon_flags_mask,x
  sta key_dungeon_flags_mask,y

  lda #KEY_STATE_PICKUP
  sta key_initial_state,y

  rts

.endproc

;transforms key destination location from meta tile coordinates
.proc compute_key_tile_location_in_map_coordinates

  ;load the destination location for the key
  lda spotlight_puzzle_key_meta_tile_x,x
  sta spotlight_puzzle_key_tile_x_lo,x
  lda #$00
  sta spotlight_puzzle_key_tile_x_hi,x

  lda spotlight_puzzle_key_meta_tile_y,x
  sta spotlight_puzzle_key_tile_y_lo,x
  lda #$00
  sta spotlight_puzzle_key_tile_y_hi,x

  ;transform to map coordinates for entity_spawn
  lda spotlight_puzzle_key_tile_x_hi,x
  asl spotlight_puzzle_key_tile_x_lo,x
  rol
  asl spotlight_puzzle_key_tile_x_lo,x
  rol
  asl spotlight_puzzle_key_tile_x_lo,x
  rol
  asl spotlight_puzzle_key_tile_x_lo,x
  rol
  sta spotlight_puzzle_key_tile_x_hi,x

  lda spotlight_puzzle_key_tile_y_hi,x
  asl spotlight_puzzle_key_tile_y_lo,x
  rol
  asl spotlight_puzzle_key_tile_y_lo,x
  rol
  asl spotlight_puzzle_key_tile_y_lo,x
  rol
  asl spotlight_puzzle_key_tile_y_lo,x
  rol
  sta spotlight_puzzle_key_tile_y_hi,x

  rts

.endproc

.endif
