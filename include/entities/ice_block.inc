.linecont +
.ifndef ICE_BLOCK_INC
ICE_BLOCK_INC = 1

ICE_BLOCK_WIDTH = $0f
ICE_BLOCK_HEIGHT = $0f

.enum
ICE_BLOCK_STATE_INIT
ICE_BLOCK_STATE_IDLE
.endenum

.define ice_block_states \
  ice_block_state_init, \
  ice_block_state_idle

ice_block_lo:
  .lobytes ice_block_states

ice_block_hi:
  .hibytes ice_block_states

ice_block_update:

  entity_state_switchboard ice_block_lo, ice_block_hi

ice_block_state_init:

  jsr entity_set_drawable

  lda #<ice_block
  sta entity_animation_address_lo,x
  lda #>ice_block
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ICE_BLOCK_WIDTH
  sta entity_width,x
  lda #ICE_BLOCK_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_ice_block
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda #ICE_BLOCK_STATE_IDLE
  sta entity_state,x

  rts

ice_block_state_idle:

  .scope
  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly
  lda entity_action_rect2_from
  cmp #ACTION_FROM_BOMB
  bne action_rect2_not_deadly
  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  lda #entity_index_ice_shards_explosion
  sta b0

  clc
  lda entity_x_lo,x
  adc #<4
  sta w0
  lda entity_x_hi,x
  adc #>4
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<4
  sta w1
  lda entity_y_hi,x
  adc #>4
  sta w1+1

  jsr entity_spawn

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr clear_dynamic_single_screen_collision_field_bit

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

action_rect2_not_deadly:
  .endscope

  rts

.endif
