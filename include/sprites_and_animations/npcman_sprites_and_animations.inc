.ifndef NPCMAN_SPRITES_AND_ANIMATIONS_INC
NPCMAN_SPRITES_AND_ANIMATIONS_INC = 1

NpcManWalkSide0:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
  .byte $10,$04,$01,$00,$08
  .byte $10,$05,$01,$08,$00
  .byte $18,$06,$01,$00,$08
  .byte $18,$07,$01,$08,$00
NpcManWalkSide1:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$08,$01,$00,$08
  .byte $08,$03,$01,$08,$00
  .byte $10,$09,$01,$00,$08
  .byte $10,$0a,$01,$08,$00
  .byte $18,$0b,$01,$00,$08
  .byte $18,$0c,$01,$08,$00
NpcManWalkDown0:
  .byte $08
  .byte $00,$0d,$01,$00,$08
  .byte $00,$0e,$01,$08,$00
  .byte $08,$0f,$01,$00,$08
  .byte $08,$10,$01,$08,$00
  .byte $10,$11,$01,$00,$08
  .byte $10,$12,$01,$08,$00
  .byte $18,$13,$01,$00,$08
  .byte $18,$14,$01,$08,$00
NpcManWalkDown1:
  .byte $08
  .byte $00,$0d,$01,$00,$08
  .byte $00,$0e,$01,$08,$00
  .byte $08,$15,$01,$00,$08
  .byte $08,$16,$01,$08,$00
  .byte $10,$17,$01,$00,$08
  .byte $10,$18,$01,$08,$00
  .byte $18,$19,$01,$00,$08
  .byte $18,$1a,$01,$08,$00
NpcManWalkUp0:
  .byte $08
  .byte $00,$1b,$01,$00,$08
  .byte $00,$1c,$01,$08,$00
  .byte $08,$1d,$01,$00,$08
  .byte $08,$1e,$01,$08,$00
  .byte $10,$1f,$01,$00,$08
  .byte $10,$20,$01,$08,$00
  .byte $18,$21,$01,$00,$08
  .byte $18,$22,$01,$08,$00
NpcManWalkUp1:
  .byte $08
  .byte $00,$1b,$01,$00,$08
  .byte $00,$1c,$01,$08,$00
  .byte $08,$23,$01,$00,$08
  .byte $08,$24,$01,$08,$00
  .byte $10,$25,$01,$00,$08
  .byte $10,$26,$01,$08,$00
  .byte $18,$27,$01,$00,$08
  .byte $18,$28,$01,$08,$00

NpcManWalkSide:
  .byte $0a,$04
  .word NpcManWalkSide0
  .word NpcManWalkSide1
NpcManWalkDown:
  .byte $0a,$04
  .word NpcManWalkDown0
  .word NpcManWalkDown1
NpcManWalkUp:
  .byte $0a,$04
  .word NpcManWalkUp0
  .word NpcManWalkUp1

.endif
