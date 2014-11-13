.ifndef ICE_SHARDS_EXPLOSION_SPRITES_AND_ANIMATIONS_INC
ICE_SHARDS_EXPLOSION_SPRITES_AND_ANIMATIONS_INC = 1

SPREAD = 5

shards0:
  .byte $04
  .byte SPREAD,$00,$03,SPREAD,$00
  .byte -SPREAD,$02,$03,-SPREAD,$00
  .byte -SPREAD,$00,$03,SPREAD,$00
  .byte SPREAD,$02,$03,-SPREAD,$00

shards1:
  .byte $04
  .byte SPREAD*2,$00,$03,SPREAD*2,$00
  .byte -SPREAD*2,$02,$03,-SPREAD*2,$00
  .byte -SPREAD*2,$00,$03,SPREAD*2,$00
  .byte SPREAD*2,$02,$03,-SPREAD*2,$00

shards2:
  .byte $04
  .byte SPREAD*3,$00,$03,SPREAD*3,$00
  .byte -SPREAD*3,$02,$03,-SPREAD*3,$00
  .byte -SPREAD*3,$00,$03,SPREAD*3,$00
  .byte SPREAD*3,$02,$03,-SPREAD*3,$00

shards3:
  .byte $04
  .byte 0,$00,$03,SPREAD,$00
  .byte 0,$02,$03,-SPREAD,$00
  .byte 0,$00,$03,SPREAD,$00
  .byte 0,$02,$03,-SPREAD,$00

shards4:
  .byte $04
  .byte 0,$00,$03,SPREAD*2,$00
  .byte 0,$02,$03,-SPREAD*2,$00
  .byte 0,$00,$03,SPREAD*2,$00
  .byte 0,$02,$03,-SPREAD*2,$00

shards5:
  .byte $04
  .byte 0,$00,$03,SPREAD*3,$00
  .byte 0,$02,$03,-SPREAD*3,$00
  .byte 0,$00,$03,SPREAD*3,$00
  .byte 0,$02,$03,-SPREAD*3,$00

shards6:
  .byte $04
  .byte SPREAD,$00,$03,0,$00
  .byte -SPREAD,$02,$03,0,$00
  .byte -SPREAD,$00,$03,0,$00
  .byte SPREAD,$02,$03,0,$00

shards7:
  .byte $04
  .byte SPREAD*2,$00,$03,0,$00
  .byte -SPREAD*2,$02,$03,0,$00
  .byte -SPREAD*2,$00,$03,0,$00
  .byte SPREAD*2,$02,$03,0,$00

shards8:
  .byte $04
  .byte SPREAD*3,$00,$03,0,$00
  .byte -SPREAD*3,$02,$03,0,$00
  .byte -SPREAD*3,$00,$03,0,$00
  .byte SPREAD*3,$02,$03,0,$00

shards:
  .byte 1, $12
  .word shards0
  .word shards4
  .word shards8

  .word shards3
  .word shards1
  .word shards5

  .word shards6
  .word shards7
  .word shards2

.endif
