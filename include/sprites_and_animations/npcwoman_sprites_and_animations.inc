.ifndef NPCWOMAN_SPRITES_AND_ANIMATIONS_INC
NPCWOMAN_SPRITES_AND_ANIMATIONS_INC = 1

npcwoman_walk_down0:
  .byte $0a
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$06,$02,$00,$08
  .byte $08,$07,$02,$08,$00
  .byte $10,$12,$02,$00,$08
  .byte $10,$13,$02,$08,$00
  .byte $10,$1e,$03,$00,$08
  .byte $10,$1f,$03,$08,$00
  .byte $18,$2a,$03,$00,$08
  .byte $18,$2b,$03,$08,$00
npcwoman_walk_down1:
  .byte $0a
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$08,$02,$00,$08
  .byte $08,$09,$02,$08,$00
  .byte $10,$14,$02,$00,$08
  .byte $10,$15,$02,$08,$00
  .byte $10,$20,$03,$00,$08
  .byte $10,$21,$03,$08,$00
  .byte $18,$2c,$03,$00,$08
  .byte $18,$2d,$03,$08,$00
npcwoman_walk_up0:
  .byte $0a
  .byte $00,$02,$02,$00,$08
  .byte $00,$03,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00
  .byte $10,$16,$02,$00,$08
  .byte $10,$17,$02,$08,$00
  .byte $10,$22,$03,$00,$08
  .byte $10,$23,$03,$08,$00
  .byte $18,$2e,$03,$00,$08
  .byte $18,$2f,$03,$08,$00
npcwoman_walk_up1:
  .byte $0a
  .byte $00,$02,$02,$00,$08
  .byte $00,$03,$02,$08,$00
  .byte $08,$0c,$02,$00,$08
  .byte $08,$0d,$02,$08,$00
  .byte $10,$18,$02,$00,$08
  .byte $10,$19,$02,$08,$00
  .byte $10,$24,$03,$00,$08
  .byte $10,$25,$03,$08,$00
  .byte $18,$30,$03,$00,$08
  .byte $18,$31,$03,$08,$00
npcwoman_walk_side0:
  .byte $0a
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$0e,$02,$00,$08
  .byte $08,$0f,$02,$08,$00
  .byte $10,$1a,$02,$00,$08
  .byte $10,$1b,$02,$08,$00
  .byte $10,$26,$03,$00,$08
  .byte $10,$27,$03,$08,$00
  .byte $18,$32,$03,$00,$08
  .byte $18,$33,$03,$08,$00
npcwoman_walk_side1:
  .byte $0a
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$10,$02,$00,$08
  .byte $08,$11,$02,$08,$00
  .byte $10,$1c,$02,$00,$08
  .byte $10,$1d,$02,$08,$00
  .byte $10,$28,$03,$00,$08
  .byte $10,$29,$03,$08,$00
  .byte $18,$34,$03,$00,$08
  .byte $18,$35,$03,$08,$00

npcwoman_walk_down:
  .byte $0a, $04
  .word npcwoman_walk_down0
  .word npcwoman_walk_down1
npcwoman_walk_up:
  .byte $0a, $04
  .word npcwoman_walk_up0
  .word npcwoman_walk_up1
npcwoman_walk_side:
  .byte $0a, $04
  .word npcwoman_walk_side0
  .word npcwoman_walk_side1

.endif
