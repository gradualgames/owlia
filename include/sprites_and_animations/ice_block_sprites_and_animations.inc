.ifndef ICE_BLOCK_SPRITES_AND_ANIMATIONS_INC
ICE_BLOCK_SPRITES_AND_ANIMATIONS_INC = 1

ice_block0:
  .byte $04
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$02,$03,$00,$08
  .byte $08,$03,$03,$08,$00

ice_block:
  .byte $0a, $02
  .word ice_block0

.endif
