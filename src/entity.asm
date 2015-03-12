.include "ndxdebug.h"
.include "entity.inc"
.include "entities.inc"
.include "hero.inc"
.include "hero_constants.inc"
.include "familiar.inc"
.include "familiar_constants.inc"
.include "item_constants.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprite.inc"
.include "mapper.inc"
.include "geotests.inc"
.include "camera.inc"
.include "textbox.inc"
.include "ppu.inc"
.include "locations.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "util.inc"
.include "inventory.inc"

.segment "CODE"

.proc entity_module_init

  lda #$00
  ldx #(entity_action_rect_ram_end - entity_action_rect_ram_start - 1)
: sta entity_action_rect_ram_start,x
  dex
  bpl :-

  rts

.endproc

;This routine looks up the desired sprite_chr_group_index within the
;current sprite_chr_groups for the current location. When it is found,
;the index of the found entry is used as the index into sprite_chr_group_offsets
;in ram to find the correct sprite chr offset for this entity. It starts looking
;at the end of the sprite_chr_groups table because the first few entries are
;almost always the hard coded hero and familiar sprite chr groups. Generally, this
;routine would only ever be called within the init routine of any given entity.
;expects b0 to contain desired sprite_chr_group_index.
;expects x to point at the entity for which we are looking up a chr group offset.
.proc entity_lookup_sprite_chr_offset

  save_calling_bank

  ;Get count in current sprite_chr_groups for current location.
  ;Point y to the last entry in the table.
  switch_bank_ldy #LOCATIONS_BANK
  ldy #0
  lda (sprite_chr_groups_address),y
  tay
next_entry:

  lda b0
  cmp (sprite_chr_groups_address),y
  beq found_group

  dey
  bpl next_entry
found_group:

  ;sprite_chr_group_offsets is off by one relative to the
  ;entries in a current location's sprite_chr_groups table because
  ;there is a "count" byte at the beginning of the table.
  lda sprite_chr_group_offsets-1,y
  sta entity_sprite_group_offset,x

  restore_calling_bank_y

  rts

.endproc

.proc entity_spawn_explosion

  lda #entity_index_explosion
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

  rts

.endproc

.proc entity_drop_random_item

  lda #entity_index_item
  sta b0

  ;calculate adjustments for initial location of dropped item to be
  ;roughly the center of the entity
  lda entity_width,x
  lsr
  sta b1
  lda entity_height,x
  lsr
  sta b2

  sec
  lda b1
  sbc #4
  sta b1
  sec
  lda b2
  sbc #4
  sta b2

  clc
  lda entity_x_lo,x
  adc b1
  sta w0
  lda entity_x_hi,x
  adc #0
  sta w0+1
  clc
  lda entity_y_lo,x
  adc b2
  sta w1
  lda entity_y_hi,x
  adc #0
  sta w1+1

  jsr entity_spawn

  .scope
  ldy spawned_entity
  bmi entity_not_spawned
  lda #ITEM_STATE_DROP_RANDOM_ITEM_INIT
  sta item_initial_state,y
  lda #INVENTORY_DUNGEON_FLAGS_MASK_NOP
  sta item_dungeon_flags_mask,y
entity_not_spawned:
  .endscope

  rts

.endproc

;drops a specific type of item.
;expects b3 to contain ITEM_TYPE (see item_constants.inc)
;expects b4 to contain quantity.
.proc entity_drop_item

  lda #entity_index_item
  sta b0

  ;calculate adjustments for initial location of dropped item to be
  ;roughly the center of the entity
  lda entity_width,x
  lsr
  sta b1
  lda entity_height,x
  lsr
  sta b2

  sec
  lda b1
  sbc #4
  sta b1
  sec
  lda b2
  sbc #4
  sta b2

  clc
  lda entity_x_lo,x
  adc b1
  sta w0
  lda entity_x_hi,x
  adc #0
  sta w0+1
  clc
  lda entity_y_lo,x
  adc b2
  sta w1
  lda entity_y_hi,x
  adc #0
  sta w1+1

  jsr entity_spawn

  .scope
  ldy spawned_entity
  bmi entity_not_spawned
  lda b3
  sta item_type,y
  lda b4
  sta item_quantity_lo,y
  lda #0
  sta item_quantity_hi,y
  lda #ITEM_STATE_PICKUP_AND_FADE_OUT_INIT
  sta item_initial_state,y
  lda #INVENTORY_DUNGEON_FLAGS_MASK_NOP
  sta item_dungeon_flags_mask,y
