.ifndef TIGER_SPRITES_AND_ANIMATIONS_INC
TIGER_SPRITES_AND_ANIMATIONS_INC = 1

Octopus0:
  .byte $09
  .byte $00,$00,$00,$00,$10
  .byte $00,$01,$00,$08,$08
  .byte $00,$02,$00,$10,$00
  .byte $08,$03,$00,$00,$10
  .byte $08,$04,$00,$08,$08
  .byte $08,$05,$00,$10,$00
  .byte $10,$06,$00,$00,$10
  .byte $10,$07,$00,$08,$08
  .byte $10,$08,$00,$10,$00
Octopus1:
  .byte $09
  .byte $00,$09,$00,$00,$10
  .byte $00,$0a,$00,$08,$08
  .byte $00,$0b,$00,$10,$00
  .byte $08,$0c,$00,$00,$10
  .byte $08,$0d,$00,$08,$08
  .byte $08,$0e,$00,$10,$00
  .byte $10,$0f,$00,$00,$10
  .byte $10,$10,$00,$08,$08
  .byte $10,$11,$00,$10,$00

OctopusFly:
  .byte $0a,$04
  .word Octopus0
  .word Octopus1

.endif
