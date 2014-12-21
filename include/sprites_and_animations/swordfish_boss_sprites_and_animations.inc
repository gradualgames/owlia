.ifndef SWORDFISH_BOSS_SPRITES_AND_ANIMATIONS_INC
SWORDFISH_BOSS_SPRITES_AND_ANIMATIONS_INC = 1

swordfish_boss_swim0:
  .byte $0f
  .byte $00,$01,$02,$18,$18
  .byte $00,$02,$02,$20,$10
  .byte $00,$03,$02,$30,$00
  .byte $08,$09,$02,$00,$30
  .byte $08,$0a,$02,$08,$28
  .byte $08,$0b,$02,$10,$20
  .byte $08,$0c,$02,$18,$18
  .byte $08,$0d,$02,$20,$10
  .byte $08,$0e,$02,$28,$08
  .byte $08,$0f,$02,$30,$00
  .byte $10,$19,$02,$10,$20
  .byte $10,$1a,$02,$18,$18
  .byte $10,$1b,$02,$20,$10
  .byte $10,$1c,$02,$28,$08
  .byte $10,$1d,$02,$30,$00
swordfish_boss_swim1:
  .byte $0f
  .byte $00,$04,$02,$18,$18
  .byte $00,$02,$02,$20,$10
  .byte $00,$05,$02,$30,$00
  .byte $08,$10,$02,$00,$30
  .byte $08,$0a,$02,$08,$28
  .byte $08,$11,$02,$10,$20
  .byte $08,$12,$02,$18,$18
  .byte $08,$0d,$02,$20,$10
  .byte $08,$13,$02,$28,$08
  .byte $08,$14,$02,$30,$00
  .byte $10,$1e,$02,$10,$20
  .byte $10,$1f,$02,$18,$18
  .byte $10,$1b,$02,$20,$10
  .byte $10,$20,$02,$28,$08
  .byte $10,$21,$02,$30,$00
swordfish_boss_swim2:
  .byte $0f
  .byte $00,$06,$02,$18,$18
  .byte $00,$07,$02,$20,$10
  .byte $00,$08,$02,$30,$00
  .byte $08,$10,$02,$00,$30
  .byte $08,$0a,$02,$08,$28
  .byte $08,$11,$02,$10,$20
  .byte $08,$15,$02,$18,$18
  .byte $08,$16,$02,$20,$10
  .byte $08,$17,$02,$28,$08
  .byte $08,$18,$02,$30,$00
  .byte $10,$1e,$02,$10,$20
  .byte $10,$22,$02,$18,$18
  .byte $10,$23,$02,$20,$10
  .byte $10,$24,$02,$28,$08
  .byte $10,$25,$02,$30,$00
swordfish_boss_flounder0:
  .byte $11
  .byte $00,$26,$02,$08,$20
  .byte $00,$27,$02,$10,$18
  .byte $00,$28,$02,$18,$10
  .byte $00,$29,$02,$20,$08
  .byte $00,$2a,$02,$28,$00
  .byte $08,$30,$02,$00,$28
  .byte $08,$31,$02,$08,$20
  .byte $08,$32,$02,$10,$18
  .byte $08,$33,$02,$18,$10
  .byte $08,$34,$02,$20,$08
  .byte $08,$35,$02,$28,$00
  .byte $10,$3c,$02,$00,$28
  .byte $10,$3d,$02,$08,$20
  .byte $10,$3e,$02,$10,$18
  .byte $10,$3f,$02,$18,$10
  .byte $10,$40,$02,$20,$08
  .byte $10,$41,$02,$28,$00
swordfish_boss_flounder1:
  .byte $11
  .byte $00,$2b,$02,$08,$20
  .byte $00,$2c,$02,$10,$18
  .byte $00,$2d,$02,$18,$10
  .byte $00,$2e,$02,$20,$08
  .byte $00,$2f,$02,$28,$00
  .byte $08,$36,$02,$00,$28
  .byte $08,$37,$02,$08,$20
  .byte $08,$38,$02,$10,$18
  .byte $08,$39,$02,$18,$10
  .byte $08,$3a,$02,$20,$08
  .byte $08,$3b,$02,$28,$00
  .byte $10,$42,$02,$00,$28
  .byte $10,$43,$02,$08,$20
  .byte $10,$44,$02,$10,$18
  .byte $10,$45,$02,$18,$10
  .byte $10,$46,$02,$20,$08
  .byte $10,$47,$02,$28,$00
swordfish_boss_fin0:
  .byte $01
  .byte $00,$01,$02,$00,$00
swordfish_boss_fin1:
  .byte $01
  .byte $00,$04,$02,$00,$00
swordfish_boss_fin2:
  .byte $01
  .byte $00,$06,$02,$00,$00

swordfish_boss_swim:
  .byte $0a, $08
  .word swordfish_boss_swim0
  .word swordfish_boss_swim1
  .word swordfish_boss_swim2
  .word swordfish_boss_swim1
swordfish_boss_flounder:
  .byte $0a, $04
  .word swordfish_boss_flounder0
  .word swordfish_boss_flounder1
swordfish_boss_fin:
  .byte $0a, $08
  .word swordfish_boss_fin0
  .word swordfish_boss_fin1
  .word swordfish_boss_fin2
  .word swordfish_boss_fin1

.endif
