.ifndef TYTO_SPRITES_AND_ANIMATIONS_INC
TYTO_SPRITES_AND_ANIMATIONS_INC = 1

tyto_wake0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$06,$01,$00,$08
  .byte $08,$07,$01,$08,$00
tyto_wake1:
  .byte $04
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$06,$01,$00,$08
  .byte $08,$07,$01,$08,$00
tyto_wake2:
  .byte $04
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$08,$01,$00,$08
  .byte $08,$09,$01,$08,$00

tyto_wake:
  .byte $04, $22
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake1
  .word tyto_wake1
  .word tyto_wake0
  .word tyto_wake0
  .word tyto_wake1
  .word tyto_wake1
  .word tyto_wake0
  .word tyto_wake1
  .word tyto_wake0
  .word tyto_wake1
  .word tyto_wake2

.endif
