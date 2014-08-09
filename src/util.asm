.include "util.inc"
.include "zp.inc"

.segment "CODE"

.proc indirect_jsr_w0
  jmp (w0)
.endproc
