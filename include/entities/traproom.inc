.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

traproom_state_counter = entity_local0

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_RAISE_MONOLITHS
TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_raise_monoliths, \
  traproom_state_wait_for_enemies_to_be_killed

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  lda #0
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_RAISE_MONOLITHS
  sta entity_state,x

  rts

traproom_state_raise_monoliths:

  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda monolith_direction,y
  cmp #MONOLITH_DIRECTION_EAST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_WEST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_NORTH
  beq n_s_monolith
  cmp #MONOLITH_DIRECTION_SOUTH
  beq n_s_monolith
n_s_monolith:

  lda #MONOLITH_STATE_RISE_USING_COLUMNS_INIT
  sta entity_state,y

  dey
  bpl next_entity

e_w_monolith:

  lda #MONOLITH_STATE_RISE_USING_ROWS_INIT
  sta entity_state,y

  dey
  bpl next_entity

not_monolith:
  dey
  bpl next_entity
  .endscope

  lda #TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
  sta entity_state,x

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

  ;if there are no enemies alive, make the monoliths fall, then kill self
  lda b0
  bne enemies_still_alive

  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST)
  cmp #(ENTITY_FLAGS_ALIVE_TEST)
  bne not_monolith
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda monolith_direction,y
  cmp #MONOLITH_DIRECTION_EAST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_WEST
  beq e_w_monolith
  cmp #MONOLITH_DIRECTION_NORTH
  beq n_s_monolith
  cmp #MONOLITH_DIRECTION_SOUTH
  beq n_s_monolith
n_s_monolith:

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,y

  dey
  bpl next_entity

e_w_monolith:

  lda #MONOLITH_STATE_FALL_USING_ROWS_INIT
  sta entity_state,y

  dey
  bpl next_entity

not_monolith:
  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

enemies_still_alive:

  rts

.endif
