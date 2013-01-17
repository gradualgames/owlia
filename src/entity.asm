.include "entity.inc"
.include "entities.inc"
.include "hero.inc"
.include "hero_constants.inc"
.include "familiar.inc"
.include "familiar_constants.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "mapper.inc"
.include "geotests.inc"

.segment "CODE"

;sets ENTITY_FLAGS_DRAWABLE_SORTED, clears ENTITY_FLAGS_DRAWABLE_UNSORTED,
;and sets sorted_entity_index. This causes the current entity to be sorted
;in sprite ram against the hero and the familiar. It should only be used
;when the entity knows it is intersecting with the hero or the familiar.
;Typically, it will only be used by NPCs. Most other entities are enemies
;and will knock the hero back. There's little need to sort them in this
;case.
.proc entity_set_drawable_sorted

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SORTED_SET
  and #ENTITY_FLAGS_DRAWABLE_UNSORTED_CLEAR
  sta entity_flags,x

  stx sorted_entity_index

  rts

.endproc

;sets ENTITY_FLAGS_DRAWABLE_UNSORTED, clears ENTITY_FLAGS_DRAWABLE_SORTED.
.proc entity_set_drawable_unsorted

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_UNSORTED_SET
  and #ENTITY_FLAGS_DRAWABLE_SORTED_CLEAR
  sta entity_flags,x

  rts

.endproc

;compares entity's rect to familiar's rect.
;when zero flag is set, this indicates a hit
;when zero flag is clear, this indicates no hit
.proc entity_test_familiar_rect

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
  sta w2+1
  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1
  lda entity_width,x
  sta b2
  lda entity_height,x
  sta b3

  ;transfer familiar rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda familiar_x
  sta w4
  lda familiar_x+1
  sta w4+1
  lda familiar_y
  sta w5
  lda familiar_y+1
  sta w5+1
  lda familiar_width
  sta b4
  lda familiar_height
  sta b5

  jsr geotests_rect_in_rect_16bit

  rts

.endproc

;compares entity's rect to hero's attack rect.
;when zero flag is set, this indicates a hit
;when zero flag is clear, this indicates no hit
.proc entity_test_hero_attack_rect

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
  sta w2+1
  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1
  lda entity_width,x
  sta b2
  lda entity_height,x
  sta b3

  ;transfer Hitbox rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_attack_rect_x
  sta w4
  lda hero_attack_rect_x+1
  sta w4+1
  lda hero_attack_rect_y
  sta w5
  lda hero_attack_rect_y+1
  sta w5+1
  lda hero_attack_rect_width
  sta b4
  lda hero_attack_rect_height
  sta b5

  jsr geotests_rect_in_rect_16bit

  rts

.endproc

;compares entity's rect to hero's rect.
;when zero flag is set, this indicates a hit
;when zero flag is clear, this indicates no hit
.proc entity_test_hero_rect

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
  sta w2+1
  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1
  lda entity_width,x
  sta b2
  lda entity_height,x
  sta b3

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  jsr geotests_rect_in_rect_16bit

  rts

.endproc

;clears flags, state, and action for all entities
.proc entity_init_all

  ldx #(MAX_ENTITIES-1)
  lda #0
  sta sorted_entity_index

: sta entity_flags,x
  sta entity_state,x

  dex
  bpl :-

  rts

.endproc

;spawns an entity
;b0 is assumed to be the type of entity to spawn
;w0 is assumed to be the 16 bit x coordinate at which to spawn the entity
;w1 is assumed to be the 16 bit y coordinate at which to spawn the entity
;x can be used after calling this routine to modify some initial state of
;the entity (parameterize it somehow)
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
  bpl :-
:
  ;x now points at a dead entity

  ;store the entity type in the new entity
  lda type
  sta entity_type,x

  lda spawn_x
  sta entity_spawn_x_lo,x
  sta entity_x_lo,x
  lda spawn_x+1
  sta entity_spawn_x_hi,x
  sta entity_x_hi,x

  lda spawn_y
  sta entity_spawn_y_lo,x
  sta entity_y_lo,x
  lda spawn_y+1
  sta entity_spawn_y_hi,x
  sta entity_y_hi,x

  ;clear the entity state to 0 (the init state for all entities)
  lda #0
  sta entity_state,x

  ;mark this entity as alive, do not preserve any old flags in the field!
  lda #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x

  rts

.endproc

;iterates over all entities. Calls the update routines of all "alive"
;entities.
.proc entity_update_all

  ;update the two player entities
  switch_bank_ldy #HERO_BANK
  jsr hero_update
  switch_bank_ldy #FAMILIAR_BANK
  jsr familiar_update

  switch_bank_ldy entities_bank

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
  bpl :--

  rts

