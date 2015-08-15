.ifndef BUBBLES_SPRITES_AND_ANIMATIONS_INC
BUBBLES_SPRITES_AND_ANIMATIONS_INC = 1

bubble0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$05,$01,$00,$08
  .byte $08,$06,$01,$08,$00
bubble1:
  .byte $04
  .byte $00,$03,$01,$00,$08
  .byte $00,$04,$01,$08,$00
  .byte $08,$07,$01,$00,$08
  .byte $08,$08,$01,$08,$00

bubble:
  .byte $0a, $04
  .word bubble0
  .word bubble1

.endif
