.linecont +
.ifndef TREASURE_ROOM_INC
TREASURE_ROOM_INC = 1

.include "treasure_room_constants.inc"
.include "treasure_chest_constants.inc"

.define treasure_room_states \
  treasure_room_state_init, \
  treasure_room_state_main, \
  treasure_room_state_spawn_treasure_chest

treasure_room_lo:
  .lobytes treasure_room_states

treasure_room_hi:
  .hibytes treasure_room_states

treasure_room_update:

  entity_state_switchboard treasure_room_lo, treasure_room_hi

treasure_room_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  .scope
  lda inventory_puzzle_flags
  and treasure_room_puzzle_flags_mask,x
  beq do_not_skip_treasure_room

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts
do_not_skip_treasure_room:
  .endscope

  lda #TREASURE_ROOM_STATE_MAIN
  sta entity_state,x

  rts

treasure_room_state_main:

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

  .scope
  ;if there are no enemies alive, spawn a treasure chest with forwarded parameters
  lda b0
  bne enemies_still_alive

  lda #100
  sta treasure_room_state_counter,x

  lda #TREASURE_ROOM_STATE_SPAWN_TREASURE_CHEST
  sta entity_state,x

enemies_still_alive:
  .endscope

  rts

treasure_room_state_spawn_treasure_chest:

  .scope
  dec treasure_room_state_counter,x
  bne do_not_spawn_treasure_chest

  ;play a sound
  txa
  pha

  lda #<sfx_chest_melody
  sta sound_param_word_0
  lda #>sfx_chest_melody
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

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
  lda treasure_room_puzzle_flags_mask,x
  sta treasure_chest_puzzle_flags_mask,y
  lda treasure_room_treasure_chest_type,x
  sta treasure_chest_item_type,y
  lda treasure_room_treasure_chest_quantity_lo,x
  sta treasure_chest_item_quantity_lo,y
  lda treasure_room_treasure_chest_quantity_hi,x
  sta treasure_chest_item_quantity_hi,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_spawn_treasure_chest:
  .endscope

  rts

.endif
