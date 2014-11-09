.ifndef DUNGEON_ENTRANCE_STATUE_SPRITES_AND_ANIMATIONS_INC
DUNGEON_ENTRANCE_STATUE_SPRITES_AND_ANIMATIONS_INC = 1

dungeon_entrance_statue0:
  .byte $06
  .byte $00,$00,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$02,$00,$00,$08
  .byte $08,$03,$00,$08,$00
  .byte $10,$04,$00,$00,$08
  .byte $10,$05,$00,$08,$00

dungeon_entrance_statue:
  .byte $0a, $02
  .word dungeon_entrance_statue0

.endif
