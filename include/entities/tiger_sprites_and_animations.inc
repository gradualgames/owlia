.ifndef TIGER_SPRITES_AND_ANIMATIONS_INC
TIGER_SPRITES_AND_ANIMATIONS_INC = 1

TigerWalkSide0:
  .byte $06
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
  .byte $10,$04,$01,$00,$08
  .byte $10,$05,$01,$08,$00
TigerWalkSide1:
  .byte $06
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
  .byte $10,$06,$01,$00,$08
  .byte $10,$07,$01,$08,$00
TigerWalkUp0:
  .byte $06
  .byte $00,$08,$01,$00,$08
  .byte $00,$09,$01,$08,$00
  .byte $08,$0a,$01,$00,$08
  .byte $08,$0b,$01,$08,$00
  .byte $10,$0c,$01,$00,$08
  .byte $10,$0d,$01,$08,$00
TigerWalkUp1:
  .byte $06
  .byte $00,$08,$01,$00,$08
  .byte $00,$09,$01,$08,$00
  .byte $08,$0e,$01,$00,$08
  .byte $08,$0f,$01,$08,$00
  .byte $10,$10,$01,$00,$08
  .byte $10,$11,$01,$08,$00
TigerWalkDown0:
  .byte $06
  .byte $00,$12,$01,$00,$08
  .byte $00,$13,$01,$08,$00
  .byte $08,$14,$01,$00,$08
  .byte $08,$15,$01,$08,$00
  .byte $10,$0c,$01,$00,$08
  .byte $10,$0d,$01,$08,$00
TigerWalkDown1:
  .byte $06
  .byte $00,$12,$01,$00,$08
  .byte $00,$13,$01,$08,$00
  .byte $08,$16,$01,$00,$08
  .byte $08,$17,$01,$08,$00
  .byte $10,$10,$01,$00,$08
  .byte $10,$11,$01,$08,$00

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
