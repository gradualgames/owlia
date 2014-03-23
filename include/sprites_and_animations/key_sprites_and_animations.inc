.ifndef KEY_SPRITES
KEY_SPRITES = 1

Key0:
  .byte $04
  .byte $00,$00,$01,$ff,$08
  .byte $00,$01,$00,$07,$00
  .byte $08,$02,$01,$ff,$08
  .byte $08,$03,$00,$07,$00

Key1:
  .byte $02
  .byte $00,$00,$01,$ff,$08
  .byte $00,$01,$00,$07,$00

Key:
  .byte $0a,$02
  .word Key0

KeyInserted:
  .byte $0a,$02
  .word Key1

.endif
