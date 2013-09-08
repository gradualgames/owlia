.ifndef BOMB_SPRITES_AND_ANIMATIONS_INC
BOMB_SPRITES_AND_ANIMATIONS_INC = 1

Bomb0:
  .byte $01
  .byte $00,$00,$01,$00,$00
Bomb1:
  .byte $01
  .byte $00,$00,$00,$00,$00

Bomb:
  .byte $0a,$04
  .word Bomb0
  .word Bomb1

.endif
