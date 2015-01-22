.ifndef HORSESHOE_CRAB_SPRITES_AND_ANIMATIONS_INC
HORSESHOE_CRAB_SPRITES_AND_ANIMATIONS_INC = 1

horseshoe_crab_side0:
  .byte $08
  .byte $00,$05,$03,$f0,$18
  .byte $00,$06,$03,$f8,$10
  .byte $00,$07,$03,$00,$08
  .byte $00,$08,$03,$08,$00
  .byte $08,$0d,$00,$f0,$18
  .byte $08,$0e,$03,$f8,$10
  .byte $08,$0f,$03,$00,$08
  .byte $08,$10,$03,$08,$00
horseshoe_crab_up0:
  .byte $08
  .byte $00,$01,$03,$00,$08
  .byte $00,$02,$03,$08,$00
  .byte $08,$09,$03,$00,$08
  .byte $08,$0a,$03,$08,$00
  .byte $10,$11,$03,$00,$08
  .byte $10,$12,$03,$08,$00
  .byte $18,$15,$03,$00,$08
  .byte $18,$16,$00,$08,$00
horseshoe_crab_down0:
  .byte $08
  .byte $f0,$03,$03,$00,$08
  .byte $f0,$04,$00,$08,$00
  .byte $f8,$0b,$03,$00,$08
  .byte $f8,$0c,$03,$08,$00
  .byte $00,$13,$03,$00,$08
  .byte $00,$14,$03,$08,$00
  .byte $08,$17,$03,$00,$08
  .byte $08,$18,$03,$08,$00

horseshoe_crab_walk_side:
  .byte $0a, $02
  .word horseshoe_crab_side0
horseshoe_crab_walk_up:
  .byte $0a, $02
  .word horseshoe_crab_up0
horseshoe_crab_walk_down:
  .byte $0a, $02
  .word horseshoe_crab_down0

.endif
