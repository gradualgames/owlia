.ifndef TIGER_SPRITES_AND_ANIMATIONS_INC
TIGER_SPRITES_AND_ANIMATIONS_INC = 1

JellyFishAttack0:
  .byte $04
  .byte $00,$00,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$02,$00,$00,$08
  .byte $08,$03,$00,$08,$00
JellyFishAttack1:
  .byte $04
  .byte $00,$04,$00,$00,$08
  .byte $00,$05,$00,$08,$00
  .byte $08,$06,$00,$00,$08
  .byte $08,$07,$00,$08,$00
JellyFishFloat0:
  .byte $04
  .byte $00,$08,$00,$00,$08
  .byte $00,$09,$00,$08,$00
  .byte $08,$0a,$00,$00,$08
  .byte $08,$0b,$00,$08,$00
JellyFishFloat1:
  .byte $04
  .byte $00,$0c,$00,$00,$08
  .byte $00,$0d,$00,$08,$00
  .byte $08,$0e,$00,$00,$08
  .byte $08,$0f,$00,$08,$00

JellyFishAttack:
  .byte $0a,$04
  .word JellyFishAttack1
  .word JellyFishAttack0
JellyFishFloat:
  .byte $0a,$04
  .word JellyFishFloat1
  .word JellyFishFloat0

.endif
