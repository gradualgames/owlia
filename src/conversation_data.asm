.linecont +
.include "textbox.inc"
.include "conversation_data.inc"

.segment "CODE"

.define conversations \
    test_conversation,\
    another_conversation

conversations_lo:
  .lobytes conversations

conversations_hi:
  .hibytes conversations

.segment "ROM00"

test_conversation:
  .byte 1, H,E,L,L,O,SP,T,H,E,R,E,EN,WT,EL
  .byte 2, I,SP,_A,M,SP,_A,SP,B,U,T,T,EN,WT,EL
  .byte 3, _Y,O,U,SP,_A,R,E,SP,_A,SP,B,U,T,T,SP,T,O,O,CA,WT,EP,EL
  .byte 1, W,E,SP,_A,R,E,SP,B,O,T,H,SP,B,U,T,T,S,PD,WT,EC

another_conversation:
  .byte 1, W,E,L,C,O,M,E,SP,T,O,SP,O,U,R,SP,G,_A,M,E,EN,WT,EC
