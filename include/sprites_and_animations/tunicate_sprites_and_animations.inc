.ifndef TUNICATE_SPRITES_AND_ANIMATIONS_INC
TUNICATE_SPRITES_AND_ANIMATIONS_INC = 1

tunicate0:
  .byte $04
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$07,$02,$00,$08
  .byte $08,$08,$02,$08,$00
tunicate1:
  .byte $04
  .byte $00,$02,$02,$00,$08
  .byte $00,$03,$02,$08,$00
  .byte $08,$09,$02,$00,$08
  .byte $08,$0a,$02,$08,$00
tunicate2:
  .byte $04
  .byte $00,$04,$02,$00,$08
  .byte $00,$05,$02,$08,$00
  .byte $08,$0b,$02,$00,$08
  .byte $08,$0c,$02,$08,$00
tunicate3:
  .byte $04
  .byte $00,$00,$42,$08,$00
  .byte $00,$01,$42,$00,$08
  .byte $08,$07,$42,$08,$00
  .byte $08,$08,$42,$00,$08

tunicate:
  .byte $0a, $08
  .word tunicate1
  .word tunicate0
  .word tunicate2
  .word tunicate3

.endif
