.ifndef CLAM_SPRITES_AND_ANIMATIONS_INC
CLAM_SPRITES_AND_ANIMATIONS_INC = 1

clam0:
  .byte $04
  .byte $00,$00,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$06,$03,$00,$08
  .byte $08,$07,$03,$08,$00
clam1:
  .byte $04
  .byte $00,$02,$03,$00,$08
  .byte $00,$03,$03,$08,$00
  .byte $08,$08,$03,$00,$08
  .byte $08,$09,$03,$08,$00
clam2:
  .byte $04
  .byte $00,$04,$03,$00,$08
  .byte $00,$05,$03,$08,$00
  .byte $08,$0a,$03,$00,$08
  .byte $08,$0b,$03,$08,$00

clam:
  .byte $0a, $08
  .word clam0
  .word clam1
  .word clam2
  .word clam1

.endif
