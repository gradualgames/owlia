.ifndef HERO_SPRITES_AND_ANIMATIONS_INC
HERO_SPRITES_AND_ANIMATIONS_INC = 1

adlanniel_walk_down0:
  .byte $08
  .byte $00,$01,$00,$00,$08
  .byte $00,$02,$00,$08,$00
  .byte $08,$0a,$00,$00,$08
  .byte $08,$0b,$00,$08,$00
  .byte $10,$12,$00,$00,$08
  .byte $10,$13,$00,$08,$00
  .byte $18,$1a,$00,$00,$08
  .byte $18,$1b,$00,$08,$00
adlanniel_walk_down1:
  .byte $08
  .byte $00,$03,$00,$00,$08
  .byte $00,$04,$00,$08,$00
  .byte $08,$0c,$00,$00,$08
  .byte $08,$0d,$00,$08,$00
  .byte $10,$14,$00,$00,$08
  .byte $10,$15,$00,$08,$00
  .byte $18,$1c,$00,$00,$08
  .byte $18,$1d,$00,$08,$00
adlanniel_walk_down2:
  .byte $08
  .byte $00,$01,$00,$00,$08
  .byte $00,$02,$00,$08,$00
  .byte $08,$0a,$00,$00,$08
  .byte $08,$0b,$00,$08,$00
  .byte $10,$12,$40,$08,$00
  .byte $10,$13,$40,$00,$08
  .byte $18,$1a,$40,$08,$00
  .byte $18,$1b,$40,$00,$08
adlanniel_walk_up0:
  .byte $08
  .byte $00,$05,$00,$00,$08
  .byte $00,$06,$00,$08,$00
  .byte $08,$0e,$00,$00,$08
  .byte $08,$0f,$00,$08,$00
  .byte $10,$16,$00,$00,$08
  .byte $10,$17,$00,$08,$00
  .byte $18,$1e,$00,$00,$08
  .byte $18,$1f,$00,$08,$00
adlanniel_walk_up1:
  .byte $08
  .byte $00,$07,$00,$00,$08
  .byte $00,$08,$00,$08,$00
  .byte $08,$10,$00,$00,$08
  .byte $08,$11,$00,$08,$00
  .byte $10,$18,$00,$00,$08
  .byte $10,$19,$00,$08,$00
  .byte $18,$20,$00,$00,$08
  .byte $18,$21,$00,$08,$00
adlanniel_walk_up2:
  .byte $08
  .byte $00,$05,$00,$00,$08
  .byte $00,$06,$00,$08,$00
  .byte $08,$0e,$00,$00,$08
  .byte $08,$0f,$00,$08,$00
  .byte $10,$16,$40,$08,$00
  .byte $10,$17,$40,$00,$08
  .byte $18,$1e,$40,$08,$00
  .byte $18,$1f,$40,$00,$08
heart0:
  .byte $01
  .byte $00,$09,$00,$00,$00
adlanniel_walk_side1:
  .byte $08
  .byte $00,$22,$00,$00,$08
  .byte $00,$23,$00,$08,$00
  .byte $08,$26,$00,$00,$08
  .byte $08,$27,$00,$08,$00
  .byte $10,$2b,$00,$00,$08
  .byte $10,$2c,$00,$08,$00
  .byte $18,$33,$00,$00,$08
  .byte $18,$34,$00,$08,$00
adlanniel_walk_side0:
  .byte $08
  .byte $00,$24,$00,$00,$08
  .byte $00,$25,$00,$08,$00
  .byte $08,$28,$00,$00,$08
  .byte $08,$29,$00,$08,$00
  .byte $10,$2d,$00,$00,$08
  .byte $10,$2e,$00,$08,$00
  .byte $18,$35,$00,$00,$08
  .byte $18,$36,$00,$08,$00
adlanniel_walk_side2:
  .byte $08
  .byte $00,$22,$00,$00,$08
  .byte $00,$23,$00,$08,$00
  .byte $08,$26,$00,$00,$08
  .byte $08,$2a,$00,$08,$00
  .byte $10,$2f,$00,$00,$08
  .byte $10,$30,$00,$08,$00
  .byte $18,$37,$00,$00,$08
  .byte $18,$38,$00,$08,$00
adlanniel_fight_side0:
  .byte $0c
  .byte $00,$3d,$00,$00,$08
  .byte $00,$3e,$00,$08,$00
  .byte $00,$3f,$00,$10,$f8
  .byte $08,$4a,$00,$00,$08
  .byte $08,$4b,$00,$08,$00
  .byte $08,$4c,$00,$10,$f8
  .byte $10,$58,$00,$00,$08
  .byte $10,$59,$00,$08,$00
  .byte $10,$5a,$00,$10,$f8
  .byte $18,$66,$00,$00,$08
  .byte $18,$67,$00,$08,$00
  .byte $18,$68,$00,$10,$f8
adlanniel_fight_side1:
  .byte $10
  .byte $04,$3d,$00,$00,$08
  .byte $04,$3e,$00,$08,$00
  .byte $04,$3f,$00,$10,$f8
  .byte $04,$00,$00,$18,$f0
  .byte $0c,$46,$00,$00,$08
  .byte $0c,$47,$00,$08,$00
  .byte $0c,$48,$00,$10,$f8
  .byte $0c,$49,$00,$18,$f0
  .byte $14,$55,$00,$00,$08
  .byte $14,$56,$00,$08,$00
  .byte $14,$57,$00,$10,$f8
  .byte $14,$00,$00,$18,$f0
  .byte $1c,$63,$00,$00,$08
  .byte $1c,$64,$00,$08,$00
  .byte $1c,$65,$00,$10,$f8
  .byte $1c,$00,$00,$18,$f0