entity_not_spawned:
  .endscope

  rts

.endproc

;This routine calls hero_hurt after correctly calculating
;the proper knockback direction for the hero based on the
;relative position of the approximate center points of both
;the hero and the entity.
.proc entity_hurt_hero

  entity_halfwidth = b0
  entity_halfheight = b1
  entity_center_x = w0
  entity_center_y = w1
  hero_center_x = w2
  hero_center_y = w3
  x_difference = w4
  y_difference = w5

  ;calculate half the width and height for this entity
  lda entity_width,x
  lsr
  sta entity_halfwidth

  lda entity_height,x
  lsr
  sta entity_halfheight

  ;get center of entity's x coordinate
  clc
  lda entity_x_lo,x
  adc entity_halfwidth
  sta entity_center_x
  lda entity_x_hi,x
  adc #$00
  sta entity_center_x+1

  ;get center of entity's y coordinate
  clc
  lda entity_y_lo,x
  adc entity_halfheight
  sta entity_center_y
  lda entity_y_hi,x
  adc #$00
  sta entity_center_y+1

  ;get center of hero's x coordinate
  clc
  lda hero_x
  adc #(HERO_WIDTH/2)
  sta hero_center_x
  lda hero_x+1
  adc #$00
  sta hero_center_x+1

  ;get center of hero's y coordinate
  clc
  lda hero_y
  adc #(HERO_HEIGHT/2)
  sta hero_center_y
  lda hero_y+1
  adc #$00
  sta hero_center_y+1

  ;get absolute differences
  .scope
  sec
  lda entity_center_x
  sbc hero_center_x
  sta x_difference
  lda entity_center_x+1
  sbc hero_center_x+1
  sta x_difference+1
  bpl do_not_get_absolute_value

  ;negate x_difference
  lda x_difference
  eor #$ff
  sta x_difference
  lda x_difference+1
  eor #$ff
  sta x_difference+1

  clc
  lda x_difference
  adc #$01
  sta x_difference
  lda x_difference+1
  adc #$00
  sta x_difference+1

do_not_get_absolute_value:
  .endscope

  .scope
  sec
  lda entity_center_y
  sbc hero_center_y
  sta y_difference
  lda entity_center_y+1
  sbc hero_center_y+1
  sta y_difference+1
  bpl do_not_get_absolute_value

  ;negate y_difference
  lda y_difference
  eor #$ff
  sta y_difference
  lda y_difference+1
  eor #$ff
  sta y_difference+1

  clc
  lda y_difference
  adc #$01
  sta y_difference
  lda y_difference+1
  adc #$00
  sta y_difference+1

do_not_get_absolute_value:
  .endscope

  .scope
  sec
  lda x_difference
  sbc y_difference
  lda x_difference+1
  sbc y_difference+1
  bmi use_y_difference
use_x_difference:

  .scope
  sec
  lda hero_center_x
  sbc entity_center_x
  lda hero_center_x+1
  sbc entity_center_x+1
  bmi hero_to_left
hero_to_right:
  lda #ENTITY_DIRECTION_RIGHT
  sta b0
  jmp done
hero_to_left:
  lda #ENTITY_DIRECTION_LEFT
  sta b0
done:
  .endscope

  jmp done

use_y_difference:
  .scope
  sec
  lda hero_center_y
  sbc entity_center_y
  lda hero_center_y+1
  sbc entity_center_y+1
  bmi hero_above
hero_below:
  lda #ENTITY_DIRECTION_DOWN
  sta b0
  jmp done
hero_above:
  lda #ENTITY_DIRECTION_UP
  sta b0
done:
  .endscope

done:
  .endscope

  far_call #HERO_BANK, hero_hurt

  rts

.endproc

