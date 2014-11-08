.ifndef URCHIN_SPRITES_AND_ANIMATIONS_INC
URCHIN_SPRITES_AND_ANIMATIONS_INC = 1

urchin0:
  .byte $04
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00

urchin:
  .byte $0a, $02
  .word urchin0

.endif
