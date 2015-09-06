.ifndef DIGIT_SPRITES_AND_ANIMATIONS
DIGIT_SPRITES_AND_ANIMATIONS = 1

digit0:
  .byte $01
  .byte $00,$00,$01,$00,$00
digit1:
  .byte $01
  .byte $00,$01,$01,$00,$00
digit2:
  .byte $01
  .byte $00,$02,$01,$00,$00
digit3:
  .byte $01
  .byte $00,$03,$01,$00,$00
digit4:
  .byte $01
  .byte $00,$04,$01,$00,$00
digit5:
  .byte $01
  .byte $00,$05,$01,$00,$00
digit6:
  .byte $01
  .byte $00,$06,$01,$00,$00
digit7:
  .byte $01
  .byte $00,$07,$01,$00,$00
digit8:
  .byte $01
  .byte $00,$08,$01,$00,$00
digit9:
  .byte $01
  .byte $00,$09,$01,$00,$00

digit:
  .byte $01, $14
  .word digit0
  .word digit1
  .word digit2
  .word digit3
  .word digit4
  .word digit5
  .word digit6
  .word digit7
  .word digit8
  .word digit9

.endif