;This routine searches for a living entity marked as an enemy
;Returns with x pointing to the living entity that is an enemy
.proc entity_find_enemy

  ldx #(MAX_ENTITIES-1)
next_entity:

  ;exit the loop only if an entity is found which is alive, an enemy, and NOT paused.
  ;otherwise, the loop will end with x as $ff, meaning no live enemy was found.
  lda entity_flags,x
  and #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST|ENTITY_FLAGS_PAUSED_TEST)
  cmp #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
  beq enemy_found

  dex
  bpl next_entity
enemy_found:

  rts

.endproc

;this routine is a trampoline wrapper for ppu_load_dynamic_palette_brightness_bg
;it saves the calling bank, changes the palette based on the current palette
;and then returns to the calling bank. this only adjusts brightness for the bg palette
;expects b3 to contain desired brightness level
;uses b0 temporarily
.proc entity_change_palette_brightness_bg_trampoline

  ;save calling bank
  lda current_bank
  pha

  ;load palette address
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::palette_address
  lda (location_address),y
  sta palette_address
  iny
  lda (location_address),y
  sta palette_address+1

  ;adjust the brightness of the dynamic palette based on the palette at palette_address
  jsr ppu_load_dynamic_palette_brightness_bg

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc

;this routine is a trampoline wrapper for ppu_load_dynamic_palette_brightness_spr
;it saves the calling bank, changes the palette based on the current palette
;and then returns to the calling bank. this only adjusts brightness for the spr palette
;expects b3 to contain desired brightness level
;uses b0 temporarily
.proc entity_change_palette_brightness_spr_trampoline

  ;save calling bank
  lda current_bank
  pha

  ;load palette address
  switch_bank_ldy #LOCATIONS_BANK
  ldy #location::palette_address
  lda (location_address),y
  sta palette_address
  iny
  lda (location_address),y
  sta palette_address+1

  ;adjust the brightness of the dynamic palette based on the palette at palette_address
  jsr ppu_load_dynamic_palette_brightness_spr

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc

;Marks this entity as an enemy.
.proc entity_set_is_enemy

  lda entity_flags,x
  ora #ENTITY_FLAGS_IS_ENEMY_SET
  sta entity_flags,x

  rts

.endproc

;Sets this entity to be the third participant this frame in the
;3 way sorting system between the hero, familiar, and entity.
;Typically this is only used by NPCs. Everything else is an enemy
;and will hit the hero and cause her to knock back and flash, or,
;the familiar will be flying above everything, etc. etc. So we
;only use it in very limited and special circumstances.
.proc entity_set_sorted

  stx sorted_entity_index

  rts

.endproc

;Sets this entity to be drawable
.proc entity_set_drawable

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  rts

.endproc

;Sets this entity to be not drawable (hidden)
.proc entity_clear_drawable

  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_CLEAR
  sta entity_flags,x

  rts

.endproc

;Flags that this entity should not be paused even if it
;goes outside of the pause/unpause rect.
.proc entity_set_not_pausable

  lda entity_flags,x
  ora #ENTITY_FLAGS_NOT_PAUSABLE_SET
  sta entity_flags,x

  rts

.endproc

;sets the shadow spot enabled flag.
.proc entity_set_shadow_spot

  lda entity_flags,x
  ora #ENTITY_FLAGS_SHADOW_SPOT_SET
  sta entity_flags,x

  rts

.endproc

;clears the shadow spot enabled flag.
.proc entity_clear_shadow_spot

  lda entity_flags,x
  and #ENTITY_FLAGS_SHADOW_SPOT_CLEAR
  sta entity_flags,x

  rts

.endproc

;compares entity's screen rect to the camera screen rect.
;must be called after the entity's screen coordinates have been
;calculated or the results will be invalid. Assumes x points to
;this entity.
.proc entity_test_screen_rect

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

  ;transfer screen rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda camera_x
  sta w4
  lda camera_x+1
  sta w4+1
  lda camera_y
  sta w5
  lda camera_y+1
  sta w5+1
  lda #CAMERA_SCREEN_WIDTH
  sta b4
  lda #CAMERA_SCREEN_HEIGHT
  sta b5

  jsr geotests_rect_in_rect_size

  rts

.endproc

