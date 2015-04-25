.ifndef NPC_COMMODORE_SPRITES_AND_ANIMATIONS_INC
NPC_COMMODORE_SPRITES_AND_ANIMATIONS_INC = 1

npc_commodore_walk_down0:
  .byte $08
  .byte $00,$00,$02,$00,$08
  .byte $00,$01,$02,$08,$00
  .byte $08,$0d,$02,$00,$08
  .byte $08,$0e,$02,$08,$00
  .byte $10,$18,$02,$00,$08
  .byte $10,$19,$02,$08,$00
  .byte $18,$24,$02,$00,$08
  .byte $18,$25,$02,$08,$00
npc_commodore_walk_down1:
  .byte $08
  .byte $00,$02,$02,$00,$08
  .byte $00,$03,$02,$08,$00
  .byte $08,$0f,$02,$00,$08
  .byte $08,$10,$02,$08,$00
  .byte $10,$1a,$02,$00,$08
  .byte $10,$1b,$02,$08,$00
  .byte $18,$26,$02,$00,$08
  .byte $18,$27,$02,$08,$00
npc_commodore_walk_up0:
  .byte $08
  .byte $00,$05,$02,$00,$08
  .byte $00,$06,$02,$08,$00
  .byte $08,$11,$02,$00,$08
  .byte $08,$12,$02,$08,$00
  .byte $10,$1c,$02,$00,$08
  .byte $10,$1d,$02,$08,$00
  .byte $18,$28,$02,$00,$08
  .byte $18,$29,$02,$08,$00
npc_commodore_walk_up1:
  .byte $08
  .byte $00,$07,$02,$00,$08
  .byte $00,$08,$02,$08,$00
  .byte $08,$13,$02,$00,$08
  .byte $08,$14,$02,$08,$00
  .byte $10,$1e,$02,$00,$08
  .byte $10,$1f,$02,$08,$00
  .byte $18,$2a,$02,$00,$08
  .byte $18,$2b,$02,$08,$00
npc_commodore_walk_side0:
  .byte $08
  .byte $00,$09,$02,$00,$08
  .byte $00,$0a,$02,$08,$00
  .byte $08,$15,$02,$00,$08
  .byte $08,$16,$02,$08,$00
  .byte $10,$20,$02,$00,$08
  .byte $10,$21,$02,$08,$00
  .byte $18,$2c,$02,$00,$08
  .byte $18,$2d,$02,$08,$00
npc_commodore_walk_side1:
  .byte $08
  .byte $00,$0b,$02,$00,$08
  .byte $00,$0c,$02,$08,$00
  .byte $08,$17,$02,$00,$08
  .byte $08,$16,$02,$08,$00
  .byte $10,$22,$02,$00,$08
  .byte $10,$23,$02,$08,$00
  .byte $18,$2e,$02,$00,$08
  .byte $18,$2f,$01,$08,$00

npc_commodore_walk_down:
  .byte $0a, $04
  .word npc_commodore_walk_down0
  .word npc_commodore_walk_down1
npc_commodore_walk_up:
  .byte $0a, $04
  .word npc_commodore_walk_up0
  .word npc_commodore_walk_up1
npc_commodore_walk_side:
  .byte $0a, $04
  .word npc_commodore_walk_side0
  .word npc_commodore_walk_side1

.endif
