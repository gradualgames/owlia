.include "ppu.inc"

.segment "CODE"

;nmi routine which does nothing.
.proc ppu_vblank_nop

  rts

.endproc
