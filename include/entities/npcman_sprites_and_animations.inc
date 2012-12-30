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
  .byte $18,$87,$01,$08,$00
NpcManWalkSide1:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$07,$01,$00,$08
  .byte $08,$03,$01,$08,$00
  .byte $10,$08,$01,$00,$08
  .byte $10,$09,$01,$08,$00
  .byte $18,$8b,$01,$00,$08
  .byte $18,$8c,$01,$08,$00
NpcManWalkDown0:
  .byte $08
  .byte $00,$0a,$01,$00,$08
  .byte $00,$0b,$01,$08,$00
  .byte $08,$0c,$01,$00,$08
  .byte $08,$0d,$01,$08,$00
  .byte $10,$0e,$01,$00,$08
  .byte $10,$0f,$01,$08,$00
  .byte $18,$10,$01,$00,$08
  .byte $18,$11,$01,$08,$00
NpcManWalkDown1:
  .byte $08
  .byte $00,$0a,$01,$00,$08
  .byte $00,$0b,$01,$08,$00
  .byte $08,$12,$01,$00,$08
  .byte $08,$13,$01,$08,$00
  .byte $10,$14,$01,$00,$08
  .byte $10,$15,$01,$08,$00
  .byte $18,$16,$01,$00,$08
  .byte $18,$17,$01,$08,$00
NpcManWalkUp0:
  .byte $08
  .byte $00,$18,$01,$00,$08
  .byte $00,$19,$01,$08,$00
  .byte $08,$1a,$01,$00,$08
  .byte $08,$1b,$01,$08,$00
  .byte $10,$1c,$01,$00,$08
  .byte $10,$1d,$01,$08,$00
  .byte $18,$1e,$01,$00,$08
  .byte $18,$1f,$01,$08,$00
NpcManWalkUp1:
  .byte $08
  .byte $00,$18,$01,$00,$08
  .byte $00,$19,$01,$08,$00
  .byte $08,$20,$01,$00,$08
  .byte $08,$21,$01,$08,$00
  .byte $10,$22,$01,$00,$08
  .byte $10,$23,$01,$08,$00
  .byte $18,$24,$01,$00,$08
  .byte $18,$25,$01,$08,$00

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
