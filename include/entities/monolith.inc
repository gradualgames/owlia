.linecont +
.ifndef MONOLITH_INC
MONOLITH_INC = 1

MONOLITH_WIDTH = $0f
MONOLITH_HEIGHT = $0f

.enum
MONOLITH_STATE_INIT
MONOLITH_STATE_MAIN
.endenum

.define monolith_states \
  monolith_state_init, \
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

; ;This routine marks a bit in the dynamic single screen collision field
; ;expects w0 to contain screen x coordinate
; ;expects w1 to contain screen y coordinate
; .proc set_dynamic_single_screen_collision_field_bit

  lda #MONOLITH_STATE_MAIN
  sta entity_state,x

  rts

monolith_state_main:

  rts

.endif
