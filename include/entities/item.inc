.linecont +
.ifndef ITEM_INC
ITEM_INC = 1

.include "item_constants.inc"

item_sprite_chr_group_index:
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern

.define item_animation_addresses coins, heart, bomb, lantern

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
  .byte <INVENTORY_MAX_GP
  .byte <INVENTORY_MAX_HEALTHS
  .byte <INVENTORY_MAX_BOMBS
  .byte <INVENTORY_MAX_LANTERNS

;only GP uses hi byte
item_inventory_max_count_hi:
  .byte >INVENTORY_MAX_GP

;only GP uses hi hi byte
item_inventory_max_count_hi_hi:
  .byte ^INVENTORY_MAX_GP

item_inventory_var_type:
  .byte ITEM_24_BIT_VAR
  .byte ITEM_8_BIT_VAR
  .byte ITEM_8_BIT_VAR
  .byte ITEM_8_BIT_VAR

item_purchase_conversation_indices:
  .byte 0
  .byte conversation_index_purchase_health
  .byte conversation_index_purchase_bomb
  .byte conversation_index_purchase_lantern

item_random_pickup_quantities_lo:
  .byte 100
  .byte 1
  .byte 1
  .byte 1

item_random_pickup_quantities_hi:
  .byte 0
  .byte 0
  .byte 0
  .byte 0

.define item_increment_var_addresses \
  increment_var, \
  increment_health, \
  increment_var, \
  increment_var

item_increment_var_addresses_lo:
  .lobytes item_increment_var_addresses

item_increment_var_addresses_hi:
  .hibytes item_increment_var_addresses

.define item_states \
  item_state_init, \
  item_state_prompt_for_purchase_init, \
  item_state_prompt_for_purchase, \
  item_state_add_item_or_not, \
  item_state_pickup_init, \
  item_state_pickup, \
  item_state_pickup_and_fade_out_init, \
  item_state_pickup_and_fade_out, \
  item_state_drop_random_item_init

item_lo:
  .lobytes item_states

item_hi:
  .hibytes item_states

item_update:

  entity_state_switchboard item_lo, item_hi

item_state_init:

  .scope
  lda inventory_dungeon_flags
  and item_dungeon_flags_mask,x
  beq do_not_skip_item

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_skip_item:
  .endscope

  jsr entity_clear_drawable

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

  jsr item_common_pickup_init

  lda #ITEM_STATE_PICKUP
  sta entity_state,x

  rts

item_state_pickup:

  jsr item_test_hero_and_familiar

  rts

item_state_prompt_for_purchase_init:

  jsr entity_set_drawable

  ldy item_type,x
  lda item_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda item_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy item_type,x
  lda item_sprite_chr_group_index,y
  sta b0
  jsr entity_lookup_sprite_chr_offset

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
  sbc item_price_lo,x
  lda inventory_gp+1
  sbc item_price_hi,x
  ;only 16 bit positive prices are allowed---use 0 for hi hi byte
  lda inventory_gp+2
  sbc #$00
  bmi not_enough_gp

  ;Increment the corresponding inventory slot and decrement gp by price
  jsr increment_var

  sec
  lda inventory_gp
  sbc item_price_lo,x
  sta inventory_gp
  lda inventory_gp+1
  sbc item_price_hi,x
  sta inventory_gp+1
  lda inventory_gp+2
  sbc #$00
  sta inventory_gp+2

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

item_state_pickup_and_fade_out_init:

  jsr item_common_pickup_init

  lda #<ITEM_FADE_OUT_LENGTH
  sta item_fade_out_counter_lo,x
  lda #>ITEM_FADE_OUT_LENGTH
  sta item_fade_out_counter_hi,x

  lda #ITEM_STATE_PICKUP_AND_FADE_OUT
  sta entity_state,x

  rts

item_state_pickup_and_fade_out:

  .scope
  sec
  lda item_fade_out_counter_lo,x
  sbc #$01
  sta item_fade_out_counter_lo,x
  lda item_fade_out_counter_hi,x
  sbc #$00
  sta item_fade_out_counter_hi,x

  lda item_fade_out_counter_lo,x
  ora item_fade_out_counter_hi,x
  bne not_faded_out

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

not_faded_out:

  lda item_fade_out_counter_hi,x
  bne not_flashing_yet
  lda item_fade_out_counter_lo,x
  and #%10000000
  bne not_flashing_yet

  .scope
  lda item_fade_out_counter_lo,x
  and #%00000100
  beq do_not_draw
draw:
  jsr entity_set_drawable
  jmp done
do_not_draw:
  jsr entity_clear_drawable
done:
  .endscope

not_flashing_yet:
  .endscope

  jsr item_test_hero_and_familiar

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
  lda item_random_pickup_quantities_lo,y
  sta item_quantity_lo,x
  lda item_random_pickup_quantities_hi,y
  sta item_quantity_hi,x

  lda #ITEM_STATE_PICKUP_AND_FADE_OUT_INIT
  sta entity_state,x

  rts
do_not_drop_item:

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
  rts

.proc increment_health

  lda #HERO_MAX_HEALTH
  cmp hero_health
  beq do_not_inc_health

  inc hero_health

  rts

do_not_inc_health:

  jsr increment_var

  rts

.endproc

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
  cmp #ITEM_24_BIT_VAR
  beq twenty_four_bit_var
eight_bit_var:

  ;load the current target value
  ldy #0
  lda (w0),y
  sta b0

  ;add the specified 8 bit increment, ignoring hi byte of quantity
  clc
  lda b0
  adc item_quantity_lo,x
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

twenty_four_bit_var:

  ;load the current target value
  ldy #0
  lda (w0),y
  sta b0
  iny
  lda (w0),y
  sta b1
  iny
  lda (w0),y
  sta b2

  ;add 16 bit quantity
  clc
  lda b0
  adc item_quantity_lo,x
  sta b0
  lda b1
  adc item_quantity_hi,x
  sta b1
  ;only 16 bit unsigned quantities are allowed, assume 0 hi hi byte
  lda b2
  adc #$00
  sta b2

  ;now find out if we've exceeded the max
  .scope
  sec
  ldy item_type,x
  lda item_inventory_max_count_lo,y
  sbc b0
  lda item_inventory_max_count_hi,y
  sbc b1
  lda item_inventory_max_count_hi_hi,y
  sbc b2
  bmi exceeded_max
did_not_exceed_max:

  ;store result in target variable
  ldy #0
  lda b0
  sta (w0),y
  iny
  lda b1
  sta (w0),y
  iny
  lda b2
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

  ldy item_type,x
  lda item_inventory_max_count_hi_hi,y
  ldy #2
  sta (w0),y

  rts
  .endscope

.endproc

.proc item_common_pickup_init

  jsr entity_set_drawable

  ldy item_type,x
  lda item_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda item_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy item_type,x
  lda item_sprite_chr_group_index,y
  sta b0
  jsr entity_lookup_sprite_chr_offset

  rts

.endproc

.proc item_test_hero_and_familiar

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  lda inventory_dungeon_flags
  ora item_dungeon_flags_mask,x
  sta inventory_dungeon_flags

  ldy item_type,x
  lda item_increment_var_addresses_lo,y
  sta w0
  lda item_increment_var_addresses_hi,y
  sta w0+1
  jsr indirect_jsr_w0

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
  cmp #ENTITY_ACTION_FETCH
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

.endproc

.endif
