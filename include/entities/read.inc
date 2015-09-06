.linecont +
.ifndef READ_INC
READ_INC = 1

.include "read_constants.inc"

define_lohi_tables read, \
 {read_state_init, \
  read_state_main}

read_update:

  entity_state_switchboard read_lo, read_hi

read_state_init:

  lda #READ_WIDTH
  sta entity_width,x
  lda #READ_HEIGHT
  sta entity_height,x

  lda #READ_STATE_MAIN
  sta entity_state,x

  rts

read_state_main:

  .scope
  ;test hero against entity's conversation rect
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

  jsr geotests_rect_in_rect_size
  bne do_not_start_conversation

  far_call #HERO_BANK, hero_is_attacking

  bne do_not_start_conversation

  lda hero_flags
  ora #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

  lda #ENTITY_DIRECTION_UP
  sta hero_direction

  ;cancel the hero's attack, overriding the default a button behavior.
  far_call #HERO_BANK, hero_cancel_attack

  ;put hero into a passive state so she cannot
  ;get input from the controller immediately upon
  ;finishing a conversation with the NPC.
  lda #3
  sta b0
  far_call #HERO_BANK, hero_wait_frames

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda read_conversation,x
  sta state_control_params+play_state_control::param

do_not_start_conversation:
  .endscope

  rts

.endif
