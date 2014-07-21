.ifndef PUFFERFISH_SPRITES_AND_ANIMATIONS_INC
PUFFERFISH_SPRITES_AND_ANIMATIONS_INC = 1

pufferfish_puffed_down0:
  .byte $04
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$06,$02,$00,$08
  .byte $08,$07,$02,$08,$00
pufferfish_puffed_down1:
  .byte $04
  .byte $00,$0c,$02,$00,$08
  .byte $00,$0d,$02,$08,$00
  .byte $08,$12,$02,$00,$08
  .byte $08,$13,$02,$08,$00
pufferfish_unpuffed_down0:
  .byte $04
  .byte $00,$18,$02,$00,$08
  .byte $00,$19,$02,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
pufferfish_unpuffed_down1:
  .byte $04
  .byte $00,$24,$02,$00,$08
  .byte $00,$25,$02,$08,$00
  .byte $08,$2a,$02,$00,$08
  .byte $08,$2b,$02,$08,$00
pufferfish_puffed_up0:
  .byte $04
  .byte $00,$02,$02,$00,$08
  .byte $00,$03,$02,$08,$00
  .byte $08,$08,$02,$00,$08
  .byte $08,$09,$02,$08,$00
pufferfish_puffed_up1:
  .byte $04
  .byte $00,$0e,$02,$00,$08
  .byte $00,$0f,$02,$08,$00
  .byte $08,$14,$02,$00,$08
  .byte $08,$15,$02,$08,$00
pufferfish_unpuffed_up0:
  .byte $04
  .byte $00,$1a,$02,$00,$08
  .byte $00,$1b,$02,$08,$00
  .byte $08,$20,$02,$00,$08
  .byte $08,$21,$02,$08,$00
pufferfish_unpuffed_up1:
  .byte $04
  .byte $00,$26,$02,$00,$08
  .byte $00,$27,$02,$08,$00
  .byte $08,$2c,$02,$00,$08
  .byte $08,$2d,$02,$08,$00
pufferfish_puffed_side0:
  .byte $04
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00
pufferfish_puffed_side1:
  .byte $04
  .byte $00,$10,$02,$00,$08
  .byte $00,$11,$02,$08,$00
  .byte $08,$16,$02,$00,$08
  .byte $08,$17,$02,$08,$00
pufferfish_unpuffed_side0:
  .byte $04
  .byte $00,$1c,$02,$00,$08
  .byte $00,$1d,$02,$08,$00
  .byte $08,$22,$02,$00,$08
  .byte $08,$23,$02,$08,$00
pufferfish_unpuffed_side1:
  .byte $04
  .byte $00,$28,$02,$00,$08
  .byte $00,$29,$02,$08,$00
  .byte $08,$2e,$02,$00,$08
  .byte $08,$2f,$02,$08,$00

pufferfish_puffed_down:
  .byte $0a, $04
  .word pufferfish_puffed_down0
  .word pufferfish_puffed_down1
pufferfish_unpuffed_down:
  .byte $0a, $04
  .word pufferfish_unpuffed_down0
  .word pufferfish_unpuffed_down1
pufferfish_puffed_up:
  .byte $0a, $04
  .word pufferfish_puffed_up0
  .word pufferfish_puffed_up1
pufferfish_unpuffed_up:
  .byte $0a, $04
  .word pufferfish_unpuffed_up0
  .word pufferfish_unpuffed_up1
pufferfish_puffed_side:
  .byte $0a, $04
  .word pufferfish_puffed_side0
  .word pufferfish_puffed_side1
pufferfish_unpuffed_side:
  .byte $0a, $04
  .word pufferfish_unpuffed_side0
  .word pufferfish_unpuffed_side1

.endif
