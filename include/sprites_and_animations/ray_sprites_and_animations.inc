.ifndef RAY_SPRITES_AND_ANIMATIONS_INC
RAY_SPRITES_AND_ANIMATIONS_INC = 1

ray_rise_down0:
  .byte $04
  .byte $00,$13,$00,$00,$08
  .byte $00,$13,$00,$08,$00
  .byte $08,$1e,$02,$00,$08
  .byte $08,$1f,$02,$08,$00
ray_rise_down1:
  .byte $04
  .byte $00,$14,$02,$00,$08
  .byte $00,$15,$02,$08,$00
  .byte $08,$20,$02,$00,$08
  .byte $08,$21,$02,$08,$00
ray_rise_down2:
  .byte $04
  .byte $00,$16,$02,$00,$08
  .byte $00,$17,$02,$08,$00
  .byte $08,$22,$02,$00,$08
  .byte $08,$23,$02,$08,$00
ray_rise_side0:
  .byte $02
  .byte $00,$18,$02,$08,$00
  .byte $08,$24,$02,$08,$00
ray_rise_side1:
  .byte $03
  .byte $00,$19,$02,$00,$08
  .byte $00,$1a,$02,$08,$00
  .byte $08,$25,$02,$08,$00
ray_rise_side2:
  .byte $05
  .byte $00,$1b,$02,$f8,$10
  .byte $00,$1c,$02,$00,$08
  .byte $00,$1d,$02,$08,$00
  .byte $08,$26,$02,$00,$08
  .byte $08,$27,$02,$08,$00
ray_rise_up0:
  .byte $02
  .byte $00,$09,$02,$00,$08
  .byte $00,$0a,$02,$08,$00
ray_rise_up1:
  .byte $04
  .byte $00,$0b,$02,$00,$08
  .byte $00,$0c,$02,$08,$00
  .byte $08,$0f,$02,$00,$08
  .byte $08,$10,$02,$08,$00
ray_rise_up2:
  .byte $04
  .byte $00,$0d,$02,$00,$08
  .byte $00,$0e,$02,$08,$00
  .byte $08,$11,$02,$00,$08
  .byte $08,$12,$02,$08,$00
ray_fly_down0:
  .byte $09
  .byte $f8,$28,$02,$02,$04
  .byte $00,$30,$02,$fa,$0c
  .byte $00,$31,$02,$02,$04
  .byte $00,$32,$02,$0a,$fc
  .byte $00,$33,$02,$12,$f4
  .byte $08,$3d,$02,$fa,$0c
  .byte $08,$3e,$02,$02,$04
  .byte $08,$3f,$02,$0a,$fc
  .byte $08,$40,$00,$12,$f4
ray_fly_down1:
  .byte $09
  .byte $f8,$28,$02,$01,$05
  .byte $00,$4a,$02,$f9,$0d
  .byte $00,$4b,$02,$01,$05
  .byte $00,$4c,$02,$09,$fd
  .byte $00,$4d,$02,$11,$f5
  .byte $08,$56,$02,$f9,$0d
  .byte $08,$57,$02,$01,$05
  .byte $08,$58,$02,$09,$fd
  .byte $08,$59,$02,$11,$f5
ray_fly_side0:
  .byte $0a
  .byte $f8,$29,$00,$fc,$0c
  .byte $f8,$2a,$02,$04,$04
  .byte $f8,$2b,$02,$0c,$fc
  .byte $00,$34,$02,$f4,$14
  .byte $00,$35,$02,$fc,$0c
  .byte $00,$36,$02,$04,$04
  .byte $00,$37,$02,$0c,$fc
  .byte $08,$41,$02,$fc,$0c
  .byte $08,$42,$02,$04,$04
  .byte $08,$43,$02,$0c,$fc
