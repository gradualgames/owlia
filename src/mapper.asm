.include "mapper.inc"
.include "ram.inc"

.segment "CODE"

bank_table:
  .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f

;bankswitches using UnROM.
;mapper_bank_next - the bank to switch to
.proc mapper_switch_bank
  txa
  pha

  ldx mapper_bank_next
  lda bank_table,x        ;read a byte from the banktable
  sta bank_table,x        ;and write it back, switching banks at $8000
  sta mapper_bank_current        ;store off the current bank

  pla
  tax
  rts
.endproc
