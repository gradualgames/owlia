.ifndef NPC_CAPTAIN_SPRITES_AND_ANIMATIONS_INC
NPC_CAPTAIN_SPRITES_AND_ANIMATIONS_INC = 1

npc_captain_walk_down0:
  .byte $08
  .byte $00,$00,$00,$00,$08
  .byte $00,$01,$00,$08,$00
  .byte $08,$0f,$00,$00,$08
  .byte $08,$10,$00,$08,$00
  .byte $10,$1d,$00,$00,$08
  .byte $10,$1e,$00,$08,$00
  .byte $18,$2d,$00,$00,$08
  .byte $18,$2e,$00,$08,$00
npc_captain_walk_down1:
  .byte $08
  .byte $00,$02,$00,$00,$08
  .byte $00,$03,$00,$08,$00
  .byte $08,$11,$00,$00,$08
  .byte $08,$12,$00,$08,$00
  .byte $10,$1f,$00,$00,$08
  .byte $10,$20,$00,$08,$00
  .byte $18,$2f,$00,$00,$08
  .byte $18,$30,$00,$08,$00
npc_captain_walk_up0:
  .byte $08
  .byte $00,$05,$00,$00,$08
  .byte $00,$06,$00,$08,$00
  .byte $08,$13,$00,$00,$08
  .byte $08,$14,$00,$08,$00
  .byte $10,$21,$00,$00,$08
  .byte $10,$22,$00,$08,$00
  .byte $18,$31,$00,$00,$08
  .byte $18,$32,$00,$08,$00
npc_captain_walk_up1:
  .byte $08
  .byte $00,$07,$00,$00,$08
  .byte $00,$08,$00,$08,$00
  .byte $08,$15,$00,$00,$08
  .byte $08,$16,$00,$08,$00
  .byte $10,$23,$00,$00,$08
  .byte $10,$24,$00,$08,$00
  .byte $18,$33,$00,$00,$08
  .byte $18,$34,$00,$08,$00
npc_captain_walk_side0:
  .byte $08
  .byte $00,$09,$00,$00,$08
  .byte $00,$0a,$00,$08,$00
  .byte $08,$17,$00,$00,$08
  .byte $08,$18,$00,$08,$00
  .byte $10,$25,$00,$00,$08
  .byte $10,$26,$00,$08,$00
  .byte $18,$35,$00,$00,$08
  .byte $18,$36,$00,$08,$00
npc_captain_walk_side1:
  .byte $08
  .byte $00,$0b,$00,$00,$08
  .byte $00,$0a,$00,$08,$00
  .byte $08,$19,$00,$00,$08
  .byte $08,$18,$00,$08,$00
  .byte $10,$27,$00,$00,$08
  .byte $10,$28,$00,$08,$00
  .byte $18,$37,$00,$00,$08
  .byte $18,$38,$01,$08,$00
npc_captain_walk_side_patch0:
  .byte $08
  .byte $00,$0c,$00,$00,$08
  .byte $00,$0d,$00,$08,$00
  .byte $08,$1a,$00,$00,$08
  .byte $08,$1b,$00,$08,$00
  .byte $10,$29,$00,$00,$08
  .byte $10,$2a,$00,$08,$00
  .byte $18,$39,$01,$00,$08
  .byte $18,$3a,$00,$08,$00
npc_captain_walk_side_patch1:
  .byte $08
  .byte $00,$0c,$00,$00,$08
  .byte $00,$0e,$00,$08,$00
  .byte $08,$1a,$00,$00,$08
  .byte $08,$1c,$00,$08,$00
  .byte $10,$2b,$00,$00,$08
  .byte $10,$2c,$00,$08,$00
  .byte $18,$3b,$00,$00,$08
  .byte $18,$3c,$00,$08,$00

npc_captain_walk_down:
  .byte $0a, $04
  .word npc_captain_walk_down0
  .word npc_captain_walk_down1
npc_captain_walk_up:
  .byte $0a, $04
  .word npc_captain_walk_up0
  .word npc_captain_walk_up1
npc_captain_walk_side:
  .byte $0a, $04
  .word npc_captain_walk_side0
  .word npc_captain_walk_side1
npc_captain_walk_side_patch:
  .byte $0a, $04
  .word npc_captain_walk_side_patch0
  .word npc_captain_walk_side_patch1

.endif
