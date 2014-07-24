.ifndef KEY_SPRITES
KEY_SPRITES = 1

key0:
  .byte $04
  .byte $00,$00,$01,$ff,$08
  .byte $00,$01,$00,$07,$00
  .byte $08,$02,$01,$ff,$08
  .byte $08,$03,$00,$07,$00

key1:
  .byte $02
  .byte $00,$00,$01,$ff,$08
  .byte $00,$01,$00,$07,$00

key:
  .byte $0a,$02
  .word key0

key_inserted:
  .byte $0a,$02
  .word key1

.endif
