.ifndef UTIL_INC
UTIL_INC = 1

.global indirect_jsr_w0
.global next_rand

.macro neg16 value

  clc
  lda value
  eor #$ff
  adc #<1
  sta value
  lda value+1
  eor #$ff
  adc #>1
  sta value+1

.endmacro

.macro move16 source, destination

  lda source
  sta destination
  lda source+1
  sta destination+1

.endmacro

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
