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

  ;clear shadow spots, the anglerfish entities may have placed some
  ;jsr sprite_clear_shadow_spots

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

  lda spotlight_puzzle_initial_state,x
  sta entity_state,x

  rts

spotlight_puzzle_state_single_anglerfish:

  ;first check to see if the one angler fish has a non-zero
  ;flash counter. This means it is stunned, and is one of
  ;the conditions of this puzzle that must be satisfied
  ldy anglerfish_index0,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_stunned

  jsr check_spotlight_intersect_destination_key_tile

anglerfish_not_stunned:

  rts

.proc check_spotlight_intersect_destination_key_tile

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

  ;compute destination key meta tile rectangle
  jsr load_key_destination_location

  ;transfer destination key meta tile rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda w0
  sta w4
  lda w0+1
  sta w4+1
  lda w1
  sta w5
  lda w1+1
  sta w5+1
  lda #$0f
  sta b4
  lda #$0f
  sta b5

  jsr geotests_rect_in_rect_size

  bne not_intersecting

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

  rts

.endproc

spotlight_puzzle_state_twin_anglerfish:

  ;first check to see if both angler fish have a non zero attack
  ;counter. This means they are both stunned, and is one of the
  ;conditions of this puzzle that must be satisfied
  ldy anglerfish_index0,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_both_stunned

  ldy anglerfish_index1,x
  lda anglerfish_flash_counter,y
  beq anglerfish_not_both_stunned

  jsr check_distance_of_spotlights

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

.proc check_distance_of_spotlights

  ;compare the positions of the two spotlight entities by
  ;comparing the difference of their X and Y coordinates.
  ;if small enough, we consider them close enough for the
  ;puzzle to be "completed." At this stage, we make both
  ;spotlights and both angler fish passive so that they
  ;continue shining their lights on the same spot. We spawn
  ;a key entity for the player to retrieve with the fetch
  ;tech.

  spotlight0_x = w0
  spotlight0_y = w1
  spotlight1_x = w2
  spotlight1_y = w3
  spotlight_x_distance = w4
  spotlight_y_distance = w5

  ldy spotlight_index0,x
  lda entity_x_lo,y
  sta spotlight0_x
  lda entity_x_hi,y
  sta spotlight0_x+1

  lda entity_y_lo,y
  sta spotlight0_y
  lda entity_y_hi,y
  sta spotlight0_y+1

  ldy spotlight_index1,x
  lda entity_x_lo,y
  sta spotlight1_x
  lda entity_x_hi,y
  sta spotlight1_x+1

  lda entity_y_lo,y
  sta spotlight1_y
  lda entity_y_hi,y
  sta spotlight1_y+1

  .scope
  sec
  lda spotlight1_x
  sbc spotlight0_x
  sta spotlight_x_distance
  lda spotlight1_x+1
  sbc spotlight0_x+1
  sta spotlight_x_distance+1
  bpl do_not_find_abs_value

  clc
  lda spotlight_x_distance
  eor #$ff
  adc #$01
  sta spotlight_x_distance
  lda spotlight_x_distance+1
  eor #$ff
  adc #$00
  sta spotlight_x_distance+1

do_not_find_abs_value:
  .endscope

  .scope
  sec
  lda spotlight1_y
  sbc spotlight0_y
  sta spotlight_y_distance
  lda spotlight1_y+1
  sbc spotlight0_y+1
  sta spotlight_y_distance+1
  bpl do_not_find_abs_value

  clc
  lda spotlight_y_distance
  eor #$ff
  adc #$01
  sta spotlight_y_distance
  lda spotlight_y_distance+1
  eor #$ff
  adc #$00
  sta spotlight_y_distance+1

do_not_find_abs_value:
  .endscope

  sec
  lda spotlight_x_distance
  sbc #SPOTLIGHT_DISTANCE
  lda spotlight_x_distance+1
  sbc #$00
  bpl too_far

  sec
  lda spotlight_y_distance
  sbc #SPOTLIGHT_DISTANCE
  lda spotlight_y_distance+1
  sbc #$00
  bpl too_far
close_enough:

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

  rts
too_far:

  rts

.endproc

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

  jsr load_key_destination_location

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
;to map coordinates returning in w0 and w1
.proc load_key_destination_location

  ;load the destination location for the key
  lda spotlight_puzzle_key_meta_tile_x,x
  sta w0
  lda #$00
  sta w0+1

  lda spotlight_puzzle_key_meta_tile_y,x
  sta w1
  lda #$00
  sta w1+1

  ;transform to map coordinates for entity_spawn
  lda w0+1
  asl w0
  rol
  asl w0
  rol
  asl w0
  rol
  asl w0
  rol
  sta w0+1

  lda w1+1
  asl w1
  rol
  asl w1
  rol
  asl w1
  rol
  asl w1
  rol
  sta w1+1

  rts

.endproc

.endif
