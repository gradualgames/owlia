.linecont +
.ifndef SWITCH_INC
SWITCH_INC = 1

.include "switch_constants.inc"

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

  entity_move16 entity_x, switch_x
  entity_move16 entity_y, switch_y

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
  ;load switch rectangle
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

  jsr switch_draw_down

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

  jsr switch_draw_up

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

switch_state_idle:

  rts

.proc switch_draw_up

  ;select bg patch
  lda switch_down_patch_index,x
  sta b0

  ;select fg patch
  lda switch_up_patch_index,x
  sta b1

  ;select column
  lda #0
  sta b2

  ;select row
  lda #0
  sta b3

  lda switch_x_lo,x
  sta w0
  lda switch_x_hi,x
  sta w0+1

  lda switch_y_lo,x
  sta w1
  lda switch_y_hi,x
  sta w1+1

  far_call #AREAS_BANK, patch_decode_foreground_revealing_background

  ;select bg patch
  lda switch_down_patch_index,x
  sta b0

  ;select fg patch
  lda switch_up_patch_index,x
  sta b1

  ;select column
  lda #1
  sta b2

  ;select row
  lda #0
  sta b3

  clc
  lda switch_x_lo,x
  adc #<8
  sta w0
  lda switch_x_hi,x
  adc #>8
  sta w0+1

  lda switch_y_lo,x
  sta w1
  lda switch_y_hi,x
  sta w1+1

  far_call #AREAS_BANK, patch_decode_foreground_revealing_background

  rts

.endproc

.proc switch_draw_down

  ;select bg patch
  lda switch_down_patch_index,x
  sta b0

  ;select fg patch
  lda switch_up_patch_index,x
  sta b1

  ;select column
  lda #0
  sta b2

  ;select row
  lda #2
  sta b3

  lda switch_x_lo,x
  sta w0
  lda switch_x_hi,x
  sta w0+1

  lda switch_y_lo,x
  sta w1
  lda switch_y_hi,x
  sta w1+1

  far_call #AREAS_BANK, patch_decode_foreground_revealing_background

  ;select bg patch
  lda switch_down_patch_index,x
  sta b0

  ;select fg patch
  lda switch_up_patch_index,x
  sta b1

  ;select column
  lda #1
  sta b2

  ;select row
  lda #2
  sta b3

  clc
  lda switch_x_lo,x
  adc #<8
  sta w0
  lda switch_x_hi,x
  adc #>8
  sta w0+1

  lda switch_y_lo,x
  sta w1
  lda switch_y_hi,x
  sta w1+1

  far_call #AREAS_BANK, patch_decode_foreground_revealing_background

  rts

.endproc

.endif
