.ifndef UTIL_INC
UTIL_INC = 1

.global indirect_jsr_w0
.global next_rand

.macro shift_left16 variable, amount

  lda variable+1
  .repeat amount
  asl variable
  rol
  .endrepeat
  sta variable+1

.endmacro

.macro shift_right16 variable, amount

  lda variable
  .repeat amount
  lsr variable+1
  ror
  .endrepeat
  sta variable

.endmacro

.endif
