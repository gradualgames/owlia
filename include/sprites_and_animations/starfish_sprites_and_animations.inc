.ifndef STARFISH_SPRITES_AND_ANIMATIONS_INC
STARFISH_SPRITES_AND_ANIMATIONS_INC = 1

starfish0:
  .byte $06
  .byte $00,$00,$02,$00,$10
  .byte $00,$01,$02,$08,$08
  .byte $00,$02,$02,$10,$00
  .byte $08,$06,$02,$00,$10
  .byte $08,$07,$02,$08,$08
  .byte $08,$08,$02,$10,$00
starfish1:
  .byte $06
  .byte $00,$03,$02,$00,$10
  .byte $00,$04,$02,$08,$08
  .byte $00,$05,$02,$10,$00
  .byte $08,$09,$02,$00,$10
  .byte $08,$0a,$02,$08,$08
  .byte $08,$0b,$02,$10,$00

starfish:
  .byte $0a, $04
  .word starfish0
  .word starfish1

.endif