ray_fly_side1:
  .byte $0a
  .byte $f8,$29,$00,$fc,$0c
  .byte $f8,$45,$02,$04,$04
  .byte $f8,$46,$02,$0c,$fc
  .byte $00,$4e,$02,$f4,$14
  .byte $00,$4f,$02,$fc,$0c
  .byte $00,$50,$02,$04,$04
  .byte $00,$51,$02,$0c,$fc
  .byte $08,$5a,$02,$fc,$0c
  .byte $08,$5b,$02,$04,$04
  .byte $08,$5c,$02,$0c,$fc
ray_fly_up0:
  .byte $0a
  .byte $00,$2c,$02,$fc,$10
  .byte $00,$2d,$02,$04,$08
  .byte $00,$2e,$02,$0c,$00
  .byte $00,$2f,$02,$14,$f8
  .byte $08,$38,$00,$f4,$18
  .byte $08,$39,$02,$fc,$10
  .byte $08,$3a,$02,$04,$08
  .byte $08,$3b,$02,$0c,$00
  .byte $08,$3c,$02,$14,$f8
  .byte $10,$44,$02,$04,$08
ray_fly_up1:
  .byte $09
  .byte $00,$47,$02,$fc,$10
  .byte $00,$2d,$02,$04,$08
  .byte $00,$48,$02,$0c,$00
  .byte $00,$49,$02,$14,$f8
  .byte $08,$52,$02,$fc,$10
  .byte $08,$53,$02,$04,$08
  .byte $08,$54,$02,$0c,$00
  .byte $08,$55,$02,$14,$f8
  .byte $10,$5d,$02,$04,$08
ray_rise_eyes_down0:
  .byte $04
  .byte $00,$00,$03,$00,$08
  .byte $00,$00,$03,$08,$00
  .byte $08,$04,$03,$00,$08
  .byte $08,$04,$03,$08,$00
ray_rise_eyes_down1:
  .byte $04
  .byte $00,$01,$03,$00,$08
  .byte $00,$01,$03,$08,$00
  .byte $08,$05,$03,$00,$08
  .byte $08,$05,$03,$08,$00
ray_rise_eyes_down2:
  .byte $04
  .byte $00,$00,$03,$00,$08
  .byte $00,$00,$03,$08,$00
  .byte $08,$04,$03,$00,$08
  .byte $08,$04,$03,$08,$00
ray_rise_eyes_side0:
  .byte $01
  .byte $00,$03,$03,$08,$00
ray_rise_eyes_side1:
  .byte $01
  .byte $00,$03,$03,$08,$00
ray_rise_eyes_side2:
  .byte $01
  .byte $00,$03,$03,$10,$00
ray_eyes_fly_down0:
  .byte $04
  .byte $08,$06,$03,$08,$10
  .byte $08,$06,$03,$10,$08
  .byte $10,$08,$03,$08,$10
  .byte $10,$08,$03,$10,$08
ray_eyes_fly_down1:
  .byte $04
  .byte $08,$01,$03,$08,$10
  .byte $08,$01,$03,$10,$08
  .byte $10,$05,$03,$08,$10
  .byte $10,$05,$03,$10,$08
ray_eyes_fly_side0:
  .byte $01
  .byte $08,$07,$03,$18,$00
ray_eyes_fly_side1:
  .byte $01
  .byte $08,$07,$03,$18,$00
ray_rise_down0_reversed:
  .byte $04
  .byte $00,$13,$00,$08,$00
  .byte $00,$13,$00,$00,$08
  .byte $08,$1f,$02,$08,$00
  .byte $08,$1e,$02,$00,$08
ray_rise_down1_reversed:
  .byte $04
  .byte $00,$15,$02,$08,$00
  .byte $00,$14,$02,$00,$08
  .byte $08,$21,$02,$08,$00
  .byte $08,$20,$02,$00,$08
ray_rise_down2_reversed:
  .byte $04
  .byte $00,$17,$02,$08,$00
  .byte $00,$16,$02,$00,$08
  .byte $08,$23,$02,$08,$00
  .byte $08,$22,$02,$00,$08
ray_rise_side0_reversed:
  .byte $02
  .byte $00,$18,$02,$08,$00
  .byte $08,$24,$02,$08,$00
