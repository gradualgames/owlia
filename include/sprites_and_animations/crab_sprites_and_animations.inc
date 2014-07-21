.ifndef CRAB_SPRITES_AND_ANIMATIONS_INC
CRAB_SPRITES_AND_ANIMATIONS_INC = 1

crab_walk0:
  .byte $06
  .byte $00,$00,$03,$00,$10
  .byte $00,$01,$03,$08,$08
  .byte $00,$02,$03,$10,$00
  .byte $08,$03,$03,$00,$10
  .byte $08,$04,$03,$08,$08
  .byte $08,$05,$03,$10,$00
crab_walk1:
  .byte $06
  .byte $00,$06,$03,$00,$10
  .byte $00,$07,$03,$08,$08
  .byte $00,$08,$03,$10,$00
  .byte $08,$09,$03,$00,$10
  .byte $08,$0a,$03,$08,$08
  .byte $08,$0b,$03,$10,$00
crab_walk2:
  .byte $06
  .byte $00,$0c,$03,$00,$10
  .byte $00,$0d,$03,$08,$08
  .byte $00,$0e,$03,$10,$00
  .byte $08,$0f,$03,$00,$10
  .byte $08,$10,$03,$08,$08
  .byte $08,$11,$03,$10,$00

crab_walk:
  .byte $0a, $08
  .word crab_walk0
  .word crab_walk1
  .word crab_walk2
  .word crab_walk1

.endif
