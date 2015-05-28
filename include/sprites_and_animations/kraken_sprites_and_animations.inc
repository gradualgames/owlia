.ifndef KRAKEN_SPRITES_AND_ANIMATIONS_INC
KRAKEN_SPRITES_AND_ANIMATIONS_INC = 1

kraken_tentcale0:
  .byte $04
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale1:
  .byte $06
  .byte $f8,$01,$02,$00,$08
  .byte $f8,$02,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale2:
  .byte $08
  .byte $f0,$01,$02,$00,$08
  .byte $f0,$02,$02,$08,$00
  .byte $f8,$05,$02,$00,$08
  .byte $f8,$06,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale3:
  .byte $0a
  .byte $e8,$01,$02,$00,$08
  .byte $e8,$02,$02,$08,$00
  .byte $f0,$05,$02,$00,$08
  .byte $f0,$06,$02,$08,$00
  .byte $f8,$05,$02,$00,$08
  .byte $f8,$09,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale4:
  .byte $0c
  .byte $e0,$01,$02,$00,$08
  .byte $e0,$02,$02,$08,$00
  .byte $e8,$05,$02,$00,$08
  .byte $e8,$06,$02,$08,$00
  .byte $f0,$05,$02,$00,$08
  .byte $f0,$09,$02,$08,$00
  .byte $f8,$05,$02,$00,$08
  .byte $f8,$0a,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale5:
  .byte $0e
  .byte $d8,$01,$02,$00,$08
  .byte $d8,$02,$02,$08,$00
  .byte $e0,$05,$02,$00,$08
  .byte $e0,$06,$02,$08,$00
  .byte $e8,$05,$02,$00,$08
  .byte $e8,$09,$02,$08,$00
  .byte $f0,$05,$02,$00,$08
  .byte $f0,$0a,$02,$08,$00
  .byte $f8,$05,$02,$00,$08
  .byte $f8,$0a,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$18,$02,$00,$08
  .byte $08,$19,$02,$08,$00
kraken_tentcale6:
  .byte $12
  .byte $d8,$01,$02,$f0,$18
  .byte $d8,$02,$02,$f8,$10
  .byte $e0,$05,$02,$f0,$18
  .byte $e0,$06,$02,$f8,$10
  .byte $e8,$05,$02,$f0,$18
  .byte $e8,$09,$02,$f8,$10
  .byte $f0,$05,$02,$f0,$18
  .byte $f0,$0a,$02,$f8,$10
  .byte $f8,$05,$02,$f0,$18
  .byte $f8,$0a,$02,$f8,$10
  .byte $00,$0b,$02,$f0,$18
  .byte $00,$0c,$02,$f8,$10
  .byte $00,$0f,$02,$00,$08
  .byte $00,$10,$02,$08,$00
  .byte $08,$11,$02,$f0,$18
  .byte $08,$12,$02,$f8,$10
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
kraken_tentcale7:
  .byte $14
  .byte $d8,$01,$02,$e8,$20
  .byte $d8,$02,$02,$f0,$18
  .byte $e0,$05,$02,$e8,$20
  .byte $e0,$06,$02,$f0,$18
  .byte $e8,$05,$02,$e8,$20
  .byte $e8,$09,$02,$f0,$18
  .byte $f0,$05,$02,$e8,$20
  .byte $f0,$0a,$02,$f0,$18
  .byte $f8,$05,$02,$e8,$20
  .byte $f8,$0a,$02,$f0,$18
  .byte $00,$0b,$02,$e8,$20
  .byte $00,$0c,$02,$f0,$18
  .byte $00,$0e,$02,$f8,$10
  .byte $00,$0f,$02,$00,$08
  .byte $00,$10,$02,$08,$00
  .byte $08,$11,$02,$e8,$20
  .byte $08,$12,$02,$f0,$18
  .byte $08,$13,$02,$f8,$10
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
kraken_tentcale8:
  .byte $16
  .byte $d8,$01,$02,$e0,$28
  .byte $d8,$02,$02,$e8,$20
  .byte $e0,$05,$02,$e0,$28
  .byte $e0,$06,$02,$e8,$20
  .byte $e8,$05,$02,$e0,$28
  .byte $e8,$09,$02,$e8,$20
  .byte $f0,$05,$02,$e0,$28
  .byte $f0,$0a,$02,$e8,$20
  .byte $f8,$05,$02,$e0,$28
  .byte $f8,$0a,$02,$e8,$20
  .byte $00,$0b,$02,$e0,$28
  .byte $00,$0c,$02,$e8,$20
  .byte $00,$0e,$02,$f0,$18
  .byte $00,$0e,$02,$f8,$10
  .byte $00,$0f,$02,$00,$08
  .byte $00,$10,$02,$08,$00
  .byte $08,$11,$02,$e0,$28
  .byte $08,$12,$02,$e8,$20
  .byte $08,$13,$02,$f0,$18
  .byte $08,$13,$02,$f8,$10
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
kraken_eye0:
  .byte $04
  .byte $00,$03,$03,$00,$08
  .byte $00,$04,$03,$08,$00
  .byte $08,$07,$03,$00,$08
  .byte $08,$08,$03,$08,$00

kraken_tentacle_attack_bent:
  .byte $03, $22
  .word kraken_tentcale0
  .word kraken_tentcale1
  .word kraken_tentcale2
  .word kraken_tentcale3
  .word kraken_tentcale4
  .word kraken_tentcale5
  .word kraken_tentcale6
  .word kraken_tentcale7
  .word kraken_tentcale8
  .word kraken_tentcale7
  .word kraken_tentcale6
  .word kraken_tentcale5
  .word kraken_tentcale4
  .word kraken_tentcale3
  .word kraken_tentcale2
  .word kraken_tentcale1
  .word kraken_tentcale0
kraken_tentacle_attack_straight:
  .byte $03, $16
  .word kraken_tentcale0
  .word kraken_tentcale1
  .word kraken_tentcale2
  .word kraken_tentcale3
  .word kraken_tentcale4
  .word kraken_tentcale5
  .word kraken_tentcale4
  .word kraken_tentcale3
  .word kraken_tentcale2
  .word kraken_tentcale1
  .word kraken_tentcale0
kraken_eye:
  .byte $0a, $02
  .word kraken_eye0

.endif
