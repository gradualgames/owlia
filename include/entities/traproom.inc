.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_MAIN
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_main

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  lda #TRAPROOM_STATE_MAIN
  sta entity_state,x

  rts

traproom_state_main:

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

  ;if there are no enemies alive, unlock the doors and die
  lda b0
  bne enemies_still_alive

  ;find all doors and set them to DOOR_TYPE_LOCKED
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_type,y
  cmp #entity_index_door
  bne not_door

  lda #DOOR_TYPE_UNLOCKED
  sta door_type,y

not_door:
  dey
  bpl next_entity
  .endscope

  ;kill self
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

enemies_still_alive:

  rts

.endif
