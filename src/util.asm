.include "util.inc"
.include "zp.inc"

.segment "CODE"

.proc indirect_jsr_w0
  jmp (w0)
.endproc

.proc next_rand

  lda rand
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #43
noEor:
  sta rand

  rts

.endproc
