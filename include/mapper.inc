.ifndef MAPPER_INC
MAPPER_INC = 1

.global bank_table

;uses y register to perform UnROM bankswitching using bank_table
.macro switch_bank_yreg bank
  ldy bank
  lda bank_table,y  ;read a byte from the banktable
  sta bank_table,y  ;and write it back, switching banks at $8000
.endmacro

;uses x register to perform UnROM bankswitching using bank_table
.macro switch_bank_xreg bank
  ldx bank
  lda bank_table,x  ;read a byte from the banktable
  sta bank_table,x  ;and write it back, switching banks at $8000
.endmacro
  
.endif
