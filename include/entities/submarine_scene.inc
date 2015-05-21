.linecont +
.ifndef SUBMARINE_SCENE_INC
SUBMARINE_SCENE_INC = 1

.include "npc_constants.inc"

SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS = 1000

define_entity_properties submarine_scene_state_counter_lo,\
                         submarine_scene_state_counter_hi,\
                         submarine_scene_npc_index

.enum
SUBMARINE_SCENE_STATE_INIT
SUBMARINE_SCENE_STATE_PAUSE_UNTIL_CAPTAIN_BAILS
.endenum

define_lohi_tables submarine_scene, \
 {submarine_scene_state_init, \
  submarine_scene_state_pause_until_captain_bails}

submarine_scene_update:

  entity_state_switchboard submarine_scene_lo, submarine_scene_hi

submarine_scene_state_init:

  ;find the npc in the scene and remember the instance index
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

   lda entity_flags,y
   and #ENTITY_FLAGS_ALIVE_TEST
   beq skip_entity
   lda entity_type,y
   cmp #entity_index_npc
   bne skip_entity

   tya
   sta submarine_scene_npc_index,x
   jmp done

skip_entity:

   dey
   bpl next_entity
done:
  .endscope

  lda #<SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS
  sta submarine_scene_state_counter_lo,x
  lda #>SUBMARINE_SCENE_TIME_UNTIL_CAPTAIN_BAILS
  sta submarine_scene_state_counter_hi,x

  lda #SUBMARINE_SCENE_STATE_PAUSE_UNTIL_CAPTAIN_BAILS
  sta entity_state,x

  rts

submarine_scene_state_pause_until_captain_bails:

  .scope
  sec
  lda submarine_scene_state_counter_lo,x
  sbc #<1
  sta submarine_scene_state_counter_lo,x
  lda submarine_scene_state_counter_hi,x
  sbc #>1
  sta submarine_scene_state_counter_hi,x

  lda submarine_scene_state_counter_lo,x
  ora submarine_scene_state_counter_hi,x
  bne do_not_transition_yet

  ldy submarine_scene_npc_index,x
  lda #conversation_index_run
  sta npc_conversation,y

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

   lda entity_flags,y
   and #ENTITY_FLAGS_ALIVE_TEST
   beq skip_entity
   lda entity_type,y
   cmp #entity_index_crate
   bne skip_entity

   lda #CRATE_STATE_EXPLODE_AND_SPAWN_ENEMIES
   sta entity_state,y

skip_entity:

   dey
   bpl next_entity
done:
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  rts

.endif
