.include "ndxdebug.h"
.include "mapper.inc"
.include "ram.inc"
.include "zp.inc"

.segment "CODE"

bank_table:
  .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
  .byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f

;expects next_bank to point to the bank containing the byte we want to load
;expects far_load_address to be the address from which we want to load data
;expects y to be the index from which to load indirectly from far_load_address
;will not preserve the x register.
.proc far_load_impl

  save_calling_bank
  switch_bank_ldx next_bank

  lda (far_load_address),y
  sta far_load_result

  restore_calling_bank_x

  rts

.endproc

;expects next_bank and far_call_address to be filled with the correct bank
;and address for the routine to call. This can be used to call code which
;resides in one swappable PRG bank from another swappable PRG bank.
;NOTE: We do not protect the y register within this routine so that the
;processor status register is what is expected from the routine that was
;called. It is the responsibility of the caller to preserve y if needed.
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

  restore_calling_bank_y

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
