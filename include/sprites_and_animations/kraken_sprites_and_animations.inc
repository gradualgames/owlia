.ifndef KRAKEN_SPRITES_AND_ANIMATIONS_INC
KRAKEN_SPRITES_AND_ANIMATIONS_INC = 1

kraken_tentacle0:
  .byte $04
  .byte $04,$16,$02,$00,$08
  .byte $04,$17,$02,$08,$00
  .byte $0c,$18,$02,$00,$08
  .byte $0c,$19,$02,$08,$00
kraken_tentacle1:
  .byte $06
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$16,$02,$00,$08
  .byte $08,$17,$02,$08,$00
  .byte $10,$18,$02,$00,$08
  .byte $10,$19,$02,$08,$00
kraken_tentacle2:
  .byte $08
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$16,$02,$00,$08
  .byte $10,$17,$02,$08,$00
  .byte $18,$18,$02,$00,$08
  .byte $18,$19,$02,$08,$00
kraken_tentacle3:
  .byte $0a
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$16,$02,$00,$08
  .byte $18,$17,$02,$08,$00
  .byte $20,$18,$02,$00,$08
  .byte $20,$19,$02,$08,$00
kraken_tentacle4:
  .byte $0c
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$05,$02,$00,$08
  .byte $18,$0a,$02,$08,$00
  .byte $20,$16,$02,$00,$08
  .byte $20,$17,$02,$08,$00
  .byte $28,$18,$02,$00,$08
  .byte $28,$19,$02,$08,$00
kraken_tentacle5:
  .byte $0e
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$05,$02,$00,$08
  .byte $18,$0a,$02,$08,$00
  .byte $20,$05,$02,$00,$08
  .byte $20,$0a,$02,$08,$00
  .byte $28,$16,$02,$00,$08
  .byte $28,$17,$02,$08,$00
  .byte $30,$18,$02,$00,$08
  .byte $30,$19,$02,$08,$00
kraken_tentacle6:
  .byte $12
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$05,$02,$00,$08
  .byte $18,$0a,$02,$08,$00
  .byte $20,$05,$02,$00,$08
  .byte $20,$0a,$02,$08,$00
  .byte $28,$0b,$02,$00,$08
  .byte $28,$0c,$02,$08,$00
  .byte $28,$0f,$02,$10,$f8
  .byte $28,$10,$02,$18,$f0
  .byte $30,$11,$02,$00,$08
  .byte $30,$12,$02,$08,$00
  .byte $30,$14,$02,$10,$f8
  .byte $30,$15,$02,$18,$f0
kraken_tentacle7:
  .byte $14
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$05,$02,$00,$08
  .byte $18,$0a,$02,$08,$00
  .byte $20,$05,$02,$00,$08
  .byte $20,$0a,$02,$08,$00
  .byte $28,$0b,$02,$00,$08
  .byte $28,$0c,$02,$08,$00
  .byte $28,$0e,$02,$10,$f8
  .byte $28,$0f,$02,$18,$f0
  .byte $28,$10,$02,$20,$e8
  .byte $30,$11,$02,$00,$08
  .byte $30,$12,$02,$08,$00
  .byte $30,$13,$02,$10,$f8
  .byte $30,$14,$02,$18,$f0
  .byte $30,$15,$02,$20,$e8
kraken_tentacle8:
  .byte $16
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$05,$02,$00,$08
  .byte $08,$06,$02,$08,$00
  .byte $10,$05,$02,$00,$08
  .byte $10,$09,$02,$08,$00
  .byte $18,$05,$02,$00,$08
  .byte $18,$0a,$02,$08,$00
  .byte $20,$05,$02,$00,$08
  .byte $20,$0a,$02,$08,$00
  .byte $28,$0b,$02,$00,$08
  .byte $28,$0c,$02,$08,$00
  .byte $28,$0e,$02,$10,$f8
  .byte $28,$0e,$02,$18,$f0
  .byte $28,$0f,$02,$20,$e8
  .byte $28,$10,$02,$28,$e0
  .byte $30,$11,$02,$00,$08
  .byte $30,$12,$02,$08,$00
  .byte $30,$13,$02,$10,$f8
  .byte $30,$13,$02,$18,$f0
  .byte $30,$14,$02,$20,$e8
  .byte $30,$15,$02,$28,$e0
kraken_eye0:
  .byte $04
  .byte $00,$03,$03,$00,$08
  .byte $00,$04,$03,$08,$00
  .byte $08,$07,$03,$00,$08
  .byte $08,$08,$03,$08,$00

kraken_tentacle_attack_bent:
  .byte $04, $22
  .word kraken_tentacle0
  .word kraken_tentacle1
  .word kraken_tentacle2
  .word kraken_tentacle3
  .word kraken_tentacle4
  .word kraken_tentacle5
  .word kraken_tentacle6
  .word kraken_tentacle7
  .word kraken_tentacle8
  .word kraken_tentacle7
  .word kraken_tentacle6
  .word kraken_tentacle5
  .word kraken_tentacle4
  .word kraken_tentacle3
  .word kraken_tentacle2
  .word kraken_tentacle1
  .word kraken_tentacle0
kraken_tentacle_attack_straight:
  .byte $03, $16
  .word kraken_tentacle0
  .word kraken_tentacle1
  .word kraken_tentacle2
  .word kraken_tentacle3
  .word kraken_tentacle4
  .word kraken_tentacle5
  .word kraken_tentacle4
  .word kraken_tentacle3
  .word kraken_tentacle2
  .word kraken_tentacle1
  .word kraken_tentacle0
kraken_eye:
  .byte $0a, $02
  .word kraken_eye0

.endif
