.linecont +
.ifndef SWITCH_INC
SWITCH_INC = 1

.include "switch_entity_constants.inc"

define_lohi_tables switch, \
 {switch_state_init, \
  switch_state_wait_until_depressed, \
  switch_state_depress, \
  switch_state_pop_up, \
  switch_state_idle}

switch_update:

  entity_state_switchboard switch_lo, switch_hi

switch_state_init:

  lda #SWITCH_WIDTH
  sta entity_width,x
  lda #SWITCH_HEIGHT
  sta entity_height,x

  clc
  lda entity_x_lo,x
  adc #<SWITCH_X_OFFSET
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SWITCH_X_OFFSET
  sta entity_x_hi,x

  clc
  lda entity_y_lo,x
  adc #<SWITCH_Y_OFFSET
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #>SWITCH_Y_OFFSET
  sta entity_y_hi,x

  lda #SWITCH_STATE_WAIT_UNTIL_DEPRESSED
  sta entity_state,x

  rts

switch_state_wait_until_depressed:

  .scope
  ;load entity rectangle
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
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
  bne not_depressed

  lda #SWITCH_STATE_DEPRESS
  sta entity_state,x

not_depressed:
  .endscope

  rts

switch_state_depress:

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

  lda #SWITCH_STATE_IDLE
  sta entity_state,x

  rts

switch_state_pop_up:

  rts

switch_state_idle:

  rts

.endif
