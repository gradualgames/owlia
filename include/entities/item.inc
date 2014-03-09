.linecont +
.ifndef ITEM_INC
ITEM_INC = 1

.include "item_constants.inc"

item_sprite_chr_group_index:
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern

.define item_animation_addresses Coins, Heart, Bomb, Lantern

item_animation_addresses_lo:
  .lobytes item_animation_addresses

item_animation_addresses_hi:
  .hibytes item_animation_addresses

.define item_inventory_addresses \
  inventory_gp, inventory_healths, inventory_bombs, inventory_lanterns

item_inventory_addresses_lo:
  .lobytes item_inventory_addresses

item_inventory_addresses_hi:
  .hibytes item_inventory_addresses

.define item_inventory_max_count \
  INVENTORY_MAX_GP, \
  INVENTORY_MAX_HEALTHS, \
  INVENTORY_MAX_BOMBS, \
  INVENTORY_MAX_LANTERNS

item_inventory_max_count_lo:
  .lobytes item_inventory_max_count

item_inventory_max_count_hi:
  .hibytes item_inventory_max_count

item_inventory_var_type:
  .byte ITEM_16_BIT_VAR
  .byte ITEM_8_BIT_VAR
  .byte ITEM_8_BIT_VAR
  .byte ITEM_8_BIT_VAR

item_purchase_conversation_indices:
  .byte 0
  .byte conversation_index_purchase_health
  .byte conversation_index_purchase_bomb
  .byte conversation_index_purchase_lantern

item_random_pickup_quantities:
  .byte 100
  .byte 1
  .byte 1
  .byte 1

.define item_states \
  item_state_init, \
  item_state_prompt_for_purchase_init, \
  item_state_prompt_for_purchase, \
  item_state_add_item_or_not, \
  item_state_pickup_init, \
  item_state_pickup, \
  item_state_drop_random_item_init

item_lo:
  .lobytes item_states

item_hi:
  .hibytes item_states

item_update:

  entity_state_switchboard item_lo, item_hi

item_state_init:

  jsr entity_clear_drawable

  jsr entity_reset_animation

  lda #ITEM_WIDTH
  sta entity_width,x
  lda #ITEM_HEIGHT
  sta entity_height,x

  lda #$00
  sta entity_sprite_flags,x

  lda item_initial_state,x
  sta entity_state,x

  rts

item_state_pickup_init:

  jsr entity_set_drawable

  ldy item_type,x
  lda item_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda item_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda item_sprite_chr_group_index,y
  tay
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #ITEM_STATE_PICKUP
  sta entity_state,x

  rts

item_state_pickup:

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  jsr increment_var

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

  rts

not_touching_hero:
  .endscope

  ;test whether item is intersecting familiar and set
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
  sta familiar_carried_entity_x_offset
  lda #$10
  sta familiar_carried_entity_y_offset

  ;store the item's entity index as the entity that is to be fetched.
  stx familiar_carried_entity_index

  ;tell the familiar to return to the hero with the fetched item.
  far_call #FAMILIAR_BANK, familiar_fetch_return_to_hero

familiar_not_intersecting:
familiar_not_fetching:
  .endscope

  rts

item_state_prompt_for_purchase_init:

  jsr entity_set_drawable

  ldy item_type,x
  lda item_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda item_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda item_sprite_chr_group_index,y
  tay
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #ITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

item_state_prompt_for_purchase:

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  far_call #HERO_BANK, hero_is_attacking
  bne hero_not_attacking

  ;cancel attack this frame because hero pressed a against a
  ;purchasable item!
  far_call #HERO_BANK, hero_cancel_attack

  ;put hero into a passive state so she cannot
  ;get input from the controller between now and when the not-enough-gp
  ;box has been cleared.
  lda #10
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  ldy item_type,x
  lda item_purchase_conversation_indices,y
  sta state_control_params+play_state_control::param

  ;on next frame, transition to add-item-or-not state to respond to
  ;textbox result
  lda #ITEM_STATE_ADD_ITEM_OR_NOT
  sta entity_state,x

not_touching_hero:
hero_not_attacking:
  .endscope

  rts

