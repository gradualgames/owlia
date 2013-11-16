.ifndef DOOR_SPRITES_AND_ANIMATIONS_INC
DOOR_SPRITES_AND_ANIMATIONS_INC = 1

DoorFlash0:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$00,$01,$08,$00
  .byte $08,$00,$01,$00,$08
  .byte $08,$00,$01,$08,$00
  .byte $10,$00,$01,$00,$08
  .byte $10,$00,$01,$08,$00
  .byte $18,$00,$01,$00,$08
  .byte $18,$00,$01,$08,$00
DoorFlash1:
  .byte $08
  .byte $00,$01,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$01,$00,$00,$08
  .byte $08,$01,$00,$08,$00
  .byte $10,$01,$00,$00,$08
  .byte $10,$01,$00,$08,$00
  .byte $18,$01,$00,$00,$08
  .byte $18,$01,$00,$08,$00

DoorFlash:
  .byte $02,$04
  .word DoorFlash0
  .word DoorFlash1

.endif
