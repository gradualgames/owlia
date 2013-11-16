.ifndef ANGLERFISH_SPRITES_AND_ANIMATIONS_INC
ANGLERFISH_SPRITES_AND_ANIMATIONS_INC = 1

AnglerFishUp0:
  .byte $09
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00
  .byte $08,$03,$03,$00,$10
  .byte $08,$04,$03,$08,$08
  .byte $08,$05,$03,$10,$00
  .byte $10,$06,$03,$00,$10
  .byte $10,$07,$03,$08,$08
  .byte $10,$08,$00,$10,$00
AnglerFishUp1:
  .byte $09
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00
  .byte $08,$09,$03,$00,$10
  .byte $08,$0a,$03,$08,$08
  .byte $08,$0b,$03,$10,$00
  .byte $10,$0c,$03,$00,$10
  .byte $10,$0d,$03,$08,$08
  .byte $10,$0e,$03,$10,$00
AnglerFishDown0:
  .byte $09
  .byte $00,$0f,$03,$00,$10
  .byte $00,$10,$03,$08,$08
  .byte $00,$11,$03,$10,$00
  .byte $08,$12,$03,$00,$10
  .byte $08,$13,$03,$08,$08
  .byte $08,$14,$03,$10,$00
  .byte $10,$15,$00,$00,$10
  .byte $10,$16,$03,$08,$08
  .byte $10,$08,$00,$10,$00
AnglerFishDown1:
  .byte $09
  .byte $00,$0f,$03,$00,$10
  .byte $00,$10,$03,$08,$08
  .byte $00,$11,$03,$10,$00
  .byte $08,$17,$03,$00,$10
  .byte $08,$18,$03,$08,$08
  .byte $08,$19,$03,$10,$00
  .byte $10,$1a,$03,$00,$10
  .byte $10,$1b,$03,$08,$08
  .byte $10,$1c,$03,$10,$00
AnglerFishSide0:
  .byte $09
  .byte $00,$08,$00,$00,$10
  .byte $00,$1d,$03,$08,$08
  .byte $00,$1e,$03,$10,$00
  .byte $08,$1f,$03,$00,$10
  .byte $08,$20,$03,$08,$08
  .byte $08,$21,$03,$10,$00
  .byte $10,$15,$00,$00,$10
  .byte $10,$22,$03,$08,$08
  .byte $10,$23,$03,$10,$00
AnglerFishSide2:
  .byte $09
  .byte $00,$08,$00,$00,$10
  .byte $00,$1d,$03,$08,$08
  .byte $00,$1e,$03,$10,$00
  .byte $08,$24,$03,$00,$10
  .byte $08,$25,$03,$08,$08
  .byte $08,$26,$03,$10,$00
  .byte $10,$08,$00,$00,$10
  .byte $10,$27,$03,$08,$08
  .byte $10,$28,$03,$10,$00

AnglerFishUp:
  .byte $0a,$04
  .word AnglerFishUp0
  .word AnglerFishUp1
AnglerFishDown:
  .byte $0a,$04
  .word AnglerFishDown0
  .word AnglerFishDown1
AnglerFishSide:
  .byte $0a,$04
  .word AnglerFishSide0
  .word AnglerFishSide2

.endif
