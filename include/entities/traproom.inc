.linecont +
.ifndef TRAPROOM_INC
TRAPROOM_INC = 1

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_MAIN
.endenum

.define traproom_states \
  traproom_state_init, \
  traproom_state_main

traproom_lo:
  .lobytes traproom_states

traproom_hi:
  .hibytes traproom_states

traproom_update:

  entity_state_switchboard traproom_lo, traproom_hi

traproom_state_init:

  jsr entity_clear_drawable

  lda #TRAPROOM_STATE_MAIN
  sta entity_state,x

  rts

traproom_state_main:

  rts

.endif
