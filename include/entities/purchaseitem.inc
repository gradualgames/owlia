.linecont +
.ifndef PURCHASEITEM_INC
PURCHASEITEM_INC = 1

PURCHASEITEM_WIDTH = $07
PURCHASEITEM_HEIGHT = $07

purchaseitem_animation_lo = entity_local0
purchaseitem_animation_hi = entity_local1
inventory_lo = entity_local2
inventory_hi = entity_local3
purchaseitem_conversation = entity_local4
purchaseitem_price = entity_local5

.enum
PURCHASEITEM_STATE_INIT
PURCHASEITEM_STATE_PROMPT_FOR_PURCHASE
PURCHASEITEM_STATE_ADD_ITEM_OR_NOT
.endenum

.define purchaseitem_states \
  purchaseitem_state_init, \
  purchaseitem_state_prompt_for_purchase, \
  purchaseitem_state_add_item_or_not

purchaseitem_lo:
  .lobytes purchaseitem_states

purchaseitem_hi:
  .hibytes purchaseitem_states

purchaseitem_update:

  entity_state_switchboard purchaseitem_lo, purchaseitem_hi

purchaseitem_state_init:

  jsr entity_set_drawable

  lda purchaseitem_animation_lo,x
  sta entity_animation_address_lo,x
  lda purchaseitem_animation_hi,x
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #PURCHASEITEM_WIDTH
  sta entity_width,x
  lda #PURCHASEITEM_HEIGHT
  sta entity_height,x

  lda #$00
  sta entity_sprite_flags,x

  lda #PURCHASEITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

purchaseitem_state_prompt_for_purchase:

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne a_not_pressed

  ;cancel attack this frame because hero pressed a against a
  ;purchasable item!
  jsr hero_cancel_attack

  ;put hero into a passive state so she cannot
  ;get input from the controller between now and when the not-enough-gp
  ;box has been cleared.
  lda #10
  sta b0
  jsr hero_wait_frames

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda purchaseitem_conversation,x
  sta state_control_params+play_state_control::param

  ;on next frame, transition to add-item-or-not state to respond to
  ;textbox result
  lda #PURCHASEITEM_STATE_ADD_ITEM_OR_NOT
  sta entity_state,x

not_touching_hero:
a_not_pressed:
  .endscope

  rts

purchaseitem_state_add_item_or_not:

  lda textbox_result
  cmp #TEXTBOX_CONFIRM
  bne do_not_add_item

  ;if we arrive here, the user confirmed the prompt for purchasing this
  ;item.

  ;Test to see if player has enough gp
  sec
  lda inventory_gp
  sbc purchaseitem_price,x
  lda inventory_gp+1
  sbc #$00
  bmi not_enough_gp

  ;Increment the corresponding inventory slot and decrement gp by price
  lda inventory_lo,x
  sta w0
  lda inventory_hi,x
  sta w0+1

  ldy #0
  clc
  lda (w0),y
  adc #$01
  sta (w0),y
  iny
  lda (w0),y
  adc #$00
  sta (w0),y

  sec
  lda inventory_gp
  sbc purchaseitem_price,x
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

  lda #PURCHASEITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

not_enough_gp:

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_not_enough_gp
  sta state_control_params+play_state_control::param

  lda #PURCHASEITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts

.endif
