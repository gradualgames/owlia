.ifndef FAMILIAR_SPRITES_AND_ANIMATIONS_INC
FAMILIAR_SPRITES_AND_ANIMATIONS_INC = 1

familiar_fly_side0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$0c,$01,$00,$08
  .byte $08,$0d,$01,$08,$00
familiar_fly_side1:
  .byte $04
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$0e,$01,$00,$08
  .byte $08,$0f,$01,$08,$00
familiar_fly_down0:
  .byte $04
  .byte $00,$04,$01,$00,$08
  .byte $00,$05,$01,$08,$00
  .byte $08,$10,$01,$00,$08
  .byte $08,$11,$01,$08,$00
familiar_fly_down1:
  .byte $04
  .byte $00,$06,$01,$00,$08
  .byte $00,$07,$01,$08,$00
  .byte $08,$12,$01,$00,$08
  .byte $08,$13,$01,$08,$00
familiar_fly_up0:
  .byte $04
  .byte $00,$08,$01,$00,$08
  .byte $00,$09,$01,$08,$00
  .byte $08,$14,$01,$00,$08
  .byte $08,$15,$01,$08,$00
familiar_fly_up1:
  .byte $04
  .byte $00,$0a,$01,$00,$08
  .byte $00,$0b,$01,$08,$00
  .byte $08,$16,$01,$00,$08
  .byte $08,$17,$01,$08,$00

familiar_fly_side:
  .byte $0a, $04
  .word familiar_fly_side0
  .word familiar_fly_side1
familiar_fly_down:
  .byte $0a, $04
  .word familiar_fly_down0
  .word familiar_fly_down1
familiar_fly_up:
  .byte $0a, $04
  .word familiar_fly_up0
  .word familiar_fly_up1

.endif
