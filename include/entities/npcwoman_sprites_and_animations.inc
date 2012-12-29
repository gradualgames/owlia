.ifndef NPCWOMAN_SPRITES_AND_ANIMATIONS_INC
NPCWOMAN_SPRITES_AND_ANIMATIONS_INC = 1

NpcWomanWalkDown0:
  .byte $0a
  .byte $fc,$00,$02,$00,$08
  .byte $fc,$01,$02,$08,$00
  .byte $04,$02,$02,$00,$08
  .byte $04,$03,$02,$08,$00
  .byte $0c,$04,$02,$00,$08
  .byte $0c,$05,$02,$08,$00
  .byte $14,$06,$03,$00,$08
  .byte $14,$07,$03,$08,$00
  .byte $1c,$08,$00,$00,$08
  .byte $1c,$09,$03,$08,$00
NpcWomanWalkDown1:
  .byte $0a
  .byte $fc,$00,$02,$00,$08
  .byte $fc,$01,$02,$08,$00
  .byte $04,$02,$02,$00,$08
  .byte $04,$03,$02,$08,$00
  .byte $0c,$0a,$02,$00,$08
  .byte $0c,$0b,$02,$08,$00
  .byte $14,$0c,$03,$00,$08
  .byte $14,$0d,$03,$08,$00
  .byte $1c,$0e,$03,$00,$08
  .byte $1c,$0f,$00,$08,$00
NpcWomanWalkUp0:
  .byte $0a
  .byte $fc,$10,$02,$00,$08
  .byte $fc,$11,$02,$08,$00
  .byte $04,$12,$02,$00,$08
  .byte $04,$13,$02,$08,$00
  .byte $0c,$14,$02,$00,$08
  .byte $0c,$15,$02,$08,$00
  .byte $14,$16,$03,$00,$08
  .byte $14,$17,$03,$08,$00
  .byte $1c,$18,$03,$00,$08
  .byte $1c,$19,$03,$08,$00
NpcWomanWalkUp1:
  .byte $0a
  .byte $fc,$10,$02,$00,$08
  .byte $fc,$11,$02,$08,$00
  .byte $04,$12,$02,$00,$08
  .byte $04,$13,$02,$08,$00
  .byte $0c,$1a,$02,$00,$08
  .byte $0c,$1b,$02,$08,$00
  .byte $14,$1c,$03,$00,$08
  .byte $14,$1d,$03,$08,$00
  .byte $1c,$1e,$03,$00,$08
  .byte $1c,$1f,$03,$08,$00
NpcWomanWalkSide0:
  .byte $0a
  .byte $fc,$20,$02,$00,$08
  .byte $fc,$21,$02,$08,$00
  .byte $04,$22,$02,$00,$08
  .byte $04,$23,$02,$08,$00
  .byte $0c,$24,$02,$00,$08
  .byte $0c,$25,$02,$08,$00
  .byte $14,$26,$03,$00,$08
  .byte $14,$27,$03,$08,$00
  .byte $1c,$28,$03,$00,$08
  .byte $1c,$29,$00,$08,$00
NpcWomanWalkSide1:
  .byte $0a
  .byte $fc,$20,$02,$00,$08
  .byte $fc,$21,$02,$08,$00
  .byte $04,$22,$02,$00,$08
  .byte $04,$23,$02,$08,$00
  .byte $0c,$2a,$02,$00,$08
  .byte $0c,$2b,$02,$08,$00
  .byte $14,$2c,$03,$00,$08
  .byte $14,$2d,$03,$08,$00
  .byte $1c,$28,$03,$00,$08
  .byte $1c,$29,$00,$08,$00

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