;compares entity's rect to entity action rect 1.
;when zero flag is set, this indicates a hit
;when zero flag is clear, this indicates no hit
.proc entity_test_entity_action_rect1

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

  ;transfer entity action rect1 rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda entity_action_rect1_x
  sta w4
  lda entity_action_rect1_x+1
  sta w4+1
  lda entity_action_rect1_y
  sta w5
  lda entity_action_rect1_y+1
  sta w5+1
  lda entity_action_rect1_width
  sta b4
  lda entity_action_rect1_height
  sta b5

  jsr geotests_rect_in_rect_size

  rts

.endproc

;compares entity's rect to entity action rect 2.
;when zero flag is set, this indicates a hit
;when zero flag is clear, this indicates no hit
.proc entity_test_entity_action_rect2

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

  ;transfer entity action rect2 rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda entity_action_rect2_x
  sta w4
  lda entity_action_rect2_x+1
  sta w4+1
  lda entity_action_rect2_y
  sta w5
  lda entity_action_rect2_y+1
  sta w5+1
  lda entity_action_rect2_width
  sta b4
  lda entity_action_rect2_height
  sta b5

  jsr geotests_rect_in_rect_size

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

  jsr geotests_rect_in_rect_size

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

  jsr geotests_rect_in_rect_size

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

;marks all currently living entities to be killed later. As of this
;comment, this is primarily used for marking all currently living
;entities to be killed after successfully scrolling to a new location.
.proc entity_mark_all_for_kill

  ldx #(MAX_ENTITIES-1)
:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  cpx familiar_carried_entity_index
  beq skip_entity

  lda entity_flags,x
  ora #ENTITY_FLAGS_MARKED_FOR_KILL_SET
  sta entity_flags,x

skip_entity:

  dex
  bpl :-

  rts

.endproc

;kills all entities marked as "marked for kill."
.proc entity_kill_all_marked_for_kill

  ldx #(MAX_ENTITIES-1)
:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_flags,x
  and #ENTITY_FLAGS_MARKED_FOR_KILL_TEST
  beq skip_entity
  cpx familiar_carried_entity_index
  beq skip_entity

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

skip_entity:

  dex
  bpl :-

  rts

.endproc

;spawns an entity
;b0 is assumed to be the type of entity to spawn
;w0 is assumed to be the 16 bit x coordinate at which to spawn the entity
;w1 is assumed to be the 16 bit y coordinate at which to spawn the entity
;preserves the x register
;spawned_entity can be used after calling this routine to modify some initial state of
;the entity (parameterize it somehow)
;NOTE: If no entities could be spawned, this routine will return with the
;spawned_entity being $ff
.proc entity_spawn
type = b0
spawn_x = w0
spawn_y = w1

  ;save x
  txa
  pha

  ;first search for a dead entity
  ldx #(MAX_ENTITIES-1)

next_entity:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq found_dead_entity

  dex
  bpl next_entity

  stx spawned_entity
  ;didn't find any dead entities, just exit
  ;restore x
  pla
  tax

  rts

found_dead_entity:

  ;x now points at a dead entity

  ;store the entity type in the new entity
  lda type
  sta entity_type,x

  lda spawn_x
  sta entity_x_lo,x
  lda spawn_x+1
  sta entity_x_hi,x

  lda spawn_y
  sta entity_y_lo,x
  lda spawn_y+1
  sta entity_y_hi,x

  ;clear the entity state to 0 (the init state for all entities)
  lda #0
  sta entity_state,x

  ;mark this entity as alive, do not preserve any old flags in the field!
  lda #ENTITY_FLAGS_ALIVE_SET
  sta entity_flags,x

  stx spawned_entity

  ;restore x
  pla
  tax

  rts

.endproc

;Updates hero, familiar, and all non player entities.
;NOTE! This procedure intentionally spills into entity_update_npe,
;to provide shared functionality without duplicating code.
.proc entity_update_all

  ;update the two player entities
  switch_bank_ldy #HERO_BANK
  jsr hero_update
  jsr hero_eject_from_solid_tiles
  switch_bank_ldy #FAMILIAR_BANK
  jsr familiar_update

.endproc

