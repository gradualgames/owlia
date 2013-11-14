.ifndef DOOR_SPRITES_AND_ANIMATIONS_INC
DOOR_SPRITES_AND_ANIMATIONS_INC = 1

DoorFlash0:
  .byte $08
  .byte $02,$00,$01,$02,$08
  .byte $02,$00,$01,$0a,$00
  .byte $0a,$00,$01,$02,$08
  .byte $0a,$00,$01,$0a,$00
  .byte $12,$00,$01,$02,$08
  .byte $12,$00,$01,$0a,$00
  .byte $1a,$00,$01,$02,$08
  .byte $1a,$00,$01,$0a,$00
DoorFlash1:
  .byte $08
  .byte $02,$01,$00,$02,$08
  .byte $02,$01,$00,$0a,$00
  .byte $0a,$01,$00,$02,$08
  .byte $0a,$01,$00,$0a,$00
  .byte $12,$01,$00,$02,$08
  .byte $12,$01,$00,$0a,$00
  .byte $1a,$01,$00,$02,$08
  .byte $1a,$01,$00,$0a,$00

DoorFlash:
  .byte $02,$04
  .word DoorFlash0
  .word DoorFlash1

.endif
