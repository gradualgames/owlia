.ifndef NPCWOMAN_SPRITES_AND_ANIMATIONS_INC
NPCWOMAN_SPRITES_AND_ANIMATIONS_INC = 1

NpcWomanWalkDown0:
  .byte $0a
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00
  .byte $10,$04,$02,$00,$08
  .byte $10,$05,$02,$08,$00
  .byte $10,$06,$03,$00,$08
  .byte $10,$07,$03,$08,$00
  .byte $18,$08,$03,$00,$08
  .byte $18,$09,$03,$08,$00
NpcWomanWalkDown1:
  .byte $0a
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00
  .byte $10,$0c,$02,$00,$08
  .byte $10,$0d,$02,$08,$00
  .byte $10,$0e,$03,$00,$08
  .byte $10,$0f,$03,$08,$00
  .byte $18,$10,$03,$00,$08
  .byte $18,$11,$03,$08,$00
NpcWomanWalkUp0:
  .byte $0a
  .byte $00,$12,$02,$00,$08
  .byte $00,$13,$02,$08,$00
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
  .byte $10,$16,$02,$00,$08
  .byte $10,$17,$02,$08,$00
  .byte $10,$18,$03,$00,$08
  .byte $10,$19,$03,$08,$00
  .byte $18,$1a,$03,$00,$08
  .byte $18,$1b,$03,$08,$00
NpcWomanWalkUp1:
  .byte $0a
  .byte $00,$12,$02,$00,$08
  .byte $00,$13,$02,$08,$00
  .byte $08,$1c,$02,$00,$08
  .byte $08,$1d,$02,$08,$00
  .byte $10,$1e,$02,$00,$08
  .byte $10,$1f,$02,$08,$00
  .byte $10,$20,$03,$00,$08
  .byte $10,$21,$03,$08,$00
  .byte $18,$22,$03,$00,$08
  .byte $18,$23,$03,$08,$00
NpcWomanWalkSide0:
  .byte $0a
  .byte $00,$24,$02,$00,$08
  .byte $00,$25,$02,$08,$00
  .byte $08,$26,$02,$00,$08
  .byte $08,$27,$02,$08,$00
  .byte $10,$28,$02,$00,$08
  .byte $10,$29,$02,$08,$00
  .byte $10,$2a,$03,$00,$08
  .byte $10,$2b,$03,$08,$00
  .byte $18,$2c,$03,$00,$08
  .byte $18,$2d,$03,$08,$00
NpcWomanWalkSide1:
  .byte $0a
  .byte $00,$24,$02,$00,$08
  .byte $00,$25,$02,$08,$00
  .byte $08,$2e,$02,$00,$08
  .byte $08,$2f,$02,$08,$00
  .byte $10,$30,$02,$00,$08
  .byte $10,$31,$02,$08,$00
  .byte $10,$32,$03,$00,$08
  .byte $10,$33,$03,$08,$00
  .byte $18,$34,$03,$00,$08
  .byte $18,$35,$03,$08,$00

NpcWomanWalkDown:
  .byte $0a,$04
  .word NpcWomanWalkDown0
  .word NpcWomanWalkDown1
NpcWomanWalkUp:
  .byte $0a,$04
  .word NpcWomanWalkUp0
  .word NpcWomanWalkUp1
NpcWomanWalkSide:
  .byte $0a,$04
  .word NpcWomanWalkSide0
  .word NpcWomanWalkSide1

.endif
