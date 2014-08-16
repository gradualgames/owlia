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
  ;lda #sprite_chr_group_index_treasure_chest
  ;sta b0
  ;jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  jsr treasure_chest_make_impassable

  lda #TREASURE_CHEST_STATE_IDLE
  sta entity_state,x

  rts

treasure_chest_state_idle:

  .scope
  jsr entity_test_hero_rect
  bne not_intersecting_hero

  far_call #HERO_BANK, hero_is_attacking
  bne do_not_open_chest

  far_call #HERO_BANK, hero_cancel_attack

  ;play a sound
  txa
  pha

  lda #<sfx_chest_open
  sta sound_param_word_0
  lda #>sfx_chest_open
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  ;play a sound
  txa
  pha

  lda #<sfx_chest_melody
  sta sound_param_word_0
  lda #>sfx_chest_melody
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_two
  far_call #SFX_BANK, stream_initialize

  pla
  tax

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

  ldy treasure_chest_item_index,x
  sec
  lda entity_y_lo,y
  sbc #<1
  sta entity_y_lo,y
  lda entity_y_hi,y
  sbc #>1
  sta entity_y_hi,y

  .scope
  dec treasure_chest_state_counter,x
  bne do_not_switch_state

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
  cmp #TREASURE_CHEST_ITEM_TYPE_GP
  beq spawn_gp

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

  txa
  pha

  lda #entity_index_item
  sta b0

  jsr entity_spawn

  ;get this entity's index into y so we can transfer variables
  ;from this to that
  txa
  tay

  pla
  tax

  tya
  sta treasure_chest_item_index,x

  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_GP
  sta item_type,y
  lda treasure_chest_item_quantity_lo,x
  sta item_quantity_lo,y
  lda treasure_chest_item_quantity_hi,x
  sta item_quantity_hi,y

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

.proc treasure_chest_make_passable

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr clear_dynamic_single_screen_collision_field_bit

  rts

.endproc

.endif
