.include "entity.inc"
.include "entities.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"

.segment "CODE"

;clears flags, state, and action for all entities
.proc entity_init_all

  ldx #(MAX_ENTITIES-1)
  lda #0
  
: sta entity_flags,x
  sta entity_state,x
  sta entity_action,x
  
  dex
  bne :-
  
  rts
  
.endproc

;spawns an entity
;b0 is assumed to be the type of entity to spawn
;w0 is assumed to be the 16 bit x coordinate at which to spawn the entity
;w1 is assumed to be the 16 bit y coordinate at which to spawn the entity
.proc entity_spawn
type = b0
spawn_x = w0
spawn_y = w1
  
  ;first search for a dead entity
  ldx #(MAX_ENTITIES-1)

: lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq :+

  dex
  bne :-
:
  ;x now points at a dead entity
  
  ;store the entity type in the new entity
  lda type
  sta entity_type,x
  
  ;clear the entity state to 0 (the init state for all entities)
  lda #0
  sta entity_state,x
  
  ;mark this entity as alive
  lda entity_flags,x
  ora #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x
  
  rts

.endproc

;iterates over all entities. Calls the update routines of all "alive"
;entities.
.proc entity_update_all

  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)
  
: lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq :+
  ;if we arrive here, we've found a living entity. Call its update routine.
  lda entity_type,x
  tay
  lda entity_defs_update_address_lo,y
  sta w0
  lda entity_defs_update_address_hi,y
  sta w0+1
  jsr indirect_jsr_entity_update
:
  dex
  bne :--

  rts

.proc indirect_jsr_entity_update
  jmp (w0)
.endproc
  
.endproc

.proc entity_draw_all

  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)
  
: lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq :+
  ;if we arrive here, we've found a living entity. Draw its animation.
  
  lda entity_animation_address_lo,x
  sta w0
  lda entity_animation_address_hi,x
  sta w0+1
  lda #112
  sta w3
  lda #0
  sta w3+1
  lda #120
  sta w4
  lda #0
  sta w4+1
  lda entity_sprite_group_offset,x
  sta sprite_group_offset
  
  lda entity_animation_frame,x
  sta b0
  lda entity_animation_address_lo,x
  sta w2
  lda entity_animation_address_hi,x
  sta w2+1
    
  jsr sprite_draw_animation_frame
  
:
  dex
  bne :--

  rts

.endproc
