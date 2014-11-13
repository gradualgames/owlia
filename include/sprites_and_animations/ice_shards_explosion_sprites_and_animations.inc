.ifndef ICE_SHARDS_EXPLOSION_SPRITES_AND_ANIMATIONS_INC
ICE_SHARDS_EXPLOSION_SPRITES_AND_ANIMATIONS_INC = 1

shards0:
  .byte $03
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00

shards:
  .byte $0a, $02
  .word shards0

.endif
