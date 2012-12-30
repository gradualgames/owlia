.ifndef FAMILIAR_SPRITES_AND_ANIMATIONS_INC
FAMILIAR_SPRITES_AND_ANIMATIONS_INC = 1

FamiliarFlySide0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
FamiliarFlySide1:
  .byte $04
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$06,$01,$00,$08
  .byte $08,$07,$01,$08,$00
FamiliarFlyDown0:
  .byte $04
  .byte $00,$08,$01,$00,$08
  .byte $00,$09,$01,$08,$00
  .byte $08,$0a,$01,$00,$08
  .byte $08,$0b,$01,$08,$00
FamiliarFlyDown1:
  .byte $04
  .byte $00,$0c,$01,$00,$08
  .byte $00,$0d,$01,$08,$00
  .byte $08,$0e,$01,$00,$08
  .byte $08,$0f,$01,$08,$00
FamiliarFlyUp0:
  .byte $04
  .byte $00,$10,$01,$00,$08
  .byte $00,$11,$01,$08,$00
  .byte $08,$12,$01,$00,$08
  .byte $08,$13,$01,$08,$00
FamiliarFlyUp1:
  .byte $04
  .byte $00,$14,$01,$00,$08
  .byte $00,$15,$01,$08,$00
  .byte $08,$16,$01,$00,$08
  .byte $08,$17,$01,$08,$00

FamiliarFlySide:
  .byte $0a,$04
  .word FamiliarFlySide0
  .word FamiliarFlySide1
FamiliarFlyDown:
  .byte $0a,$04
  .word FamiliarFlyDown0
  .word FamiliarFlyDown1
FamiliarFlyUp:
  .byte $0a,$04
  .word FamiliarFlyUp0
  .word FamiliarFlyUp1

.endif
