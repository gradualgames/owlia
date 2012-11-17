.ifndef FAMILIAR_SPRITES_AND_ANIMATIONS_INC
FAMILIAR_SPRITES_AND_ANIMATIONS_INC = 1

FamiliarFly0:
  .byte $04
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$02,$02,$00,$08
  .byte $08,$03,$02,$08,$00
FamiliarFly1:
  .byte $04
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$06,$02,$00,$08
  .byte $08,$07,$02,$08,$00
FamiliarFly2:
  .byte $04
  .byte $00,$08,$02,$00,$08
  .byte $00,$09,$02,$08,$00
  .byte $08,$0a,$02,$00,$08
  .byte $08,$0b,$02,$08,$00

FamiliarFly:
  .byte $0a,$06
  .word FamiliarFly0
  .word FamiliarFly1
  .word FamiliarFly2

.endif