;Updates only non player entities.
.proc entity_update_npe

  ;there are no sorted entities until they signify that they are
  lda #$ff
  sta sorted_entity_index

  ;iterate over all entities
  lda #(MAX_ENTITIES-1)
  sta entity_index

next_entity:
  ldx entity_index
  lda entity_flags,x
  and #(ENTITY_FLAGS_ALIVE_TEST)
  beq skip_entity
  lda entity_flags,x
  and #(ENTITY_FLAGS_PAUSED_TEST)
  bne skip_entity
  lda entity_flags,x
  ;if we arrive here, we've found a living entity. Call its update routine.
  lda entity_type,x
  tay
  switch_bank_ldx #ENTITIES_BANK
  lda entity_defs_update_address_lo,y
  sta w0
  lda entity_defs_update_address_hi,y
  sta w0+1
  lda entity_defs_update_address_bank,y
  tay
  switch_bank_y
  ldx entity_index
  jsr indirect_jsr_w0
skip_entity:
  dec entity_index
  bpl next_entity

  rts

.endproc

;used before a textbox is displayed. Checks each entity against the textbox rect,
;and then aligns it to the nearest nametable boundary. This is to be used before
;hiding sprites that intersect with the textbox.
.proc align_entities_if_occluded_by_textbox

  switch_bank_ldy #HERO_BANK
  jsr align_hero_if_occluded_by_textbox
  switch_bank_ldy #FAMILIAR_BANK
  jsr align_familiar_if_occluded_by_textbox

  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)

:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq entity_not_alive

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_screen_x_lo,x
  sta w2
  lda entity_screen_x_hi,x
  sta w2+1
  lda entity_screen_y_lo,x
  sta w3
  lda entity_screen_y_hi,x
  sta w3+1
  lda entity_width,x
  sta b2
  lda entity_height,x
  sta b3

  ;transfer textbox rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda #TEXTBOX_SCREEN_X
  sta w4
  lda #0
  sta w4+1
  lda #TEXTBOX_SCREEN_Y
  sta w5
  lda #0
  sta w5+1
  lda #TEXTBOX_WIDTH
  sta b4
  lda #TEXTBOX_HEIGHT
  sta b5

  jsr geotests_rect_in_rect_size
  bne does_not_intersect_textbox

  lda entity_screen_y_lo,x
  and #%00000100
  bne round_up
round_down:
  lda entity_screen_y_lo,x
  and #%11111000
  sec
  sbc #$01
  sta entity_screen_y_lo,x
  jmp done
round_up:
  lda entity_screen_y_lo,x
  and #%11111000
  clc
  adc #$07
  sta entity_screen_y_lo,x
done:

does_not_intersect_textbox:

entity_not_alive:

  dex
  bpl :-

  rts

.endproc

;compute screen coordinates for all entities
.proc entity_calculate_screen_coordinates_all

  switch_bank_ldy #HERO_BANK
  jsr hero_calculate_screen_coordinates
  switch_bank_ldy #FAMILIAR_BANK
  jsr familiar_calculate_screen_coordinates

  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)

:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq entity_not_alive

  ;calculate screen coordinates based on the camera coordinates
  sec
  lda entity_x_lo,x
  sbc camera_x
  sta entity_screen_x_lo,x
  lda entity_x_hi,x
  sbc camera_x+1
  sta entity_screen_x_hi,x

  sec
  lda entity_y_lo,x
  sbc camera_y
  sta entity_screen_y_lo,x
  lda entity_y_hi,x
  sbc camera_y+1
  sta entity_screen_y_hi,x

  ;add camera screen origin to the screen coordinates. This is needed
  ;because the camera screen origin is not at 0,0, it is at 0,8.
  clc
  lda entity_screen_y_lo,x
  adc #CAMERA_SCREEN_ORIGIN_Y
  sta entity_screen_y_lo,x
  lda entity_screen_y_hi,x
  adc #$00
  sta entity_screen_y_hi,x

  ;only pause if pausable
  lda entity_flags,x
  and #ENTITY_FLAGS_NOT_PAUSABLE_TEST
  bne not_pausable
  jsr test_pause_rect
