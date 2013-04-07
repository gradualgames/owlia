.ifndef BOMB_SPRITES_AND_ANIMATIONS_INC
BOMB_SPRITES_AND_ANIMATIONS_INC = 1

Bomb0:
  .byte $01
  .byte $00,$00,$01,$00,$00

Bomb:
  .byte $0a,$02
  .word Bomb0

.endif
