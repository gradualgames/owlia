.ifndef KEY_SPRITES
KEY_SPRITES = 1

Key0:
  .byte $02
  .byte $00,$00,$01,$00,$00
  .byte $08,$01,$01,$00,$00

Key1:
  .byte $01
  .byte $00,$00,$01,$00,$00

Key:
  .byte $0a,$02
  .word Key0

KeyInserted:
  .byte $0a,$02
  .word Key1

.endif
