.ifndef ANGLERFISH_SPRITES_AND_ANIMATIONS_INC
ANGLERFISH_SPRITES_AND_ANIMATIONS_INC = 1

anglerfish_up0:
  .byte $09
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00
  .byte $08,$09,$03,$00,$10
  .byte $08,$0a,$03,$08,$08
  .byte $08,$0b,$03,$10,$00
  .byte $10,$1b,$03,$00,$10
  .byte $10,$1c,$03,$08,$08
  .byte $10,$06,$00,$10,$00
anglerfish_up1:
  .byte $09
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00
  .byte $08,$0c,$03,$00,$10
  .byte $08,$0d,$03,$08,$08
  .byte $08,$0e,$03,$10,$00
  .byte $10,$1d,$03,$00,$10
  .byte $10,$1e,$03,$08,$08
  .byte $10,$1f,$03,$10,$00
anglerfish_down0:
  .byte $09
  .byte $00,$03,$03,$00,$10
  .byte $00,$04,$03,$08,$08
  .byte $00,$05,$03,$10,$00
  .byte $08,$0f,$03,$00,$10
  .byte $08,$10,$03,$08,$08
  .byte $08,$11,$03,$10,$00
  .byte $10,$20,$00,$00,$10
  .byte $10,$21,$03,$08,$08
  .byte $10,$06,$00,$10,$00
anglerfish_down1:
  .byte $09
  .byte $00,$03,$03,$00,$10
  .byte $00,$04,$03,$08,$08
  .byte $00,$05,$03,$10,$00
  .byte $08,$12,$03,$00,$10
  .byte $08,$13,$03,$08,$08
  .byte $08,$14,$03,$10,$00
  .byte $10,$22,$03,$00,$10
  .byte $10,$23,$03,$08,$08
  .byte $10,$24,$03,$10,$00
anglerfish_side0:
  .byte $09
  .byte $00,$06,$00,$00,$10
  .byte $00,$07,$03,$08,$08
  .byte $00,$08,$03,$10,$00
  .byte $08,$15,$03,$00,$10
  .byte $08,$16,$03,$08,$08
  .byte $08,$17,$03,$10,$00
  .byte $10,$20,$00,$00,$10
  .byte $10,$25,$03,$08,$08
  .byte $10,$26,$03,$10,$00
anglerfish_side1:
  .byte $09
  .byte $00,$06,$00,$00,$10
  .byte $00,$07,$03,$08,$08
  .byte $00,$08,$03,$10,$00
  .byte $08,$18,$03,$00,$10
  .byte $08,$19,$03,$08,$08
  .byte $08,$1a,$03,$10,$00
  .byte $10,$06,$00,$00,$10
  .byte $10,$27,$03,$08,$08
  .byte $10,$28,$03,$10,$00

anglerfish_up:
  .byte $0a, $04
  .word anglerfish_up0
  .word anglerfish_up1
anglerfish_down:
  .byte $0a, $04
  .word anglerfish_down0
  .word anglerfish_down1
anglerfish_side:
  .byte $0a, $04
  .word anglerfish_side0
  .word anglerfish_side1

.endif
