.ifndef MAPPER_INC
MAPPER_INC = 1

.global bank_table
.global far_call_impl
.global far_load_impl

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

.macro save_calling_bank
  lda current_bank
  pha
.endmacro

.macro restore_calling_bank_y
  pla
  sta current_bank
  switch_bank_ldy current_bank
.endmacro

.macro restore_calling_bank_x
  pla
  sta current_bank
  switch_bank_ldx current_bank
.endmacro

.macro far_load bank, address_lo, address_hi

  lda bank
  sta next_bank
  lda address_lo
  sta far_load_address
  lda address_hi
  sta far_load_address+1
  jsr far_load_impl

.endmacro

.macro far_call bank, address
  lda bank
  sta next_bank
  lda #<address
  sta far_call_address
  lda #>address
  sta far_call_address+1
  jsr far_call_impl
.endmacro

.endif
