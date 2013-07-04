.ifndef NPCWOMAN_SPRITES_AND_ANIMATIONS_INC
NPCWOMAN_SPRITES_AND_ANIMATIONS_INC = 1

NpcWomanWalkDown0:
  .byte $0a
  .byte $fb,$00,$02,$00,$08
  .byte $fb,$01,$02,$08,$00
  .byte $03,$02,$02,$00,$08
  .byte $03,$03,$02,$08,$00
  .byte $0b,$04,$02,$00,$08
  .byte $0b,$05,$02,$08,$00
  .byte $13,$06,$03,$00,$08
  .byte $13,$07,$03,$08,$00
  .byte $1b,$08,$03,$00,$08
  .byte $1b,$09,$03,$08,$00
NpcWomanWalkDown1:
  .byte $0a
  .byte $fb,$00,$02,$00,$08
  .byte $fb,$01,$02,$08,$00
  .byte $03,$02,$02,$00,$08
  .byte $03,$03,$02,$08,$00
  .byte $0b,$0a,$02,$00,$08
  .byte $0b,$0b,$02,$08,$00
  .byte $13,$0c,$03,$00,$08
  .byte $13,$0d,$03,$08,$00
  .byte $1b,$0e,$03,$00,$08
  .byte $1b,$0f,$03,$08,$00
NpcWomanWalkUp0:
  .byte $0a
  .byte $fb,$10,$02,$00,$08
  .byte $fb,$11,$02,$08,$00
  .byte $03,$12,$02,$00,$08
  .byte $03,$13,$02,$08,$00
  .byte $0b,$14,$02,$00,$08
  .byte $0b,$15,$02,$08,$00
  .byte $13,$16,$03,$00,$08
  .byte $13,$17,$03,$08,$00
  .byte $1b,$18,$03,$00,$08
  .byte $1b,$19,$03,$08,$00
NpcWomanWalkUp1:
  .byte $0a
  .byte $fb,$10,$02,$00,$08
  .byte $fb,$11,$02,$08,$00
  .byte $03,$12,$02,$00,$08
  .byte $03,$13,$02,$08,$00
  .byte $0b,$1a,$02,$00,$08
  .byte $0b,$1b,$02,$08,$00
  .byte $13,$1c,$03,$00,$08
  .byte $13,$1d,$03,$08,$00
  .byte $1b,$1e,$03,$00,$08
  .byte $1b,$1f,$03,$08,$00
NpcWomanWalkSide0:
  .byte $0a
  .byte $fb,$00,$02,$00,$08
  .byte $fb,$20,$02,$08,$00
  .byte $03,$21,$02,$00,$08
  .byte $03,$22,$02,$08,$00
  .byte $0b,$23,$02,$00,$08
  .byte $0b,$24,$02,$08,$00
  .byte $13,$25,$03,$00,$08
  .byte $13,$26,$03,$08,$00
  .byte $1b,$27,$03,$00,$08
  .byte $1b,$28,$03,$08,$00
NpcWomanWalkSide1:
  .byte $0a
  .byte $fb,$00,$02,$00,$08
  .byte $fb,$20,$02,$08,$00
  .byte $03,$21,$02,$00,$08
  .byte $03,$22,$02,$08,$00
  .byte $0b,$29,$02,$00,$08
  .byte $0b,$2a,$02,$08,$00
  .byte $13,$2b,$03,$00,$08
  .byte $13,$2c,$03,$08,$00
  .byte $1b,$2d,$03,$00,$08
  .byte $1b,$2e,$03,$08,$00

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
