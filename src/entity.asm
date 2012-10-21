.include "entity.inc"
.include "entities.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "mapper.inc"

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
  ;if we arrive here, we've found a living entity. Test to see if it is drawable.
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_TEST
  beq :+
  ;the entity is drawable so proceed to calculate screen coords and draw its animation

  lda entity_animation_address_lo,x
  sta w0
  lda entity_animation_address_hi,x
  sta w0+1

  ;calculate screen coordinates based on the camera coordinates
  sec
  lda entity_x_lo,x
  sbc camera_x
  sta w3
  lda entity_x_hi,x
  sbc camera_x+1
  sta w3+1

  sec
  lda entity_y_lo,x
  sbc camera_y
  sta w4
  lda entity_y_hi,x
  sbc camera_y+1
  sta w4+1

  ;subtract 8 to correct for the needed nametable offset to straddle metatile updates
  ;between the topmost row of nametable tiles and the bottommost row of nametable tiles
  clc
  lda w4
  adc #$08
  sta w4
  lda w4+1
  adc #$00
  sta w4+1

  lda entity_sprite_group_offset,x
  sta sprite_group_offset

  lda entity_sprite_flags,x
  sta b2

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

;resets the current entity's animation
;assumes x is pointing to the current entity instance
.proc entity_reset_animation
animation_rom_address = w2

  ;reset the counter
  lda #1
  sta entity_animation_counter,x

  ;reset to frame zero
  lda #0
  sta entity_animation_frame,x

  rts

.endproc

;updates the current entity's animation
;assumes x is pointing to the current entity instance
.proc entity_update_animation
animation_rom_address = w2

  switch_bank_ldy sprites_and_animations_bank

  dec entity_animation_counter,x
  bne :+

  ;reset the counter
  ldy #animation_rom::frame_delay
  lda (animation_rom_address),y
  sta entity_animation_counter,x

  ;advance the frame
  clc
  lda entity_animation_frame,x
  adc #2
  sta entity_animation_frame,x

  ldy #animation_rom::frame_count
  cmp (animation_rom_address),y
  bne :+

  ;reset to frame zero
  lda #0
  sta entity_animation_frame,x

:

  switch_bank_ldy entities_bank

  rts

.endproc
