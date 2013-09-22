.ifndef PUFFERFISH_SPRITES_AND_ANIMATIONS_INC
PUFFERFISH_SPRITES_AND_ANIMATIONS_INC = 1

PufferFishPuffedDown0:
  .byte $04
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00
PufferFishPuffedDown1:
  .byte $04
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$06,$02,$00,$08
  .byte $08,$07,$02,$08,$00
PufferFishUnpuffedDown0:
  .byte $04
  .byte $00,$08,$02,$00,$08
  .byte $00,$09,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00
PufferFishUnpuffedDown1:
  .byte $04
  .byte $00,$0c,$02,$00,$08
  .byte $00,$0d,$02,$08,$00
  .byte $08,$0e,$02,$00,$08
  .byte $08,$0f,$02,$08,$00
PufferFishPuffedUp0:
  .byte $04
  .byte $00,$10,$02,$00,$08
  .byte $00,$11,$02,$08,$00
  .byte $08,$12,$02,$00,$08
  .byte $08,$13,$02,$08,$00
PufferFishPuffedUp1:
  .byte $04
  .byte $00,$14,$02,$00,$08
  .byte $00,$15,$02,$08,$00
  .byte $08,$16,$02,$00,$08
  .byte $08,$17,$02,$08,$00
PufferFishUnpuffedUp0:
  .byte $04
  .byte $00,$18,$02,$00,$08
  .byte $00,$19,$02,$08,$00
  .byte $08,$1a,$02,$00,$08
  .byte $08,$1b,$02,$08,$00
PufferFishUnpuffedUp1:
  .byte $04
  .byte $00,$1c,$02,$00,$08
  .byte $00,$1d,$02,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
PufferFishPuffedSide0:
  .byte $04
  .byte $00,$20,$02,$00,$08
  .byte $00,$21,$02,$08,$00
  .byte $08,$22,$02,$00,$08
  .byte $08,$23,$02,$08,$00
PufferFishPuffedSide1:
  .byte $04
  .byte $00,$24,$02,$00,$08
  .byte $00,$25,$02,$08,$00
  .byte $08,$26,$02,$00,$08
  .byte $08,$27,$02,$08,$00
PufferFishUnpuffedSide0:
  .byte $04
  .byte $00,$28,$02,$00,$08
  .byte $00,$29,$02,$08,$00
  .byte $08,$2a,$02,$00,$08
  .byte $08,$2b,$02,$08,$00
PufferFishUnpuffedSide1:
  .byte $04
  .byte $00,$2c,$02,$00,$08
  .byte $00,$2d,$02,$08,$00
  .byte $08,$2e,$02,$00,$08
  .byte $08,$2f,$02,$08,$00

PufferFishPuffedDown:
  .byte $0a,$04
  .word PufferFishPuffedDown0
  .word PufferFishPuffedDown1
PufferFishUnpuffedDown:
  .byte $0a,$04
  .word PufferFishUnpuffedDown0
  .word PufferFishUnpuffedDown1
PufferFishUnpuffedUp:
  .byte $0a,$04
  .word PufferFishPuffedUp0
  .word PufferFishPuffedUp1
PufferFishPuffedUp:
  .byte $0a,$04
  .word PufferFishUnpuffedUp0
  .word PufferFishUnpuffedUp1
PufferFishPuffedSide:
  .byte $0a,$04
  .word PufferFishPuffedSide0
  .word PufferFishPuffedSide1
PufferFishUnpuffedSide:
  .byte $0a,$04
  .word PufferFishUnpuffedSide0
  .word PufferFishUnpuffedSide1

.endif
