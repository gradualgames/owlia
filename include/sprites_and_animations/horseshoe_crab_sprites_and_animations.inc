.ifndef HORSESHOE_CRAB_SPRITES_AND_ANIMATIONS_INC
HORSESHOE_CRAB_SPRITES_AND_ANIMATIONS_INC = 1

horseshoe_crab_side0:
  .byte $08
  .byte $00,$05,$02,$f0,$18
  .byte $00,$06,$02,$f8,$10
  .byte $00,$07,$02,$00,$08
  .byte $00,$08,$02,$08,$00
  .byte $08,$0d,$00,$f0,$18
  .byte $08,$0e,$02,$f8,$10
  .byte $08,$0f,$02,$00,$08
  .byte $08,$10,$02,$08,$00
horseshoe_crab_up0:
  .byte $08
  .byte $00,$01,$02,$00,$08
  .byte $00,$02,$02,$08,$00
  .byte $08,$09,$02,$00,$08
  .byte $08,$0a,$02,$08,$00
  .byte $10,$11,$02,$00,$08
  .byte $10,$12,$02,$08,$00
  .byte $18,$15,$02,$00,$08
  .byte $18,$16,$00,$08,$00
horseshoe_crab_down0:
  .byte $08
  .byte $f0,$03,$02,$00,$08
  .byte $f0,$04,$00,$08,$00
  .byte $f8,$0b,$02,$00,$08
  .byte $f8,$0c,$02,$08,$00
  .byte $00,$13,$02,$00,$08
  .byte $00,$14,$02,$08,$00
  .byte $08,$17,$02,$00,$08
  .byte $08,$18,$02,$08,$00

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
