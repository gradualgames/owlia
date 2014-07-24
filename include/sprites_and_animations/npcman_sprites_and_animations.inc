.ifndef NPCMAN_SPRITES_AND_ANIMATIONS_INC
NPCMAN_SPRITES_AND_ANIMATIONS_INC = 1

npcman_walk_side0:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$06,$01,$00,$08
  .byte $08,$07,$01,$08,$00
  .byte $10,$11,$01,$00,$08
  .byte $10,$12,$01,$08,$00
  .byte $18,$1d,$01,$00,$08
  .byte $18,$1e,$01,$08,$00
npcman_walk_side1:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$08,$01,$00,$08
  .byte $08,$07,$01,$08,$00
  .byte $10,$13,$01,$00,$08
  .byte $10,$14,$01,$08,$00
  .byte $18,$1f,$01,$00,$08
  .byte $18,$20,$01,$08,$00
npcman_walk_down0:
  .byte $08
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$09,$01,$00,$08
  .byte $08,$0a,$01,$08,$00
  .byte $10,$15,$01,$00,$08
  .byte $10,$16,$01,$08,$00
  .byte $18,$21,$01,$00,$08
  .byte $18,$22,$01,$08,$00
npcman_walk_down1:
  .byte $08
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$0b,$01,$00,$08
  .byte $08,$0c,$01,$08,$00
  .byte $10,$17,$01,$00,$08
  .byte $10,$18,$01,$08,$00
  .byte $18,$23,$01,$00,$08
  .byte $18,$24,$01,$08,$00
npcman_walk_up0:
  .byte $08
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$0d,$01,$00,$08
  .byte $08,$0e,$01,$08,$00
  .byte $10,$19,$01,$00,$08
  .byte $10,$1a,$01,$08,$00
  .byte $18,$25,$01,$00,$08
  .byte $18,$26,$01,$08,$00
npcman_walk_up1:
  .byte $08
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$0f,$01,$00,$08
  .byte $08,$10,$01,$08,$00
  .byte $10,$1b,$01,$00,$08
  .byte $10,$1c,$01,$08,$00
  .byte $18,$27,$01,$00,$08
  .byte $18,$28,$01,$08,$00

npcman_walk_side:
  .byte $0a, $04
  .word npcman_walk_side0
  .word npcman_walk_side1
npcman_walk_down:
  .byte $0a, $04
  .word npcman_walk_down0
  .word npcman_walk_down1
npcman_walk_up:
  .byte $0a, $04
  .word npcman_walk_up0
  .word npcman_walk_up1

.endif
