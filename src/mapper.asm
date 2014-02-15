.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"

.segment "CODE"

bank_table:
  .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f

;expects next_bank to point to the bank containing the data we want to copy
;expects far_call_source to be the address from which to copy data
;expects far_call_dest to be the address in RAM to which to copy data
;expects x to contain the number of bytes to copy
;indirectly indexes far_call_source with y and directly indexes far_call_dest with y
.proc far_copy

  save_calling_bank
  switch_bank_ldy next_bank

  ldy #0
next_byte:
  lda (far_copy_source),y
  sta far_copy_dest,y
  iny
  dex
  bne next_byte

  restore_calling_bank
  rts

.endproc

;expects next_bank and far_call_address to be filled with the correct bank
;and address for the routine to call. This can be used to call code which
;resides in one swappable PRG bank from another swappable PRG bank.
.proc far_call_impl

  save_calling_bank
  switch_bank_ldy next_bank
  jsr call_routine_impl

  ;here we save processor status from the routine call. This is
  ;often used as a return value for all sorts of routines--we must
  ;preserve it here.
  ;in order to preserve processor status from the routine call, we have to
  ;store it off to a zp variable here instead of use the stack, because
  ;we subsequently call restore_calling_bank, which must use the stack
  ;in case multiple far_calls are chained across several banks.
  php
  pla
  sta processor_status

  restore_calling_bank

  ;restore the processor status saved before restoring the calling bank. Thus
  ;we will return from the far_call with the processor status as expected
  ;from the call to far_call_address.
  lda processor_status
  pha
  plp

  rts
call_routine_impl:
  jmp (far_call_address)

.endproc
