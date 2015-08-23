.ifndef FORTRESS_SPRITES_AND_ANIMATIONS_INC
FORTRESS_SPRITES_AND_ANIMATIONS_INC = 1

tortoise_fortress0:
  .byte $22
  .byte $00,$09,$00,$10,$28
  .byte $00,$0a,$00,$18,$20
  .byte $00,$0b,$00,$20,$18
  .byte $00,$0c,$00,$28,$10
  .byte $08,$0f,$00,$08,$30
  .byte $08,$10,$00,$10,$28
  .byte $08,$11,$00,$18,$20
  .byte $08,$12,$00,$20,$18
  .byte $08,$13,$00,$28,$10
  .byte $08,$14,$00,$30,$08
  .byte $10,$15,$00,$00,$38
  .byte $10,$16,$00,$08,$30
  .byte $10,$17,$00,$10,$28
  .byte $10,$18,$00,$18,$20
  .byte $10,$19,$00,$20,$18
  .byte $10,$1a,$00,$28,$10
  .byte $10,$1b,$00,$30,$08
  .byte $10,$1c,$00,$38,$00
  .byte $18,$1d,$00,$00,$38
  .byte $18,$1e,$00,$08,$30
  .byte $18,$1f,$00,$10,$28
  .byte $18,$20,$00,$18,$20
  .byte $18,$21,$00,$20,$18
  .byte $18,$22,$00,$28,$10
  .byte $18,$23,$00,$30,$08
  .byte $18,$24,$00,$38,$00
  .byte $20,$25,$00,$00,$38
  .byte $20,$26,$00,$08,$30
  .byte $20,$27,$00,$10,$28
  .byte $20,$28,$00,$18,$20
  .byte $20,$29,$00,$20,$18
  .byte $20,$2a,$00,$28,$10
  .byte $20,$2b,$00,$30,$08
  .byte $20,$2c,$00,$38,$00
silmaran_carry_adlanniel0:
  .byte $06
  .byte $08,$03,$01,$00,$08
  .byte $08,$04,$01,$08,$00
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
silmaran_carry_adlanniel1:
  .byte $06
  .byte $08,$03,$01,$00,$08
  .byte $08,$04,$01,$08,$00
  .byte $00,$07,$02,$00,$08
  .byte $00,$08,$02,$08,$00
  .byte $08,$0d,$02,$00,$08
  .byte $08,$0e,$02,$08,$00
fortress:
  .byte $0a, $02
  .word tortoise_fortress0
silmaran_carry_adlanniel:
  .byte $0a, $04
  .word silmaran_carry_adlanniel0
  .word silmaran_carry_adlanniel1

.endif