.proc indirect_jsr_entity_update
  jmp (w0)
.endproc

.endproc

.proc entity_draw_all

  switch_bank_ldy sprites_and_animations_bank

  ;check to see if there is an entity that wants to be sorted
  ;against the player entities
  .scope
  ldx sorted_entity_index
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_SORTED_TEST
  beq sort_hero_and_familiar
sort_hero_familiar_and_entity:

  jsr perform_sort_entity_hero_and_familiar

  jmp done
sort_hero_and_familiar:
  ;sort and display the high priority player entities
  .scope
  sec
  lda hero_y
  sbc familiar_y
  lda hero_y+1
  sbc familiar_y+1
  bmi familiar_below_hero
familiar_above_hero:
  jsr hero_draw
  jsr familiar_draw
  jmp done
familiar_below_hero:
  jsr familiar_draw
  jsr hero_draw
done:
  .endscope
done:
  .endscope

  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)

: lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq :+
  ;if we arrive here, we've found a living entity. Test to see if it is drawable.
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_UNSORTED_TEST
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
  bpl :--

  rts

draw_entity:

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

  rts

perform_sort_entity_hero_and_familiar:

  ;sort and display the high priority player entities
  .scope
  sec
  lda hero_y
  sbc familiar_y
  lda hero_y+1
  sbc familiar_y+1
  bmi familiar_below_hero
familiar_above_hero:

  ;test the entity y against the familiar y
  .scope
  sec
  lda familiar_y
  sbc entity_y_lo,x
  lda familiar_y+1
  sbc entity_y_hi,x
  bmi entity_below_familiar
entity_above_familiar:

  ;we know the order, draw them and jump out
  jsr hero_draw
  jsr familiar_draw
  jsr draw_entity
  jmp done_drawing_sorted

entity_below_familiar:

  .endscope

  .scope
  sec
  lda entity_y_lo,x
  sbc hero_y
  lda entity_y_hi,x
  sbc hero_y+1
  bmi hero_below_entity
hero_above_entity:

  ;we know the order, draw them and jump out
  jsr draw_entity
  jsr hero_draw
  jsr familiar_draw
  jmp done_drawing_sorted

hero_below_entity:
  .endscope

  ;at this point, we know the entity must be between the familiar and the hero.
  ;draw them and jump out.
  jsr hero_draw
  jsr draw_entity
  jsr familiar_draw
  jmp done_drawing_sorted

  jmp done
familiar_below_hero:

  ;test the entity y against the hero y
  .scope
  sec
  lda hero_y
  sbc entity_y_lo,x
  lda hero_y+1
  sbc entity_y_hi,x
  bmi entity_below_hero
entity_above_hero:

  ;we know the order, draw them and jump out
  jsr familiar_draw
  jsr hero_draw
  jsr draw_entity
  jmp done_drawing_sorted

entity_below_hero:

  .endscope

  .scope
  sec
  lda entity_y_lo,x
  sbc familiar_y
  lda entity_y_hi,x
  sbc familiar_y+1
  bmi familiar_below_entity
familiar_above_entity:

  ;we know the order, draw them and jump out
  jsr draw_entity
  jsr familiar_draw
  jsr hero_draw
  jmp done_drawing_sorted

familiar_below_entity:
  .endscope

  ;at this point, we know the entity must be between the familiar and the hero.
  ;draw them and jump out.
  jsr familiar_draw
  jsr draw_entity
  jsr hero_draw
  jmp done_drawing_sorted

done:
  .endscope
done_drawing_sorted:

  rts

.endproc

;resets the current entity's animation
;assumes x is pointing to the current entity instance
.proc entity_reset_animation
animation_rom_address = w2

  switch_bank_ldy sprites_and_animations_bank

  lda entity_animation_address_lo,x
  sta animation_rom_address
  lda entity_animation_address_hi,x
  sta animation_rom_address+1

  ;reset the counter
  ldy #animation_rom::frame_delay
  lda (animation_rom_address),y
  sta entity_animation_counter,x

  ;reset to frame zero
  lda #0
  sta entity_animation_frame,x

  switch_bank_ldy entities_bank

  rts

.endproc

;updates the current entity's animation
;assumes x is pointing to the current entity instance
.proc entity_update_animation
animation_rom_address = w2

  switch_bank_ldy sprites_and_animations_bank

  lda entity_animation_address_lo,x
  sta animation_rom_address
  lda entity_animation_address_hi,x
  sta animation_rom_address+1

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
