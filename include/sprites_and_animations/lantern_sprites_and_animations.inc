.ifndef LANTERN_SPRITES_AND_ANIMATIONS_INC
LANTERN_SPRITES_AND_ANIMATIONS_INC = 1

lantern0:
  .byte $01
  .byte $00,$00,$00,$00,$00

lantern:
  .byte $0a,$02
  .word lantern0

.endif