ray_rise_side1_reversed:
  .byte $03
  .byte $00,$1a,$02,$08,$00
  .byte $00,$19,$02,$00,$08
  .byte $08,$25,$02,$08,$00
ray_rise_side2_reversed:
  .byte $05
  .byte $00,$1d,$02,$08,$00
  .byte $00,$1c,$02,$00,$08
  .byte $00,$1b,$02,$f8,$10
  .byte $08,$27,$02,$08,$00
  .byte $08,$26,$02,$00,$08
ray_rise_up0_reversed:
  .byte $02
  .byte $00,$0a,$02,$08,$00
  .byte $00,$09,$02,$00,$08
ray_rise_up1_reversed:
  .byte $04
  .byte $00,$0c,$02,$08,$00
  .byte $00,$0b,$02,$00,$08
  .byte $08,$10,$02,$08,$00
  .byte $08,$0f,$02,$00,$08
ray_rise_up2_reversed:
  .byte $04
  .byte $00,$0e,$02,$08,$00
  .byte $00,$0d,$02,$00,$08
  .byte $08,$12,$02,$08,$00
  .byte $08,$11,$02,$00,$08
ray_fly_down0_reversed:
  .byte $09
  .byte $f8,$28,$02,$02,$04
  .byte $00,$33,$02,$12,$f4
  .byte $00,$32,$02,$0a,$fc
  .byte $00,$31,$02,$02,$04
  .byte $00,$30,$02,$fa,$0c
  .byte $08,$40,$00,$12,$f4
  .byte $08,$3f,$02,$0a,$fc
  .byte $08,$3e,$02,$02,$04
  .byte $08,$3d,$02,$fa,$0c
ray_fly_down1_reversed:
  .byte $09
  .byte $f8,$28,$02,$01,$05
  .byte $00,$4d,$02,$11,$f5
  .byte $00,$4c,$02,$09,$fd
  .byte $00,$4b,$02,$01,$05
  .byte $00,$4a,$02,$f9,$0d
  .byte $08,$59,$02,$11,$f5
  .byte $08,$58,$02,$09,$fd
  .byte $08,$57,$02,$01,$05
  .byte $08,$56,$02,$f9,$0d
ray_fly_side0_reversed:
  .byte $0a
  .byte $f8,$2b,$02,$0c,$fc
  .byte $f8,$2a,$02,$04,$04
  .byte $f8,$29,$00,$fc,$0c
  .byte $00,$37,$02,$0c,$fc
  .byte $00,$36,$02,$04,$04
  .byte $00,$35,$02,$fc,$0c
  .byte $00,$34,$02,$f4,$14
  .byte $08,$43,$02,$0c,$fc
  .byte $08,$42,$02,$04,$04
  .byte $08,$41,$02,$fc,$0c
ray_fly_side1_reversed:
  .byte $0a
  .byte $f8,$46,$02,$0c,$fc
  .byte $f8,$45,$02,$04,$04
  .byte $f8,$29,$00,$fc,$0c
  .byte $00,$51,$02,$0c,$fc
  .byte $00,$50,$02,$04,$04
  .byte $00,$4f,$02,$fc,$0c
  .byte $00,$4e,$02,$f4,$14
  .byte $08,$5c,$02,$0c,$fc
  .byte $08,$5b,$02,$04,$04
  .byte $08,$5a,$02,$fc,$0c
ray_fly_up0_reversed:
  .byte $0a
  .byte $00,$2f,$02,$14,$f8
  .byte $00,$2e,$02,$0c,$00
  .byte $00,$2d,$02,$04,$08
  .byte $00,$2c,$02,$fc,$10
  .byte $08,$3c,$02,$14,$f8
  .byte $08,$3b,$02,$0c,$00
  .byte $08,$3a,$02,$04,$08
  .byte $08,$39,$02,$fc,$10
  .byte $08,$38,$00,$f4,$18
  .byte $10,$44,$02,$04,$08