not_pausable:

entity_not_alive:

  dex
  bpl :-
  rts

test_pause_rect:

  ;now calculate a pause/unpause area rectangle based on the location of
  ;the camera. Test whether the entity rect is within this area rectangle.
  ;Unpause it if so, pause it if not.
  PAUSE_RECT_MARGIN = 50
  sec
  lda camera_x
  sbc #PAUSE_RECT_MARGIN
  sta w2
  lda camera_x+1
  sbc #0
  sta w2+1

  clc
  lda camera_x
  adc #<(256 + PAUSE_RECT_MARGIN)
  sta w6
  lda camera_x+1
  adc #>(256 + PAUSE_RECT_MARGIN)
  sta w6+1

  sec
  lda camera_y
  sbc #PAUSE_RECT_MARGIN
  sta w3
  lda camera_y+1
  sbc #0
  sta w3+1

  clc
  lda camera_y
  adc #<(240 + PAUSE_RECT_MARGIN)
  sta w7
  lda camera_y+1
  adc #>(240 + PAUSE_RECT_MARGIN)
  sta w7+1

  lda entity_x_lo,x
  sta w4
  lda entity_x_hi,x
  sta w4+1
  lda entity_y_lo,x
  sta w5
  lda entity_y_hi,x
  sta w5+1

  clc
  lda entity_x_lo,x
  adc entity_width,x
  sta w8
  lda entity_x_hi,x
  adc #$00
  sta w8+1

  clc
  lda entity_y_lo,x
  adc entity_height,x
  sta w9
  lda entity_y_hi,x
  adc #$00
  sta w9+1

  .scope
  jsr geotests_rect_in_rect
  bne pause
unpause:

  lda entity_flags,x
  and #ENTITY_FLAGS_PAUSED_CLEAR
  sta entity_flags,x

  jmp done
pause:

  lda entity_flags,x
  ora #ENTITY_FLAGS_PAUSED_SET
  sta entity_flags,x

done:
  .endscope

  rts

.endproc

;draws hero, familiar, and all non player entities.
;Sorts hero, familiar, and a single entity that may have been
;selected to be sorted against the hero and familiar.
;NOTE! This procedure intentionally spills into entity_draw_npe
;to provide shared functionality without duplicating code.
.proc entity_draw_all

  ;check to see if there is an entity that wants to be sorted
  ;against the player entities
  .scope
  ldx sorted_entity_index
  bmi sort_hero_and_familiar
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq sort_hero_and_familiar
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_TEST
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

.endproc

;draws all non player entities
.proc entity_draw_npe

  lda metasprite_flicker
  and #1
  bne iterate_forwards
iterate_backwards:
  .scope
  ldx #(MAX_ENTITIES-1)
next_entity:
  jsr draw_entity
  dex
  bpl next_entity
  .endscope

  rts

iterate_forwards:
  .scope
  ldx #0
next_entity:
  jsr draw_entity
  inx
  cpx #(MAX_ENTITIES)
  bne next_entity
  .endscope

  rts

draw_entity:

  ;skip the sorted entity and dead entities
  cpx sorted_entity_index
  beq skip_entity
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity

  ;test to see if it is drawable.
  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_TEST
  beq skip_entity

  ;test to see if it is paused.
  lda entity_flags,x
  and #ENTITY_FLAGS_PAUSED_TEST
  bne skip_entity

  ;the entity is drawable so proceed to calculate screen coords and draw its animation
  lda entity_animation_address_lo,x
  sta w0
  lda entity_animation_address_hi,x
  sta w0+1

  ;get screen coordinates from entity
  lda entity_screen_x_lo,x
  sta w3
  lda entity_screen_x_hi,x
  sta w3+1

  lda entity_screen_y_lo,x
  sta w4
  lda entity_screen_y_hi,x
  sta w4+1

  lda entity_sprite_group_offset,x
  sta chr_group_offset

  lda entity_sprite_flags,x
  sta b2

  lda entity_animation_frame,x
  sta b0
  lda entity_animation_address_lo,x
  sta w2
  lda entity_animation_address_hi,x
  sta w2+1

  ;switch to the bank containing the sprites and animations for this entity type
  switch_bank_ldy #ENTITIES_BANK
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

  jsr sprite_draw_animation_frame
