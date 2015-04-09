.linecont +
.ifndef BOSS_INC
BOSS_INC = 1

.include "boss_constants.inc"

define_lohi_tables boss, \
 {boss_state_init, \
  boss_state_wait_for_boss_to_die, \
  boss_state_victory}

boss_update:

  entity_state_switchboard boss_lo, boss_hi

boss_state_init:

  .scope
  ;make sure that the boss has only been encountered once
  lda inventory_earned_techs
  cmp boss_earned_tech,x
  bmi do_not_skip_boss

  ;kill all enemies
  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_flags,y
  and #ENTITY_FLAGS_IS_ENEMY_TEST
  beq skip_entity

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

skip_entity:
  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

do_not_skip_boss:
  .endscope

  jsr entity_set_not_pausable

  lda #<octoboss_theme
  sta song_address
  lda #>octoboss_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  lda #BOSS_STATE_WAIT_FOR_BOSS_TO_DIE
  sta entity_state,x

  rts

boss_state_wait_for_boss_to_die:

  ;just count all enemies that are alive. When this is 0, the
  ;boss has been defeated.
  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_flags,y
  and #ENTITY_FLAGS_IS_ENEMY_TEST
  beq skip_entity

  inc b0

skip_entity:
  dey
  bpl next_entity
  .endscope

  .scope
  lda b0
  bne boss_not_dead

  lda #<defeat_boss
  sta song_address
  lda #>defeat_boss
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  lda #220
  sta boss_state_counter,x

  lda #BOSS_STATE_VICTORY
  sta entity_state,x

boss_not_dead:
  .endscope

  rts

boss_state_victory:

  dec boss_state_counter,x
  bne do_not_die_yet

  ;stop all sound
  far_call #SOUND_BANK, sound_stop

  .scope
  ;search for monolith entity in boss's arena and make it fall
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda #MONOLITH_STATE_FALL_INIT
  sta entity_state,y
  jmp done

not_monolith:

  dey
  bpl next_entity
done:
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_die_yet:

  rts

.endif