ray_fly_up1_reversed:
  .byte $09
  .byte $00,$49,$02,$14,$f8
  .byte $00,$48,$02,$0c,$00
  .byte $00,$2d,$02,$04,$08
  .byte $00,$47,$02,$fc,$10
  .byte $08,$55,$02,$14,$f8
  .byte $08,$54,$02,$0c,$00
  .byte $08,$53,$02,$04,$08
  .byte $08,$52,$02,$fc,$10
  .byte $10,$5d,$02,$04,$08
ray_rise_eyes_down0_reversed:
  .byte $04
  .byte $00,$00,$03,$08,$00
  .byte $00,$00,$03,$00,$08
  .byte $08,$04,$03,$08,$00
  .byte $08,$04,$03,$00,$08
ray_rise_eyes_down1_reversed:
  .byte $04
  .byte $00,$01,$03,$08,$00
  .byte $00,$01,$03,$00,$08
  .byte $08,$05,$03,$08,$00
  .byte $08,$05,$03,$00,$08
ray_rise_eyes_down2_reversed:
  .byte $04
  .byte $00,$00,$03,$08,$00
  .byte $00,$00,$03,$00,$08
  .byte $08,$04,$03,$08,$00
  .byte $08,$04,$03,$00,$08
ray_rise_eyes_side0_reversed:
  .byte $01
  .byte $00,$03,$03,$08,$00
ray_rise_eyes_side1_reversed:
  .byte $01
  .byte $00,$03,$03,$08,$00
ray_rise_eyes_side2_reversed:
  .byte $01
  .byte $00,$03,$03,$10,$00
ray_eyes_fly_down0_reversed:
  .byte $04
  .byte $08,$06,$03,$10,$08
  .byte $08,$06,$03,$08,$10
  .byte $10,$08,$03,$10,$08
  .byte $10,$08,$03,$08,$10
ray_eyes_fly_down1_reversed:
  .byte $04
  .byte $08,$01,$03,$10,$08
  .byte $08,$01,$03,$08,$10
  .byte $10,$05,$03,$10,$08
  .byte $10,$05,$03,$08,$10
ray_eyes_fly_side0_reversed:
  .byte $01
  .byte $08,$07,$03,$18,$00
ray_eyes_fly_side1_reversed:
  .byte $01
  .byte $08,$07,$03,$18,$00
ray_fly_down:
  .byte $01, $28
  .word ray_fly_down0
  .word ray_fly_down0_reversed
  .word ray_fly_down0
  .word ray_fly_down0_reversed
  .word ray_fly_down0
  .word ray_fly_down0_reversed
  .word ray_fly_down0
  .word ray_fly_down0_reversed
  .word ray_fly_down0
  .word ray_fly_down0_reversed
  .word ray_fly_down1
  .word ray_fly_down1_reversed
  .word ray_fly_down1
  .word ray_fly_down1_reversed
  .word ray_fly_down1
  .word ray_fly_down1_reversed
  .word ray_fly_down1
  .word ray_fly_down1_reversed
  .word ray_fly_down1
  .word ray_fly_down1_reversed
ray_fly_side:
  .byte $01, $28
  .word ray_fly_side0
  .word ray_fly_side0_reversed
  .word ray_fly_side0
  .word ray_fly_side0_reversed
  .word ray_fly_side0
  .word ray_fly_side0_reversed
  .word ray_fly_side0
  .word ray_fly_side0_reversed
  .word ray_fly_side0
  .word ray_fly_side0_reversed
  .word ray_fly_side1
  .word ray_fly_side1_reversed
  .word ray_fly_side1
  .word ray_fly_side1_reversed
  .word ray_fly_side1
  .word ray_fly_side1_reversed
  .word ray_fly_side1
  .word ray_fly_side1_reversed
  .word ray_fly_side1
  .word ray_fly_side1_reversed