skip_entity:
  rts

.endproc

;draws entity currently pointed to by x register
;assumes entity is alive and drawable
.proc draw_entity

  lda entity_animation_address_lo,x
  sta w0
  lda entity_animation_address_hi,x
  sta w0+1

  ;get screen coordinates from entity
  lda entity_screen_x_lo,x
  sta w3
  lda entity_screen_x_hi,x
  sta w3+1

  lda entity_screen_y_lo,x
  sta w4
  lda entity_screen_y_hi,x
  sta w4+1

  lda entity_sprite_group_offset,x
  sta chr_group_offset

  lda entity_sprite_flags,x
  sta b2

  lda entity_animation_frame,x
  sta b0
  lda entity_animation_address_lo,x
  sta w2
  lda entity_animation_address_hi,x
  sta w2+1

  ;switch to the bank containing the sprites and animations for this entity type
  switch_bank_ldy #ENTITIES_BANK
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

  jsr sprite_draw_animation_frame
  rts

.endproc

;draws all entity shadow spots for each entity, if enabled. each set of
;shadow spot coordinates are interpreted as offsets from the entity's
;screen coordinates, so this routine must be called after screen
;coordinates have been computed for each entity. It should also be
;called after entities have been drawn, so that shadow spots have the
;lowest sprite priority.
.proc entity_draw_shadow_spots

  ldx #(MAX_ENTITIES-1)

next_entity:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_flags,x
  and #ENTITY_FLAGS_SHADOW_SPOT_TEST
  beq skip_entity

  ldy next_sprite_address

  ;calculate screen coordinates based on entity screen coordinates
  clc
  lda entity_screen_x_lo,x
  adc entity_shadow_spot_x_lo,x
  sta w0
  lda entity_screen_x_hi,x
  adc entity_shadow_spot_x_hi,x
  sta w0+1
  bne cull_shadow_spot

  clc
  lda entity_screen_y_lo,x
  adc entity_shadow_spot_y_lo,x
  sta w1
  lda entity_screen_y_hi,x
  adc entity_shadow_spot_y_hi,x
  sta w1+1
  bne cull_shadow_spot

  ;draw the shadow spot
  lda w1
  sta sprite+sprite_struct::ycoord,y

  lda shadow_spot_chr_offset
  sta sprite+sprite_struct::tile,y

  lda #$00
  sta sprite+sprite_struct::attribute,y

  lda w0
  sta sprite+sprite_struct::xcoord,y

  iny
  iny
  iny
  iny

  sty next_sprite_address

cull_shadow_spot:

skip_entity:

  dex
  bpl next_entity

  jsr familiar_draw_shadow_spot

  rts

.endproc

;this routine is private to this module and sorts the
;hero, familiar, and third participant entity if available.
.proc perform_sort_entity_hero_and_familiar

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
  ldx sorted_entity_index
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
  ldx sorted_entity_index
  jsr draw_entity
  jsr hero_draw
  jsr familiar_draw
  jmp done_drawing_sorted

hero_below_entity:
  .endscope

  ;at this point, we know the entity must be between the familiar and the hero.
  ;draw them and jump out.
  jsr hero_draw
  ldx sorted_entity_index
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
  ldx sorted_entity_index
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
  ldx sorted_entity_index
  jsr draw_entity
  jsr familiar_draw
  jsr hero_draw
  jmp done_drawing_sorted

familiar_below_entity:
  .endscope

  ;at this point, we know the entity must be between the familiar and the hero.
  ;draw them and jump out.
  jsr familiar_draw
  ldx sorted_entity_index
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
;uses y
.proc entity_reset_animation
animation_rom_address = w2

  ;save calling bank
  lda current_bank
  pha

  switch_bank_ldy #ENTITIES_BANK
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

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

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc

;updates the current entity's animation
;assumes x is pointing to the current entity instance
.proc entity_update_animation
animation_rom_address = w2

  ;save calling bank
  lda current_bank
  pha

  switch_bank_ldy #ENTITIES_BANK
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

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

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts

.endproc
