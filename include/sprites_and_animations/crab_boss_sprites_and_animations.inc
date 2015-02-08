.ifndef CRAB_BOSS_SPRITES_AND_ANIMATIONS_INC
CRAB_BOSS_SPRITES_AND_ANIMATIONS_INC = 1

crab_boss_walk0:
  .byte $1a
  .byte $00,$02,$02,$00,$30
  .byte $00,$03,$02,$08,$28
  .byte $00,$04,$02,$10,$20
  .byte $00,$05,$02,$18,$18
  .byte $00,$06,$02,$20,$10
  .byte $00,$07,$02,$28,$08
  .byte $00,$08,$02,$30,$00
  .byte $08,$09,$02,$00,$30
  .byte $08,$0a,$02,$08,$28
  .byte $08,$0b,$02,$10,$20
  .byte $08,$0c,$02,$18,$18
  .byte $08,$0d,$02,$20,$10
  .byte $08,$0e,$02,$28,$08
  .byte $08,$0f,$02,$30,$00
  .byte $10,$10,$02,$00,$30
  .byte $10,$11,$02,$08,$28
  .byte $10,$12,$02,$10,$20
  .byte $10,$13,$02,$18,$18
  .byte $10,$14,$02,$20,$10
  .byte $10,$15,$02,$28,$08
  .byte $10,$16,$02,$30,$00
  .byte $18,$17,$02,$00,$30
  .byte $18,$18,$02,$10,$20
  .byte $18,$19,$02,$18,$18
  .byte $18,$1a,$02,$20,$10
  .byte $18,$1b,$02,$30,$00
crab_boss_pincer0:
  .byte $04
  .byte $00,$1c,$02,$00,$08
  .byte $00,$1d,$02,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
crab_boss_eye0:
  .byte $01
  .byte $00,$01,$01,$00,$00

crab_boss_walk:
  .byte $0a, $02
  .word crab_boss_walk0
crab_boss_pincer:
  .byte $0a, $02
  .word crab_boss_pincer0
crab_boss_eye:
  .byte $0a, $02
  .word crab_boss_eye0

.endif
