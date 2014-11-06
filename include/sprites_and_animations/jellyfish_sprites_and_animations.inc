.ifndef JELLYFISH_SPRITES_AND_ANIMATIONS_INC
JELLYFISH_SPRITES_AND_ANIMATIONS_INC = 1

jellyfish0:
  .byte $08
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$06,$03,$00,$08
  .byte $08,$07,$03,$08,$00
  .byte $10,$0c,$03,$00,$08
  .byte $10,$0d,$03,$08,$00
  .byte $18,$11,$03,$00,$08
  .byte $18,$12,$03,$08,$00
jellyfish1:
  .byte $08
  .byte $00,$02,$03,$00,$08
  .byte $00,$03,$03,$08,$00
  .byte $08,$08,$03,$00,$08
  .byte $08,$09,$03,$08,$00
  .byte $10,$0e,$03,$00,$08
  .byte $10,$0e,$03,$08,$00
  .byte $18,$13,$03,$00,$08
  .byte $18,$13,$03,$08,$00
jellyfish2:
  .byte $08
  .byte $00,$04,$03,$00,$08
  .byte $00,$05,$03,$08,$00
  .byte $08,$0a,$03,$00,$08
  .byte $08,$0b,$03,$08,$00
  .byte $10,$0f,$03,$00,$08
  .byte $10,$10,$03,$08,$00
  .byte $18,$14,$03,$00,$08
  .byte $18,$15,$03,$08,$00

jellyfish:
  .byte $06, $08
  .word jellyfish0
  .word jellyfish1
  .word jellyfish2
  .word jellyfish1

.endif
