.ifndef TIGER_SPRITES_AND_ANIMATIONS_INC
TIGER_SPRITES_AND_ANIMATIONS_INC = 1

octopus0:
  .byte $09
  .byte $00,$00,$00,$00,$10
  .byte $00,$01,$00,$08,$08
  .byte $00,$02,$00,$10,$00
  .byte $08,$06,$00,$00,$10
  .byte $08,$07,$00,$08,$08
  .byte $08,$08,$00,$10,$00
  .byte $10,$0c,$00,$00,$10
  .byte $10,$0d,$00,$08,$08
  .byte $10,$0e,$00,$10,$00
octopus1:
  .byte $09
  .byte $00,$03,$00,$00,$10
  .byte $00,$04,$00,$08,$08
  .byte $00,$05,$00,$10,$00
  .byte $08,$09,$00,$00,$10
  .byte $08,$0a,$00,$08,$08
  .byte $08,$0b,$00,$10,$00
  .byte $10,$0f,$00,$00,$10
  .byte $10,$10,$00,$08,$08
  .byte $10,$11,$00,$10,$00

octopus_fly:
  .byte $0a, $04
  .word octopus0
  .word octopus1

.endif
