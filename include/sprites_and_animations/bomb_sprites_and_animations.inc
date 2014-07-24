.ifndef BOMB_SPRITES_AND_ANIMATIONS_INC
BOMB_SPRITES_AND_ANIMATIONS_INC = 1

bomb0:
  .byte $01
  .byte $00,$00,$01,$00,$00
bomb1:
  .byte $01
  .byte $00,$00,$00,$00,$00

bomb:
  .byte $0a,$04
  .word bomb0
  .word bomb1

.endif
