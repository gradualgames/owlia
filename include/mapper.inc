.ifndef MAPPER_INC
MAPPER_INC = 1

.global bank_table

.macro switch_bank_y
  sty current_bank
  lda bank_table,y
  sta bank_table,y
.endmacro

.macro switch_bank_x
  stx current_bank
  lda bank_table,x
  sta bank_table,x
.endmacro

.macro switch_bank_ldy bank
  ldy bank
  sty current_bank
  lda bank_table,y
  sta bank_table,y
.endmacro

.macro switch_bank_ldx bank
  ldx bank
  stx current_bank
  lda bank_table,x
  sta bank_table,x
.endmacro
  
.endif
