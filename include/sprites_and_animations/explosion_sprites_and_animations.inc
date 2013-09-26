.ifndef EXPLOSION_SPRITES_AND_ANIMATIONS_INC
EXPLOSION_SPRITES_AND_ANIMATIONS_INC = 1

explosion0:
  .byte $01
  .byte $00,$00,$00,$00,$00
explosion1:
  .byte $01
  .byte $00,$01,$00,$00,$00
explosion2:
  .byte $01
  .byte $00,$02,$00,$00,$00

Explosion:
  .byte $02,$06
  .word explosion0
  .word explosion1
  .word explosion2

.endif
