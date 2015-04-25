.ifndef NPC_BOSUN_SPRITES_AND_ANIMATIONS_INC
NPC_BOSUN_SPRITES_AND_ANIMATIONS_INC = 1

npc_bosun_walk_down0:
  .byte $08
  .byte $00,$00,$01,$00,$08
  .byte $00,$01,$01,$08,$00
  .byte $08,$0b,$01,$00,$08
  .byte $08,$0c,$01,$08,$00
  .byte $10,$17,$01,$00,$08
  .byte $10,$18,$01,$08,$00
  .byte $18,$23,$01,$00,$08
  .byte $18,$24,$01,$08,$00
npc_bosun_walk_down1:
  .byte $08
  .byte $00,$02,$01,$00,$08
  .byte $00,$03,$01,$08,$00
  .byte $08,$0d,$01,$00,$08
  .byte $08,$0e,$01,$08,$00
  .byte $10,$19,$01,$00,$08
  .byte $10,$1a,$01,$08,$00
  .byte $18,$25,$01,$00,$08
  .byte $18,$26,$01,$08,$00
npc_bosun_walk_up0:
  .byte $08
  .byte $00,$05,$01,$00,$08
  .byte $00,$06,$01,$08,$00
  .byte $08,$0f,$01,$00,$08
  .byte $08,$10,$01,$08,$00
  .byte $10,$1b,$01,$00,$08
  .byte $10,$1c,$01,$08,$00
  .byte $18,$27,$00,$00,$08
  .byte $18,$28,$01,$08,$00
npc_bosun_walk_up1:
  .byte $08
  .byte $00,$05,$01,$00,$08
  .byte $00,$06,$01,$08,$00
  .byte $08,$11,$01,$00,$08
  .byte $08,$12,$01,$08,$00
  .byte $10,$1d,$01,$00,$08
  .byte $10,$1e,$01,$08,$00
  .byte $18,$29,$01,$00,$08
  .byte $18,$2a,$00,$08,$00
npc_bosun_walk_side0:
  .byte $08
  .byte $00,$07,$01,$00,$08
  .byte $00,$08,$01,$08,$00
  .byte $08,$13,$01,$00,$08
  .byte $08,$14,$01,$08,$00
  .byte $10,$1f,$01,$00,$08
  .byte $10,$20,$01,$08,$00
  .byte $18,$2b,$01,$00,$08
  .byte $18,$2c,$01,$08,$00
npc_bosun_walk_side1:
  .byte $08
  .byte $00,$09,$01,$00,$08
  .byte $00,$0a,$01,$08,$00
  .byte $08,$15,$01,$00,$08
  .byte $08,$16,$01,$08,$00
  .byte $10,$21,$01,$00,$08
  .byte $10,$22,$01,$08,$00
  .byte $18,$2d,$01,$00,$08
  .byte $18,$2e,$01,$08,$00

npc_bosun_walk_down:
  .byte $0a, $04
  .word npc_bosun_walk_down0
  .word npc_bosun_walk_down1
npc_bosun_walk_up:
  .byte $0a, $04
  .word npc_bosun_walk_up0
  .word npc_bosun_walk_up1
npc_bosun_walk_side:
  .byte $0a, $04
  .word npc_bosun_walk_side0
  .word npc_bosun_walk_side1


.endif
