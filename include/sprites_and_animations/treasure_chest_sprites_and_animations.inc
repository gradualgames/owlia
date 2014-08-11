.ifndef TREASURE_CHEST_SPRITES_AND_ANIMATIONS_INC
TREASURE_CHEST_SPRITES_AND_ANIMATIONS_INC = 1

treasure_chest0:
  .byte $04
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$04,$01,$00,$08
  .byte $08,$05,$01,$08,$00
treasure_chest1:
  .byte $04
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$06,$01,$00,$08
  .byte $08,$07,$01,$08,$00

treasure_chest:
  .byte $0a, $04
  .word treasure_chest0
  .word treasure_chest1

.endif
