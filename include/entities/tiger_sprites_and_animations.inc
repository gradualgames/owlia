.ifndef TIGER_SPRITES_AND_ANIMATIONS_INC
TIGER_SPRITES_AND_ANIMATIONS_INC = 1

TigerWalkSide0:
  .byte $06
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00
  .byte $10,$04,$02,$00,$08
  .byte $10,$05,$02,$08,$00
TigerWalkSide1:
  .byte $06
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00
  .byte $10,$06,$02,$00,$08
  .byte $10,$07,$02,$08,$00
TigerWalkUp0:
  .byte $06
  .byte $00,$08,$02,$00,$08
  .byte $00,$09,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00
  .byte $10,$0c,$02,$00,$08
  .byte $10,$0d,$02,$08,$00
TigerWalkUp1:
  .byte $06
  .byte $00,$08,$02,$00,$08
  .byte $00,$09,$02,$08,$00
  .byte $08,$0e,$02,$00,$08
  .byte $08,$0f,$02,$08,$00
  .byte $10,$10,$02,$00,$08
  .byte $10,$11,$02,$08,$00
TigerWalkDown0:
  .byte $06
  .byte $00,$12,$02,$00,$08
  .byte $00,$13,$02,$08,$00
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
  .byte $10,$0c,$02,$00,$08
  .byte $10,$0d,$02,$08,$00
TigerWalkDown1:
  .byte $06
  .byte $00,$12,$02,$00,$08
  .byte $00,$13,$02,$08,$00
  .byte $08,$16,$02,$00,$08
  .byte $08,$17,$02,$08,$00
  .byte $10,$10,$02,$00,$08
  .byte $10,$11,$02,$08,$00

TigerWalkSide:
  .byte $0a,$04
  .word TigerWalkSide0
  .word TigerWalkSide1
TigerWalkUp:
  .byte $0a,$04
  .word TigerWalkUp0
  .word TigerWalkUp1
TigerWalkDown:
  .byte $0a,$04
  .word TigerWalkDown0
  .word TigerWalkDown1

.endif
