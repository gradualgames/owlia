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

.macro save_calling_bank
  lda current_bank
  pha
.endmacro

.macro restore_calling_bank
  pla
  sta current_bank
  switch_bank_ldy current_bank
.endmacro

;This macro is intended to be used in the fixed bank.
;It assumes that there will be a label called "impl"
;located in another bank beneath the macro.
;
; example usage:
;
; If you want to convert:
;
;.proc hero_face_in_current_direction
;
; into a trampoline to another bank, replace it with:
;
; .segment "CODE"          ;ensures the routine will be a trampoline called from anywhere
; .proc hero_face_in_current_direction
;   trampoline #HERO_BANK  ;defines the code which saves current bank, switches to target
;                          ;bank, calls impl, then returns to calling bank and returns to
;                          ;caller.
; .segment "ROM02"         ;defines the segment that the implementation of this routine will
;                          ;reside in. Must match the "bank" parameter to trampoline.
; impl:                    ;This label will always define where the routine implementation is.
;
; This implementation was chosen instead of a more elegant macro which manipulates segments
; automatically because doing preprocessor manipulation of segments tends to make debugger
; output much more difficult to process.
;
.macro define_trampoline bank
  save_calling_bank
  switch_bank_ldy bank
  jsr impl
  restore_calling_bank
  rts
.endmacro

.endif
