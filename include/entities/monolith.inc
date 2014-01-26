.linecont +
.ifndef MONOLITH_INC
MONOLITH_INC = 1

.include "monolith_constants.inc"

MONOLITH_WIDTH = $0f
MONOLITH_HEIGHT = $0f

.define monolith_states \
  monolith_state_init, \
  monolith_state_test, \
  monolith_state_main

monolith_lo:
  .lobytes monolith_states

monolith_hi:
  .hibytes monolith_states

monolith_update:

  entity_state_switchboard monolith_lo, monolith_hi

monolith_state_init:

  lda #MONOLITH_WIDTH
  sta entity_width,x
  lda #MONOLITH_HEIGHT
  sta entity_height,x

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  sec
  lda entity_y_lo,x
  sbc #<16
  sta w1
  lda entity_y_hi,x
  sbc #>16
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  sec
  lda entity_y_lo,x
  sbc #<32
  sta w1
  lda entity_y_hi,x
  sbc #>32
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda #1
  sta monolith_state_counter,x

  lda #MONOLITH_STATE_TEST
  sta entity_state,x

  rts

monolith_state_test:

  .scope
  dec monolith_state_counter,x
  bne do_not_switch_state

  ;just for testing, add a nametable patch for the bg tile patch
  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  ;patch index
  lda monolith_background_patch_index,x
  sta b0

  ;patch row
  lda #0
  sta b1

  jsr decode_nametable_patch_row

  lda #MONOLITH_STATE_MAIN
  sta entity_state,x

do_not_switch_state:
  .endscope

  rts

monolith_state_main:

  rts

.endif
