.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

TRAPROOM_STATE_RAISE_MONOLITH_LENGTH = 20
TRAPROOM_STATE_LOWER_MONOLITH_LENGTH = 20

traproom_state_counter = entity_local0

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_TRAP_HERO
TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
TRAPROOM_STATE_RAISE_MONOLITHS
TRAPROOM_STATE_LOWER_MONOLITHS
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_trap_hero, \
  traproom_state_wait_for_enemies_to_be_killed, \
  traproom_state_raise_monoliths,\
  traproom_state_lower_monoliths

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  lda #$0f
  sta entity_width,x
  sta entity_height,x

  lda #0
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_TRAP_HERO
  sta entity_state,x

  rts

traproom_state_trap_hero:

  lda #TRAPROOM_STATE_RAISE_MONOLITH_LENGTH
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  lda #TRAPROOM_STATE_RAISE_MONOLITH_LENGTH
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_RAISE_MONOLITHS
  sta entity_state,x

  rts

traproom_state_raise_monoliths:

  .scope
  dec traproom_state_counter,x
  bne do_not_transition_yet

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda #MONOLITH_STATE_RISE_INIT
  sta entity_state,y
skip_entity:

  dey
  bpl next_entity
  .endscope

  lda #TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

traproom_state_wait_for_enemies_to_be_killed:

  ;count the number of enemies currently alive
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  cmp #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  bne not_enemy
  inc b0
not_enemy:
  dey
  bpl next_entity
  .endscope

  ;if there are no enemies alive, transition to lower monoliths state
  lda b0
  bne enemies_still_alive

  lda #TRAPROOM_STATE_LOWER_MONOLITH_LENGTH
  sta traproom_state_counter,x

  ;switch to the corresponding "lower" state of this raise state. Assumed
  ;to be +1 from the raise state.
  lda #TRAPROOM_STATE_LOWER_MONOLITHS
  sta entity_state,x

enemies_still_alive:

  rts

traproom_state_lower_monoliths:

  .scope
  dec traproom_state_counter,x
  bne do_not_transition_yet

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_monolith
  bne skip_entity

  lda #MONOLITH_STATE_FALL_INIT
  sta entity_state,y
skip_entity:

  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  rts

.endif
