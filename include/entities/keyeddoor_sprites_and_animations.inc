.ifndef KEYEDDOOR_SPRITES_AND_ANIMATIONS_INC
KEYEDDOOR_SPRITES_AND_ANIMATIONS_INC = 1

KeyedDoor0:
  .byte $08
  .byte $00,$00,$00,$00,$08
  .byte $08,$01,$00,$00,$08
  .byte $10,$02,$00,$00,$08
  .byte $18,$03,$00,$00,$08
  .byte $00,$00,$40,$08,$08
  .byte $08,$01,$40,$08,$08
  .byte $10,$02,$40,$08,$08
  .byte $18,$03,$40,$08,$08

KeyedDoor:
  .byte $0a,$02
  .word KeyedDoor0

.endif
