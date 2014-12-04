.linecont +
.ifndef ORDERED_DEFEAT_PUZZLE_INC
ORDERED_DEFEAT_PUZZLE_INC = 1

.include "ordered_defeat_puzzle_constants.inc"

.define ordered_defeat_puzzle_states \
  ordered_defeat_puzzle_state_init, \
  ordered_defeat_puzzle_state_step0, \
  ordered_defeat_puzzle_state_step1, \
  ordered_defeat_puzzle_state_step2, \
  ordered_defeat_puzzle_state_complete, \
  ordered_defeat_puzzle_state_fail

ordered_defeat_puzzle_lo:
  .lobytes ordered_defeat_puzzle_states

ordered_defeat_puzzle_hi:
  .hibytes ordered_defeat_puzzle_states

ordered_defeat_puzzle_update:

  entity_state_switchboard ordered_defeat_puzzle_lo, ordered_defeat_puzzle_hi

ordered_defeat_puzzle_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  ;find the entities in the order specified in the ordered puzzle parameters.
  ;we assume all three have been properly configured.
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq entity_not_alive

  .scope
  lda entity_type,y
  cmp ordered_defeat_puzzle_entity_type0,x
  bne not_type0
  tya
  sta ordered_defeat_puzzle_entity_instance0,x
not_type0:
  .endscope

  .scope
  lda entity_type,y
  cmp ordered_defeat_puzzle_entity_type1,x
  bne not_type1
  tya
  sta ordered_defeat_puzzle_entity_instance1,x
not_type1:
  .endscope

  .scope
  lda entity_type,y
  cmp ordered_defeat_puzzle_entity_type2,x
  bne not_type2
  tya
  sta ordered_defeat_puzzle_entity_instance2,x
not_type2:
  .endscope
entity_not_alive:

  dey
  bpl next_entity
  .endscope

  ;start at step 0. (search for when entity_instance0 dies first, then 1, then 2, to complete the puzzle)
  lda #0
  sta ordered_defeat_puzzle_step,x

  lda #ORDERED_DEFEAT_PUZZLE_STATE_STEP0
  sta entity_state,x

  rts

ordered_defeat_puzzle_state_step0:

  ;detect if entity1 has been defeated, if so, transition to fail state.
  .scope
  ldy ordered_defeat_puzzle_entity_instance1,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_FAIL
  sta entity_state,x

entity_alive:
  .endscope

  ;detect if entity2 has been defeated, if so, transition to fail state.
  .scope
  ldy ordered_defeat_puzzle_entity_instance2,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_FAIL
  sta entity_state,x

entity_alive:
  .endscope

  ;detect if entity0 has been defeated, if so, transition to step1.
  .scope
  ldy ordered_defeat_puzzle_entity_instance0,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_STEP1
  sta entity_state,x

entity_alive:
  .endscope

  rts

ordered_defeat_puzzle_state_step1:

  ;detect if entity2 has been defeated, if so, transition to fail state.
  .scope
  ldy ordered_defeat_puzzle_entity_instance2,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_FAIL
  sta entity_state,x

entity_alive:
  .endscope

  ;detect if entity1 has been defeated, if so, transition to step2.
  .scope
  ldy ordered_defeat_puzzle_entity_instance1,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_STEP2
  sta entity_state,x

entity_alive:
  .endscope

  rts

ordered_defeat_puzzle_state_step2:

  ;detect if entity2 has been defeated, if so, transition to complete state.
  .scope
  ldy ordered_defeat_puzzle_entity_instance2,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  bne entity_alive

  lda #ORDERED_DEFEAT_PUZZLE_STATE_COMPLETE
  sta entity_state,x

entity_alive:
  .endscope

  rts

ordered_defeat_puzzle_state_complete:

  ;play a sound
  lda #<sfx_solved_puzzle_instrument_one
  sta sound_param_word_0
  lda #>sfx_solved_puzzle_instrument_one
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  ;play a sound
  lda #<sfx_solved_puzzle_instrument_two
  sta sound_param_word_0
  lda #>sfx_solved_puzzle_instrument_two
  sta sound_param_word_0+1

  lda #1
  sta sound_param_byte_0
  lda #soundeffect_two
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

ordered_defeat_puzzle_state_fail:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endif
