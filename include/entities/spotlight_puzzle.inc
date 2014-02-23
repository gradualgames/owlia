.linecont +
.ifndef SPOTLIGHT_PUZZLE_INC
SPOTLIGHT_PUZZLE_INC = 1

.include "anglerfish_constants.inc"

SPOTLIGHT_DISTANCE = 10

spotlight_index0 = entity_local0
spotlight_index1 = entity_local1
anglerfish_index0 = entity_local2
anglerfish_index1 = entity_local3

.enum
SPOTLIGHT_PUZZLE_STATE_INIT
SPOTLIGHT_PUZZLE_STATE_MAIN
.endenum

.define spotlight_puzzle_states \
  spotlight_puzzle_state_init, \
  spotlight_puzzle_state_main

spotlight_puzzle_lo:
  .lobytes spotlight_puzzle_states

spotlight_puzzle_hi:
  .hibytes spotlight_puzzle_states

spotlight_puzzle_update:

  entity_state_switchboard spotlight_puzzle_lo, spotlight_puzzle_hi

spotlight_puzzle_state_init:

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

  lda #SPOTLIGHT_PUZZLE_STATE_MAIN
  sta entity_state,x

  rts

spotlight_puzzle_state_main:

  ;first check to see if both angler fish have a non zero attack
  ;counter. This means they are both stunned, and is one of the
  ;conditions of this puzzle that must be satisfied
  ldy anglerfish_index0,x
  lda anglerfish_attacked_counter,y
  beq anglerfish_not_both_stunned

  ldy anglerfish_index1,x
  lda anglerfish_attacked_counter,y
  beq anglerfish_not_both_stunned

  jsr check_distance_of_spotlights

anglerfish_not_both_stunned:

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

  ;spawn a key entity where the spotlights meet
  txa
  pha

  lda #entity_index_key
  sta b0

  jsr entity_spawn

  lda #KEY_STATE_PICKUP
  sta key_initial_state,x

  pla
  tax

  ;puzzle is done, no need to do anything else
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
too_far:

  rts

.endproc

.endif
