.ifndef CRATE_SPRITES_AND_ANIMATIONS_INC
CRATE_SPRITES_AND_ANIMATIONS_INC = 1

crate0:
  .byte $10
  .byte $00,$00,$03,$00,$18
  .byte $00,$01,$03,$08,$10
  .byte $00,$01,$03,$10,$08
  .byte $00,$02,$03,$18,$00
  .byte $08,$03,$03,$00,$18
  .byte $08,$04,$03,$08,$10
  .byte $08,$05,$03,$10,$08
  .byte $08,$06,$03,$18,$00
  .byte $10,$07,$03,$00,$18
  .byte $10,$08,$03,$08,$10
  .byte $10,$09,$03,$10,$08
  .byte $10,$0a,$03,$18,$00
  .byte $18,$0b,$03,$00,$18
  .byte $18,$0c,$03,$08,$10
  .byte $18,$0d,$03,$10,$08
  .byte $18,$0e,$03,$18,$00

crate:
  .byte $0a, $02
  .word crate0

.endif
