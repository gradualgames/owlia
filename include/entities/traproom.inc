.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

traproom_state_counter = entity_local0

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_FLASH_DOORS
TRAPROOM_STATE_MAIN
TRAPROOM_STATE_DELAY_THEN_FLASH_DOORS_AND_DIE
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_flash_doors, \
  traproom_state_main, \
  traproom_state_delay_then_flash_doors_and_die

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  lda #0
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_FLASH_DOORS
  sta entity_state,x

  rts

traproom_state_flash_doors:

  jsr flash_all_doors

  jsr play_door_slam_sound

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

  ;find all doors and set them to DOOR_TYPE_UNLOCKED
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

  lda #20
  sta traproom_state_counter,x

  lda #TRAPROOM_STATE_DELAY_THEN_FLASH_DOORS_AND_DIE
  sta entity_state,x

enemies_still_alive:

  rts

traproom_state_delay_then_flash_doors_and_die:

  dec traproom_state_counter,x
  bne delay_not_over_yet

  jsr flash_all_doors

  jsr play_door_slam_sound

  ;kill self
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

delay_not_over_yet:

  rts

.proc flash_all_doors

  ;find all doors and set their state to DOOR_STATE_FLASH
  ldy #(MAX_ENTITIES-1)
  .scope
next_entity:
  lda entity_type,y
  cmp #entity_index_door
  bne not_door

  lda #DOOR_STATE_FLASH
  sta entity_state,y

not_door:
  dey
  bpl next_entity
  .endscope

  rts

.endproc

.proc play_door_slam_sound

  ;play a sound
  txa
  pha

  lda #<sfx_door_slam
  sta sound_param_word_0
  lda #>sfx_door_slam
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_two
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.endif
