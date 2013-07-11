.linecont +
.ifndef ITEM_INC
ITEM_INC = 1

.include "item_constants.inc"

ITEM_WIDTH = $07
ITEM_HEIGHT = $07

item_animation_lo = entity_local0
item_animation_hi = entity_local1
inventory_lo = entity_local2
inventory_hi = entity_local3
item_conversation = entity_local4
item_price = entity_local5
item_increment = entity_local6
item_max_lo = entity_local7
item_max_hi = entity_local8
item_mode = entity_local9

.enum
ITEM_STATE_INIT
ITEM_STATE_PROMPT_FOR_PURCHASE
ITEM_STATE_ADD_ITEM_OR_NOT
ITEM_STATE_PICKUP
.endenum

.define item_states \
  item_state_init, \
  item_state_prompt_for_purchase, \
  item_state_add_item_or_not, \
  item_state_pickup

item_lo:
  .lobytes item_states

item_hi:
  .hibytes item_states

item_update:

  entity_state_switchboard item_lo, item_hi

item_state_init:

  jsr entity_set_drawable

  lda item_animation_lo,x
  sta entity_animation_address_lo,x
  lda item_animation_hi,x
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ITEM_WIDTH
  sta entity_width,x
  lda #ITEM_HEIGHT
  sta entity_height,x

  lda #$00
  sta entity_sprite_flags,x

  ;decide what part of the state machine to enter with the
  ;item mode parameter
  lda item_mode,x
  and #ITEM_MODE_TEST
  cmp #ITEM_PURCHASE
  beq purchase_mode
  cmp #ITEM_PICKUP
  beq pickup_mode
purchase_mode:
  lda #ITEM_STATE_PROMPT_FOR_PURCHASE
  sta entity_state,x

  rts
pickup_mode:
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

not_touching_hero:
  .endscope

  rts

item_state_prompt_for_purchase:

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  jsr hero_is_attacking
  bne hero_not_attacking

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
  lda item_conversation,x
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

;increments the target variable by the passed-in increment value,
;which is interpreted as a signed 8 bit number, sign extended for
;16 bit target values here.
.proc increment_var

  lda inventory_lo,x
  sta w0
  lda inventory_hi,x
  sta w0+1

  lda item_mode,x
  and #ITEM_WIDTH_TEST
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
  adc item_increment,x
  sta b0

  ;now find out if we've exceeded the max
  .scope
  sec
  lda item_max_lo,x
  sbc b0
  bmi exceeded_max
did_not_exceed_max:

  ;store the result in the target variable
  lda b0
  sta (w0),y

  rts

exceeded_max:

  ;store the max value in the target variable
  lda item_max_lo,x
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
  lda item_increment,x
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda w1
  adc item_increment,x
  sta w1
  lda w1+1
  adc #$00
  sta w1+1
  jmp done
sign_extend_negative:
  clc
  lda w1
  adc item_increment,x
  sta w1
  iny
  lda w1+1
  adc #$ff
  sta w1+1
done:

  ;now find out if we've exceeded the max
  .scope
  sec
  lda item_max_lo,x
  sbc w1
  lda item_max_hi,x
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
  ldy #0
  lda item_max_lo,x
  sta (w0),y
  iny
  lda item_max_hi,x
  sta (w0),y

  rts
  .endscope

.endproc

.endif