item_state_add_item_or_not:

  lda textbox_result
  cmp #TEXTBOX_CONFIRM
  bne do_not_add_item

  ;if we arrive here, the user confirmed the prompt for purchasing this
  ;item.

  ;Test to see if player has enough gp
  sec
  lda inventory_gp
  sbc item_price,x
  lda inventory_gp+1
  sbc #$00
  bmi not_enough_gp

  ;Increment the corresponding inventory slot and decrement gp by price
  jsr increment_var

  sec
  lda inventory_gp
  sbc item_price,x
  sta inventory_gp
  lda inventory_gp
  sbc #$00
  sta inventory_gp

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

do_not_add_item:

  lda #ITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

not_enough_gp:

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_not_enough_gp
  sta state_control_params+play_state_control::param

  lda #ITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

item_state_drop_random_item_init:

  ;just eor a bunch of game state together to
  ;get a pseudo random number for the item type.
  ;I played around with the prng I had been using
  ;since Nomolos, but I am actually getting much
  ;better results from the following very simple
  ;code.
  .scope
  lda stream_read_address_lo
  eor hero_x
  eor hero_y
  sta b0

  clc
  lda b0
  sbc #<5
  lda #0
  sbc #>5
  bmi drop_lantern

  clc
  lda b0
  sbc #<20
  lda #0
  sbc #>20
  bmi drop_bomb

  clc
  lda b0
  sbc #<50
  lda #0
  sbc #>50
  bmi drop_heart

  clc
  lda b0
  sbc #<80
  lda #0
  sbc #>80
  bmi drop_gp

  jmp do_not_drop_item

drop_gp:
  lda #ITEM_TYPE_GP
  sta item_type,x
  jmp done
drop_heart:
  lda #ITEM_TYPE_HEALTH
  sta item_type,x
  jmp done
drop_bomb:
  lda #ITEM_TYPE_BOMB
  sta item_type,x
  jmp done
drop_lantern:
  lda #ITEM_TYPE_LANTERN
  sta item_type,x
done:
  .endscope

  ldy item_type,x
  lda item_random_pickup_quantities,y
  sta item_quantity,x

  lda #ITEM_STATE_PICKUP_INIT
  sta entity_state,x

  rts
do_not_drop_item:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
  rts

;increments the target variable by the passed-in increment value,
;which is interpreted as a signed 8 bit number, sign extended for
;16 bit target values here.
.proc increment_var

  ldy item_type,x
  lda item_inventory_addresses_lo,y
  sta w0
  lda item_inventory_addresses_hi,y
  sta w0+1

  ldy item_type,x
  lda item_inventory_var_type,y
  cmp #ITEM_8_BIT_VAR
  beq eight_bit_var
  cmp #ITEM_16_BIT_VAR
  beq sixteen_bit_var
eight_bit_var:

  ;load the current target value
  ldy #0
  lda (w0),y
  sta b0

  ;add the specified 8 bit increment
  clc
  lda b0
  adc item_quantity,x
  sta b0

  ;now find out if we've exceeded the max
  .scope
  sec
  ldy item_type,x
  lda item_inventory_max_count_lo,y
  sbc b0
  bmi exceeded_max
did_not_exceed_max:

  ;store the result in the target variable
  lda b0
  ldy #0
  sta (w0),y

  rts

exceeded_max:

  ;store the max value in the target variable
  ldy item_type,x
  lda item_inventory_max_count_lo,y
  ldy #0
  sta (w0),y

  rts
  .endscope

sixteen_bit_var:

  ;load the current target value
  ldy #0
  lda (w0),y
  sta w1
  iny
  lda (w0),y
  sta w1+1

  ;add the specified increment sign extended for 16 bit
  lda item_quantity,x
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda w1
  adc item_quantity,x
  sta w1
  lda w1+1
  adc #$00
  sta w1+1
  jmp done
sign_extend_negative:
  clc
  lda w1
  adc item_quantity,x
  sta w1
  iny
  lda w1+1
  adc #$ff
  sta w1+1
done:

  ;now find out if we've exceeded the max
  .scope
  sec
  ldy item_type,x
  lda item_inventory_max_count_lo,y
  sbc w1
  lda item_inventory_max_count_hi,y
  sbc w1+1
  bmi exceeded_max
did_not_exceed_max:

  ;store result in target variable
  ldy #0
  lda w1
  sta (w0),y
  iny
  lda w1+1
  sta (w0),y

  rts

exceeded_max:

  ;store max in target variable
  ldy item_type,x
  lda item_inventory_max_count_lo,y
  ldy #0
  sta (w0),y

  ldy item_type,x
  lda item_inventory_max_count_hi,y
  ldy #1
  sta (w0),y

  rts
  .endscope

.endproc

.endif
