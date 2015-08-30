.linecont +
.ifndef TREASURE_CHEST_INC
TREASURE_CHEST_INC = 1

.include "treasure_chest_constants.inc"

.define treasure_chest_states \
  treasure_chest_state_init, \
  treasure_chest_state_idle, \
  treasure_chest_state_opening, \
  treasure_chest_state_opened

treasure_chest_lo:
  .lobytes treasure_chest_states

treasure_chest_hi:
  .hibytes treasure_chest_states

treasure_chest_update:

  entity_state_switchboard treasure_chest_lo, treasure_chest_hi

treasure_chest_state_init:

  .scope
  lda inventory_dungeon_flags
  and treasure_chest_dungeon_flags_mask,x
  beq do_not_skip_treasure_chest

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

do_not_skip_treasure_chest:
  .endscope

  jsr entity_set_drawable

  lda #<treasure_chest
  sta entity_animation_address_lo,x
  lda #>treasure_chest
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TREASURE_CHEST_WIDTH
  sta entity_width,x
  lda #TREASURE_CHEST_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_treasure_chest
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda treasure_chest_mode,x
  cmp #TREASURE_CHEST_MODE_OVERWORLD
  beq :+
  jsr treasure_chest_make_impassable
:

  lda #$00
  sta treasure_chest_state_counter,x

  lda #TREASURE_CHEST_STATE_IDLE
  sta entity_state,x

  rts

treasure_chest_state_idle:

  .scope
  ;load entity rectangle
  sec
  lda entity_x_lo,x
  sbc #<TREASURE_CHEST_RECT_PADDING
  sta w2
  lda entity_x_hi,x
  sbc #>TREASURE_CHEST_RECT_PADDING
  sta w2+1

  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1

  clc
  lda entity_x_lo,x
  adc entity_width,x
  sta w6
  lda entity_x_hi,x
  adc #0
  sta w6+1

  clc
  lda w6
  adc #<TREASURE_CHEST_RECT_PADDING
  sta w6
  lda w6+1
  adc #>TREASURE_CHEST_RECT_PADDING
  sta w6+1

  clc
  lda entity_y_lo,x
  adc entity_height,x
  sta w7
  lda entity_y_hi,x
  adc #0
  sta w7+1

  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1

  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1

  clc
  lda hero_x
  adc hero_width
  sta w8
  lda hero_x+1
  adc #0
  sta w8+1

  clc
  lda hero_y
  adc hero_height
  sta w9
  lda hero_y+1
  adc #0
  sta w9+1

  jsr geotests_rect_inside_rect
  bne not_intersecting_hero

  far_call #HERO_BANK, hero_is_attacking
  bne do_not_open_chest

  far_call #HERO_BANK, hero_cancel_attack

  lda #TREASURE_CHEST_HERO_WAIT_FRAMES
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  lda #ENTITY_DIRECTION_UP
  sta hero_direction

  far_call #HERO_BANK, hero_face_in_current_direction

  ;play a sound
  lda #<sfx_chest_open
  sta sound_param_word_0
  lda #>sfx_chest_open
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_two
  sta sound_param_byte_1
  far_call #SOUND_BANK, stream_initialize

  lda #2
  sta entity_animation_frame,x

  jsr treasure_chest_spawn_item

  lda #TREASURE_CHEST_STATE_OPENING_LENGTH
  sta treasure_chest_state_counter,x

  lda #TREASURE_CHEST_STATE_OPENING
  sta entity_state,x

do_not_open_chest:
not_intersecting_hero:
  .endscope

  rts

treasure_chest_state_opening:

  ;float the item upwards while still alive (not yet picked up)
  .scope
  ldy treasure_chest_item_index,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq entity_not_alive
  sec
  lda entity_y_lo,y
  sbc #<1
  sta entity_y_lo,y
  lda entity_y_hi,y
  sbc #>1
  sta entity_y_hi,y
entity_not_alive:
  .endscope

  .scope
  dec treasure_chest_state_counter,x
  bne do_not_switch_state

  .scope
  lda treasure_chest_item_type,x
  cmp #TREASURE_CHEST_ITEM_TYPE_KEY
  bne not_key

  ldy treasure_chest_item_index,x
  lda #KEY_STATE_PICKUP
  sta entity_state,y

not_key:
  .endscope

  far_call #FAMILIAR_BANK, familiar_forget_carried_item
  far_call #FAMILIAR_BANK, familiar_spawn_fetch

  lda #TREASURE_CHEST_STATE_OPENED
  sta entity_state,x

do_not_switch_state:
  .endscope

  rts

treasure_chest_state_opened:

  rts

.proc treasure_chest_spawn_item

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  lda treasure_chest_item_type,x
  cmp #TREASURE_CHEST_ITEM_TYPE_KEY
  beq spawn_key
  lda treasure_chest_item_type,x
  cmp #TREASURE_CHEST_ITEM_TYPE_GP
  beq spawn_gp
  lda treasure_chest_item_type,x
  cmp #TREASURE_CHEST_ITEM_TYPE_BOMB
  beq spawn_bomb

  rts

spawn_key:

  sec
  lda w1
  sbc #<8
  sta w1
  lda w1+1
  sbc #>8
  sta w1+1

  ;spawn a key entity
  lda #entity_index_key
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta treasure_chest_item_index,x

  ;forward the puzzle done mask to the key so the key
  ;can mark the puzzle as done when picked up
  ldy spawned_entity
  lda treasure_chest_dungeon_flags_mask,x
  sta key_dungeon_flags_mask,y

  lda #KEY_STATE_PASSIVE_INIT
  sta key_initial_state,y

  rts

spawn_gp:

  clc
  lda w0
  adc #<4
  sta w0
  lda w0+1
  adc #>4
  sta w0+1

  sec
  lda w1
  sbc #<8
  sta w1
  lda w1+1
  sbc #>8
  sta w1+1

  lda #entity_index_item
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta treasure_chest_item_index,x

  ldy spawned_entity
  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_GP
  sta item_type,y
  lda treasure_chest_item_quantity_lo,x
  sta item_quantity_lo,y
  lda treasure_chest_item_quantity_hi,x
  sta item_quantity_hi,y
  lda treasure_chest_dungeon_flags_mask,x
  sta item_dungeon_flags_mask,y

  rts

spawn_bomb:

  clc
  lda w0
  adc #<4
  sta w0
  lda w0+1
  adc #>4
  sta w0+1

  sec
  lda w1
  sbc #<8
  sta w1
  lda w1+1
  sbc #>8
  sta w1+1

  lda #entity_index_item
  sta b0

  jsr entity_spawn

  lda spawned_entity
  sta treasure_chest_item_index,x

  ldy spawned_entity
  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_BOMB
  sta item_type,y
  lda treasure_chest_item_quantity_lo,x
  sta item_quantity_lo,y
  lda treasure_chest_item_quantity_hi,x
  sta item_quantity_hi,y
  lda treasure_chest_dungeon_flags_mask,x
  sta item_dungeon_flags_mask,y

  rts

.endproc

.proc treasure_chest_make_impassable

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  rts

.endproc

.endif
