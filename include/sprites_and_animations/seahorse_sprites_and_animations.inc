.ifndef SEAHORSE_SPRITES_AND_ANIMATIONS_INC
SEAHORSE_SPRITES_AND_ANIMATIONS_INC = 1

seahorse_side0:
  .byte $08
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$07,$03,$00,$08
  .byte $08,$08,$03,$08,$00
  .byte $10,$0e,$03,$00,$08
  .byte $10,$0f,$03,$08,$00
  .byte $18,$16,$03,$00,$08
  .byte $18,$17,$03,$08,$00
seahorse_side1:
  .byte $08
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$09,$03,$00,$08
  .byte $08,$08,$03,$08,$00
  .byte $10,$10,$03,$00,$08
  .byte $10,$11,$03,$08,$00
  .byte $18,$18,$03,$00,$08
  .byte $18,$19,$03,$08,$00
seahorse_up0:
  .byte $08
  .byte $00,$02,$03,$00,$08
  .byte $00,$03,$03,$08,$00
  .byte $08,$0a,$03,$00,$08
  .byte $08,$0b,$03,$08,$00
  .byte $10,$12,$03,$00,$08
  .byte $10,$13,$03,$08,$00
  .byte $18,$1a,$03,$00,$08
  .byte $18,$1b,$03,$08,$00
seahorse_down0:
  .byte $08
  .byte $00,$05,$03,$00,$08
  .byte $00,$06,$03,$08,$00
  .byte $08,$0c,$03,$00,$08
  .byte $08,$0d,$03,$08,$00
  .byte $10,$14,$03,$00,$08
  .byte $10,$15,$03,$08,$00
  .byte $18,$1c,$03,$00,$08
  .byte $18,$1d,$03,$08,$00
seahorse_up1:
  .byte $08
  .byte $00,$02,$03,$00,$08
  .byte $00,$03,$03,$08,$00
  .byte $08,$0a,$03,$00,$08
  .byte $08,$0b,$03,$08,$00
  .byte $10,$12,$03,$00,$08
  .byte $10,$13,$03,$08,$00
  .byte $18,$1a,$03,$00,$08
  .byte $18,$1b,$03,$08,$00
seahorse_down1:
  .byte $08
  .byte $00,$05,$03,$00,$08
  .byte $00,$06,$03,$08,$00
  .byte $08,$0c,$03,$00,$08
  .byte $08,$0d,$03,$08,$00
  .byte $10,$14,$03,$00,$08
  .byte $10,$15,$03,$08,$00
  .byte $18,$1c,$03,$00,$08
  .byte $18,$1d,$03,$08,$00

seahorse_side:
  .byte $0a, $04
  .word seahorse_side0
  .word seahorse_side1
seahorse_up:
  .byte $0a, $04
  .word seahorse_up0
  .word seahorse_up1
seahorse_down:
  .byte $0a, $04
  .word seahorse_down0
  .word seahorse_down1

.endif
