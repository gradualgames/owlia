.ifndef TYTO_SPRITES_AND_ANIMATIONS_INC
TYTO_SPRITES_AND_ANIMATIONS_INC = 1

TytoWake0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
TytoWake1:
  .byte $04
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$02,$01,$00,$08
  .byte $08,$03,$01,$08,$00
TytoWake2:
  .byte $04
  .byte $00,$06,$01,$00,$08
  .byte $00,$07,$01,$08,$00
  .byte $08,$08,$01,$00,$08
  .byte $08,$09,$01,$08,$00

TytoWake:
  .byte $0a,$22
  .word TytoWake0
  .word TytoWake0
  .word TytoWake0
  .word TytoWake0
  .word TytoWake0
  .word TytoWake0
  .word TytoWake1
  .word TytoWake1
  .word TytoWake0
  .word TytoWake0
  .word TytoWake1
  .word TytoWake1
  .word TytoWake0
  .word TytoWake1
  .word TytoWake0
  .word TytoWake1
  .word TytoWake2

.endif
