.include "actions.inc"
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
.include "camera.inc"
.include "textbox.inc"
.include "ppu.inc"
.include "locations.inc"
.include "soundengine.inc"
.include "sfx_data.inc"

.segment "CODE"

;this routine compares this entity's rect to the
;two action rects and the hero rect and reacts
;accordingly. It forwards parameters onwards to
;entity_attacked and entity_advance_attacked_state.
;expects b0 to indicate what to reset the attacked counter to
;expects b1 to indicate what to reset the knockback counter to
;expects x to contain the index of this entity
.proc entity_combat
attacked_counter_reset = b0
knockback_counter_reset = b1
attacked_counter = entity_local19
knockback_counter = entity_local18
health = entity_local17
direction = entity_local16

  jsr entity_advance_attacked_state

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  lda entity_action_rect1_action
  cmp #ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  .scope
  lda entity_action_rect1_direction
  cmp #ENTITY_DIRECTION_NONE
  beq do_not_set_knockback_direction
  sta direction,x
do_not_set_knockback_direction:
  .endscope

  jsr entity_attacked

  rts

action_rect1_not_deadly:

  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  .scope
  lda entity_action_rect2_direction
  cmp #ENTITY_DIRECTION_NONE
  beq do_not_set_knockback_direction
  sta direction,x
do_not_set_knockback_direction:
  .endscope

  jsr entity_attacked

  far_call #FAMILIAR_BANK, familiar_hit_enemy

action_rect2_not_deadly:

  rts

.endproc

;expects b0 to indicate what to reset the attacked counter to
;expects b1 to indicate what to reset the knockback counter to
;expects x to contain the index of this entity
.proc entity_attacked
attacked_counter_reset = b0
knockback_counter_reset = b1
attacked_counter = entity_local19
knockback_counter = entity_local18
health = entity_local17
direction = entity_local16

  lda attacked_counter,x
  bne attacked_state_machine_already_running

  ;play a sound
  txa
  pha

  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  lda attacked_counter_reset
  sta attacked_counter,x

  lda knockback_counter_reset
  sta knockback_counter,x

  dec health,x
  bne entity_not_dead_yet

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  txa
  pha

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

  pla
  tax
entity_not_dead_yet:

attacked_state_machine_already_running:

  rts

.endproc

;expects x to point at this entity
.proc entity_advance_attacked_state
knockback_counter = entity_local18
attacked_counter = entity_local19

  lda knockback_counter,x
  beq knockback_state_machine_not_running

  dec knockback_counter,x

knockback_state_machine_not_running:

  lda attacked_counter,x
  beq attacked_state_machine_not_running

  dec attacked_counter,x

  lda attacked_counter,x
  and #%00000011
  sta b0

  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

attacked_state_machine_not_running:

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
  lda #HERO_DIRECTION_RIGHT
  sta b0
  jmp done
hero_to_left:
  lda #HERO_DIRECTION_LEFT
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
  lda #HERO_DIRECTION_DOWN
  sta b0
  jmp done
hero_above:
  lda #HERO_DIRECTION_UP
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

  ;exit the loop only if an entity is found which is both alive and an enemy.
  ;otherwise, the loop will end with x as $ff, meaning no live enemy was found.
  lda entity_flags,x
  and #(ENTITY_FLAGS_ALIVE_TEST|ENTITY_FLAGS_IS_ENEMY_TEST)
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
;Typically this is only used by NPCs. It can also be used by
;doors, etc. Everything else is an enemy and will hit the hero
;and cause her to knock back and flash, or, the familiar will
;be flying above everything, etc. etc. So we only use it in very
;limited and special circumstances.
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

  jsr geotests_rect_in_rect_16bit

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
;NOTE: If no entities could be spawned, this routine will return with the
;x register being $ff
.proc entity_spawn
type = b0
spawn_x = w0
spawn_y = w1

  ;first search for a dead entity
  ldx #(MAX_ENTITIES-1)

next_entity:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq found_dead_entity

  dex
  bpl next_entity

  ;didn't find any dead entities, just exit

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
  lda entity_defs_update_address_bank,y
  tay
  switch_bank_y
  jsr indirect_jsr_entity_update
:
  dex
  bpl :--

  rts

.proc indirect_jsr_entity_update
  jmp (w0)
.endproc

.endproc

;used before a textbox is displayed. Checks each entity against the textbox rect,
;and then aligns it to the nearest nametable boundary. This is to be used before
;hiding sprites that intersect with the textbox.
.proc align_entities_if_occluded_by_textbox

  switch_bank_ldy #HERO_BANK
  jsr align_hero_if_occluded_by_textbox
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

  jsr geotests_rect_in_rect_16bit
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
entity_not_alive:

  dex
  bpl :-
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
  ;iterate over all entities
  ldx #(MAX_ENTITIES-1)

  ;skip the sorted entity and dead entities
: cpx sorted_entity_index
  beq :+
  lda entity_flags,x
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
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

  jsr sprite_draw_animation_frame
:
  dex
  bpl :--

  rts

.endproc

;draws entity currently pointed to by x register
;assumes entity is alive and drawable
;this routine is private to this module and should
;not be exposed
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
  ldy entity_type,x
  lda entity_defs_sprites_and_animations_bank,y
  tay
  switch_bank_y

  jsr sprite_draw_animation_frame
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

  ;save calling bank
  lda current_bank
  pha

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