ray_fly_up:
  .byte $01, $28
  .word ray_fly_up0
  .word ray_fly_up0_reversed
  .word ray_fly_up0
  .word ray_fly_up0_reversed
  .word ray_fly_up0
  .word ray_fly_up0_reversed
  .word ray_fly_up0
  .word ray_fly_up0_reversed
  .word ray_fly_up0
  .word ray_fly_up0_reversed
  .word ray_fly_up1
  .word ray_fly_up1_reversed
  .word ray_fly_up1
  .word ray_fly_up1_reversed
  .word ray_fly_up1
  .word ray_fly_up1_reversed
  .word ray_fly_up1
  .word ray_fly_up1_reversed
  .word ray_fly_up1
  .word ray_fly_up1_reversed
ray_rise_down:
  .byte $01, $3c
  .word ray_rise_down0
  .word ray_rise_down0_reversed
  .word ray_rise_down0
  .word ray_rise_down0_reversed
  .word ray_rise_down0
  .word ray_rise_down0_reversed
  .word ray_rise_down0
  .word ray_rise_down0_reversed
  .word ray_rise_down0
  .word ray_rise_down0_reversed
  .word ray_rise_down1
  .word ray_rise_down1_reversed
  .word ray_rise_down1
  .word ray_rise_down1_reversed
  .word ray_rise_down1
  .word ray_rise_down1_reversed
  .word ray_rise_down1
  .word ray_rise_down1_reversed
  .word ray_rise_down1
  .word ray_rise_down1_reversed
  .word ray_rise_down2
  .word ray_rise_down2_reversed
  .word ray_rise_down2
  .word ray_rise_down2_reversed
  .word ray_rise_down2
  .word ray_rise_down2_reversed
  .word ray_rise_down2
  .word ray_rise_down2_reversed
  .word ray_rise_down2
  .word ray_rise_down2_reversed
ray_rise_side:
  .byte $01, $3c
  .word ray_rise_side0
  .word ray_rise_side0_reversed
  .word ray_rise_side0
  .word ray_rise_side0_reversed
  .word ray_rise_side0
  .word ray_rise_side0_reversed
  .word ray_rise_side0
  .word ray_rise_side0_reversed
  .word ray_rise_side0
  .word ray_rise_side0_reversed
  .word ray_rise_side1
  .word ray_rise_side1_reversed
  .word ray_rise_side1
  .word ray_rise_side1_reversed
  .word ray_rise_side1
  .word ray_rise_side1_reversed
  .word ray_rise_side1
  .word ray_rise_side1_reversed
  .word ray_rise_side1
  .word ray_rise_side1_reversed
  .word ray_rise_side2
  .word ray_rise_side2_reversed
  .word ray_rise_side2
  .word ray_rise_side2_reversed
  .word ray_rise_side2
  .word ray_rise_side2_reversed
  .word ray_rise_side2
  .word ray_rise_side2_reversed
  .word ray_rise_side2
  .word ray_rise_side2_reversed
ray_rise_up:
  .byte $01, $3c
  .word ray_rise_up0
  .word ray_rise_up0_reversed
  .word ray_rise_up0
  .word ray_rise_up0_reversed
  .word ray_rise_up0
  .word ray_rise_up0_reversed
  .word ray_rise_up0
  .word ray_rise_up0_reversed
  .word ray_rise_up0
  .word ray_rise_up0_reversed
  .word ray_rise_up1
  .word ray_rise_up1_reversed
  .word ray_rise_up1
  .word ray_rise_up1_reversed
  .word ray_rise_up1
  .word ray_rise_up1_reversed
  .word ray_rise_up1
  .word ray_rise_up1_reversed
  .word ray_rise_up1
  .word ray_rise_up1_reversed
  .word ray_rise_up2
  .word ray_rise_up2_reversed
  .word ray_rise_up2
  .word ray_rise_up2_reversed
  .word ray_rise_up2
  .word ray_rise_up2_reversed
  .word ray_rise_up2
  .word ray_rise_up2_reversed
  .word ray_rise_up2
  .word ray_rise_up2_reversed

.endif
