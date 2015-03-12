.linecont +
.ifndef KEY_INC
KEY_INC = 1

.include "key_constants.inc"

.define key_states \
  key_state_init, \
  key_state_pickup, \
  key_state_passive_init, \
  key_state_passive_inserted_init, \
  key_state_passive

key_lo:
  .lobytes key_states

key_hi:
  .hibytes key_states

key_update:

  entity_state_switchboard key_lo, key_hi

key_state_init:

  .scope
  lda inventory_dungeon_flags
  and key_dungeon_flags_mask,x
  beq do_not_skip

  jsr key_kill

  rts

do_not_skip:
  .endscope

  jsr entity_set_drawable

  lda #<key
  sta entity_animation_address_lo,x
  lda #>key
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #sprite_chr_group_index_key
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #$07
  sta entity_width,x
  lda #$0f
  sta entity_height,x

  clc
  lda entity_x_lo,x
  adc #<4
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>4
  sta entity_x_hi,x

  lda key_initial_state,x
  sta entity_state,x

  rts

key_state_pickup:

  .scope
  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr inventory_can_add_key
  beq cannot_add_key
  jsr inventory_add_key
cannot_add_key:

  ;play a sound
  lda #<sfx_get_item
  sta sound_param_word_0
  lda #>sfx_get_item
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1
  far_call #SOUND_BANK, stream_initialize

  ;mark the dungeon flag associated with this key
  lda inventory_dungeon_flags
  ora key_dungeon_flags_mask,x
  sta inventory_dungeon_flags

  jsr key_kill

entity_not_hitting_hero:
  .endscope

  ;test whether key is intersecting familiar and set
  ;fetched entity index if the familiar is trying to fetch
  ;something.
  .scope
  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_FETCH
  bne familiar_not_fetching

  jsr entity_test_entity_action_rect2
  bne familiar_not_intersecting

  ;store offsets for this entity when it is being fetched by familiar
  lda #KEY_FAMILIAR_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #KEY_FAMILIAR_Y_OFFSET
  sta familiar_carried_entity_y_offset

  ;tell the familiar to return to the hero with the fetched item.
  far_call #FAMILIAR_BANK, familiar_fetch_current_item

familiar_not_intersecting:
familiar_not_fetching:
  .endscope

  jsr entity_update_animation

  rts

key_state_passive_init:

  ;store offsets for this entity
  lda #KEY_FAMILIAR_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #KEY_FAMILIAR_Y_OFFSET
  sta familiar_carried_entity_y_offset

  ;store the key's entity index
  stx familiar_carried_entity_index

  lda #KEY_STATE_PASSIVE
  sta entity_state,x

  rts

key_state_passive_inserted_init:

  lda #<key_inserted
  sta entity_animation_address_lo,x
  lda #>key_inserted
  sta entity_animation_address_hi,x

  ;store offsets for this entity
  lda #KEY_FAMILIAR_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #KEY_FAMILIAR_Y_OFFSET
  sta familiar_carried_entity_y_offset

  ;store the key's entity index
  stx familiar_carried_entity_index

  lda #KEY_STATE_PASSIVE
  sta entity_state,x
  rts

key_state_passive:

  rts

.proc key_kill

  cpx familiar_carried_entity_index
  bne not_carried_entity

  lda #$ff
  sta familiar_carried_entity_index

not_carried_entity:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endproc

.endif
