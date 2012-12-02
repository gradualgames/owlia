.ifndef NPCMAN_SPRITES_AND_ANIMATIONS_INC
NPCMAN_SPRITES_AND_ANIMATIONS_INC = 1

NpcManWalkSide0:
  .byte $06
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$02,$03,$00,$08
  .byte $08,$03,$03,$08,$00
  .byte $10,$04,$03,$00,$08
  .byte $10,$05,$03,$08,$00
NpcManWalkSide1:
  .byte $06
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$06,$03,$00,$08
  .byte $08,$07,$03,$08,$00
  .byte $10,$08,$03,$00,$08
  .byte $10,$09,$03,$08,$00
NpcManWalkDown0:
  .byte $06
  .byte $00,$0a,$03,$00,$08
  .byte $00,$0b,$03,$08,$00
  .byte $08,$0c,$03,$00,$08
  .byte $08,$0d,$03,$08,$00
  .byte $10,$0e,$03,$00,$08
  .byte $10,$0f,$03,$08,$00
NpcManWalkDown1:
  .byte $06
  .byte $00,$0a,$03,$00,$08
  .byte $00,$0b,$03,$08,$00
  .byte $08,$10,$03,$00,$08
  .byte $08,$11,$03,$08,$00
  .byte $10,$12,$03,$00,$08
  .byte $10,$13,$03,$08,$00
NpcManWalkUp0:
  .byte $06
  .byte $00,$14,$03,$00,$08
  .byte $00,$15,$03,$08,$00
  .byte $08,$16,$03,$00,$08
  .byte $08,$17,$03,$08,$00
  .byte $10,$12,$03,$00,$08
  .byte $10,$13,$03,$08,$00
NpcManWalkUp1:
  .byte $06
  .byte $00,$14,$03,$00,$08
  .byte $00,$15,$03,$08,$00
  .byte $08,$18,$03,$00,$08
  .byte $08,$19,$03,$08,$00
  .byte $10,$0e,$03,$00,$08
  .byte $10,$0f,$03,$08,$00

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