adlanniel_fight_down0:
  .byte $08
  .byte $00,$40,$00,$00,$08
  .byte $00,$41,$00,$08,$00
  .byte $08,$4f,$00,$00,$08
  .byte $08,$50,$00,$08,$00
  .byte $10,$5d,$00,$00,$08
  .byte $10,$5e,$00,$08,$00
  .byte $18,$6b,$00,$00,$08
  .byte $18,$6c,$00,$08,$00
adlanniel_fight_down1:
  .byte $0a
  .byte $04,$40,$00,$00,$08
  .byte $04,$41,$00,$08,$00
  .byte $0c,$4d,$00,$00,$08
  .byte $0c,$4e,$00,$08,$00
  .byte $14,$5b,$00,$00,$08
  .byte $14,$5c,$00,$08,$00
  .byte $1c,$69,$00,$00,$08
  .byte $1c,$6a,$00,$08,$00
  .byte $24,$6f,$00,$00,$08
  .byte $24,$00,$00,$08,$00
adlanniel_fight_up0:
  .byte $0a
  .byte $f8,$31,$00,$00,$08
  .byte $f8,$32,$00,$08,$00
  .byte $00,$3b,$00,$00,$08
  .byte $00,$3c,$00,$08,$00
  .byte $08,$44,$00,$00,$08
  .byte $08,$45,$00,$08,$00
  .byte $10,$53,$00,$00,$08
  .byte $10,$54,$00,$08,$00
  .byte $18,$61,$00,$00,$08
  .byte $18,$62,$00,$08,$00
adlanniel_fight_up1:
  .byte $0c
  .byte $f4,$31,$00,$00,$08
  .byte $f4,$32,$00,$08,$00
  .byte $fc,$39,$00,$00,$08
  .byte $fc,$3a,$00,$08,$00
  .byte $04,$42,$00,$00,$08
  .byte $04,$43,$00,$08,$00
  .byte $0c,$51,$00,$00,$08
  .byte $0c,$52,$00,$08,$00
  .byte $14,$5f,$00,$00,$08
  .byte $14,$60,$00,$08,$00
  .byte $1c,$6d,$00,$00,$08
  .byte $1c,$6e,$00,$08,$00
adlanniel_throw_side0:
  .byte $0c
  .byte $03,$3d,$00,$00,$08
  .byte $03,$3e,$00,$08,$00
  .byte $03,$3f,$00,$10,$f8
  .byte $0b,$70,$00,$00,$08
  .byte $0b,$47,$00,$08,$00
  .byte $0b,$71,$00,$10,$f8
  .byte $13,$55,$00,$00,$08
  .byte $13,$56,$00,$08,$00
  .byte $13,$00,$00,$10,$f8
  .byte $1b,$63,$00,$00,$08
  .byte $1b,$64,$00,$08,$00
  .byte $1b,$65,$00,$10,$f8
adlanniel_throw_down0:
  .byte $08
  .byte $04,$40,$00,$00,$08
  .byte $04,$41,$00,$08,$00
  .byte $0c,$4d,$00,$00,$08
  .byte $0c,$72,$00,$08,$00
  .byte $14,$73,$00,$00,$08
  .byte $14,$74,$00,$08,$00
  .byte $1c,$75,$00,$00,$08
  .byte $1c,$6a,$00,$08,$00
adlanniel_throw_up0:
  .byte $08
  .byte $05,$42,$00,$00,$08
  .byte $05,$43,$00,$08,$00
  .byte $0d,$51,$00,$00,$08
  .byte $0d,$52,$00,$08,$00
  .byte $15,$5f,$00,$00,$08
  .byte $15,$60,$00,$08,$00
  .byte $1d,$6d,$00,$00,$08
  .byte $1d,$6e,$00,$08,$00

adlanniel_walk_down:
  .byte $08, $08
  .word adlanniel_walk_down0
  .word adlanniel_walk_down1
  .word adlanniel_walk_down2
  .word adlanniel_walk_down1
adlanniel_walk_up:
  .byte $08, $08
  .word adlanniel_walk_up1
  .word adlanniel_walk_up2
  .word adlanniel_walk_up1
  .word adlanniel_walk_up0
adlanniel_walk_side:
  .byte $08, $08
  .word adlanniel_walk_side0
  .word adlanniel_walk_side1
  .word adlanniel_walk_side0
  .word adlanniel_walk_side2
adlanniel_fight_side:
  .byte $0a, $04
  .word adlanniel_fight_side0
  .word adlanniel_fight_side1
adlanniel_fight_down:
  .byte $0a, $04
  .word adlanniel_fight_down0
  .word adlanniel_fight_down1
adlanniel_fight_up:
  .byte $0a, $04
  .word adlanniel_fight_up0
  .word adlanniel_fight_up1
adlanniel_throw_side:
  .byte $0a, $04
  .word adlanniel_walk_side0
  .word adlanniel_throw_side0
adlanniel_throw_down:
  .byte $0a, $04
  .word adlanniel_walk_down1
  .word adlanniel_throw_down0
adlanniel_throw_up:
  .byte $0a, $04
  .word adlanniel_walk_up1
  .word adlanniel_throw_up0
heart:
  .byte $0a, $02
  .word heart0

.endif
