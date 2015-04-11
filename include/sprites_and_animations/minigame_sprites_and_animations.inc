.ifndef MINIGAME_SPRITES_AND_ANIMATIONS_INC
MINIGAME_SPRITES_AND_ANIMATIONS_INC = 1

ship0:
  .byte $04
  .byte $00,$05,$01,$00,$08
  .byte $00,$06,$01,$08,$00
  .byte $08,$0b,$01,$00,$08
  .byte $08,$0c,$01,$08,$00
turtle0:
  .byte $04
  .byte $00,$07,$01,$00,$08
  .byte $00,$08,$01,$08,$00
  .byte $08,$0d,$01,$00,$08
  .byte $08,$0e,$01,$08,$00
owl0:
  .byte $04
  .byte $00,$01,$01,$00,$08
  .byte $00,$02,$01,$08,$00
  .byte $08,$03,$01,$00,$08
  .byte $08,$04,$01,$08,$00
kraken0:
  .byte $04
  .byte $00,$09,$01,$00,$08
  .byte $00,$0a,$01,$08,$00
  .byte $08,$0f,$01,$00,$08
  .byte $08,$10,$01,$08,$00
ring0:
  .byte $04
  .byte $00,$15,$01,$00,$08
  .byte $00,$16,$01,$08,$00
  .byte $08,$19,$01,$00,$08
  .byte $08,$1a,$01,$08,$00
bottle0:
  .byte $04
  .byte $00,$11,$01,$00,$08
  .byte $00,$12,$01,$08,$00
  .byte $08,$13,$01,$00,$08
  .byte $08,$14,$01,$08,$00
bottle_ring0:
  .byte $04
  .byte $00,$17,$01,$00,$08
  .byte $00,$18,$01,$08,$00
  .byte $08,$1b,$01,$00,$08
  .byte $08,$1c,$01,$08,$00

ship:
  .byte $0a, $02
  .word ship0
turtle:
  .byte $0a, $02
  .word turtle0
owl:
  .byte $0a, $02
  .word owl0
kraken:
  .byte $0a, $02
  .word kraken0
ring:
  .byte $0a, $02
  .word ring0
bottle:
  .byte $0a, $02
  .word bottle0
bottle_ring:
  .byte $0a, $02
  .word bottle_ring0

.endif
