.linecont +
.ifndef KEY_INC
KEY_INC = 1

.enum
KEY_STATE_INIT
KEY_STATE_MAIN
.endenum

.define key_states \
  key_state_init, \
  key_state_main

key_lo:
  .lobytes key_states

key_hi:
  .hibytes key_states

key_update:

  entity_state_switchboard key_lo, key_hi

key_state_init:

  jsr entity_set_drawable_unsorted

  lda #<Key
  sta entity_animation_address_lo,x
  lda #>Key
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy #sprite_chr_group_index_key
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #$07
  sta entity_width,x
  lda #$0f
  sta entity_height,x

  lda #KEY_STATE_MAIN
  sta entity_state,x

  rts

key_state_main:

  .scope
  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr inventory_can_add_key
  beq cannot_add_key
  jsr inventory_add_key

  ;play a sound
  txa
  pha

  lda #<sfx_get_item
  sta sound_param_word_0
  lda #>sfx_get_item
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

cannot_add_key:
entity_not_hitting_hero:
  .endscope

  ;test whether key is intersecting familiar and set
  ;fetched entity index if the familiar is trying to fetch
  ;something.
  .scope
  lda entity_action_rect2_action
  cmp #ACTION_FETCH
  bne familiar_not_fetching

  jsr entity_test_entity_action_rect2
  bne familiar_not_intersecting

  ;store offsets for this entity when it is being fetched by familiar
  lda #$04
  sta familiar_param_fetched_entity_x_offset
  lda #$10
  sta familiar_param_fetched_entity_y_offset

  ;store the key's entity index as the entity that is to be fetched.
  stx familiar_param_fetched_entity_index

  ;tell the familiar to return to the hero with the fetched item.
  jsr familiar_fetch_return_to_hero

familiar_not_intersecting:
familiar_not_fetching:
  .endscope

  jsr entity_update_animation

  rts

.endif
