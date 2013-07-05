.ifndef ROPE_SPRITES_AND_ANIMATIONS_INC
ROPE_SPRITES_AND_ANIMATIONS_INC = 1

Rope0:
  .byte $01
  .byte $00,$00,$01,$00,$00

Rope:
  .byte $0a,$02
  .word Rope0

.endif
