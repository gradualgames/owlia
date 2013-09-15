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

;Use this macro at the top of a large routine that needs to be moved
;out of fixed bank. Put it right beneath the .proc. The following code
;will me moved into routine_segment, and the generated code will switch
;to routine_bank before being called from the generated trampoline routine.
;Always put end_trampoline at the end of the large .proc to switch back to
;the code bank.
.macro start_trampoline routine_bank, routine_segment
  .segment "CODE"
  ;save calling bank
  lda current_bank
  pha

  switch_bank_ldy routine_bank
  jsr routine_address

  ;restore calling bank
  pla
  sta current_bank
  switch_bank_ldy current_bank

  rts
  .segment routine_segment
routine_address:

.endmacro

.macro end_trampoline
  .segment "CODE"
.endmacro

.endif
