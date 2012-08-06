.ifndef MAPPER_INC
MAPPER_INC = 1

.global bank_table

.macro switch_bank_y
  lda bank_table,y  ;read a byte from the banktable
  sta bank_table,y  ;and write it back, switching banks at $8000
.endmacro

.macro switch_bank_x
  lda bank_table,x  ;read a byte from the banktable
  sta bank_table,x  ;and write it back, switching banks at $8000
.endmacro

;uses y register to perform UnROM bankswitching using bank_table
.macro switch_bank_ldy bank
  ldy bank
  lda bank_table,y  ;read a byte from the banktable
  sta bank_table,y  ;and write it back, switching banks at $8000
.endmacro

;uses x register to perform UnROM bankswitching using bank_table
.macro switch_bank_ldx bank
  ldx bank
  lda bank_table,x  ;read a byte from the banktable
  sta bank_table,x  ;and write it back, switching banks at $8000
.endmacro
  
.endif
