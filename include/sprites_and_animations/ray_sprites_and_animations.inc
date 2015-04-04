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
  .byte $00,$28,$02,$08,$10
  .byte $08,$30,$02,$00,$18
  .byte $08,$31,$02,$08,$10
  .byte $08,$32,$02,$10,$08
  .byte $08,$33,$02,$18,$00
  .byte $10,$3d,$02,$00,$18
  .byte $10,$3e,$02,$08,$10
  .byte $10,$3f,$02,$10,$08
  .byte $10,$40,$00,$18,$00
ray_fly_down1:
  .byte $09
  .byte $00,$28,$02,$08,$10
  .byte $08,$4a,$02,$00,$18
  .byte $08,$4b,$02,$08,$10
  .byte $08,$4c,$02,$10,$08
  .byte $08,$4d,$02,$18,$00
  .byte $10,$56,$02,$00,$18
  .byte $10,$57,$02,$08,$10
  .byte $10,$58,$02,$10,$08
  .byte $10,$59,$02,$18,$00
ray_fly_side0:
  .byte $0a
  .byte $00,$29,$00,$08,$10
  .byte $00,$2a,$02,$10,$08
  .byte $00,$2b,$02,$18,$00
  .byte $08,$34,$02,$00,$18
  .byte $08,$35,$02,$08,$10
  .byte $08,$36,$02,$10,$08
  .byte $08,$37,$02,$18,$00
  .byte $10,$41,$02,$08,$10
  .byte $10,$42,$02,$10,$08
  .byte $10,$43,$02,$18,$00
ray_fly_side1:
  .byte $0a
  .byte $00,$29,$00,$08,$10
  .byte $00,$45,$02,$10,$08
  .byte $00,$46,$02,$18,$00
  .byte $08,$4e,$02,$00,$18
  .byte $08,$4f,$02,$08,$10
  .byte $08,$50,$02,$10,$08
  .byte $08,$51,$02,$18,$00
  .byte $10,$5a,$02,$08,$10
  .byte $10,$5b,$02,$10,$08
  .byte $10,$5c,$02,$18,$00
ray_fly_up0:
  .byte $0a
  .byte $00,$2c,$02,$00,$18
  .byte $00,$2d,$02,$08,$10
  .byte $00,$2e,$02,$10,$08
  .byte $00,$2f,$02,$18,$00
  .byte $08,$38,$00,$f8,$20
  .byte $08,$39,$02,$00,$18
  .byte $08,$3a,$02,$08,$10
  .byte $08,$3b,$02,$10,$08
  .byte $08,$3c,$02,$18,$00
  .byte $10,$44,$02,$08,$10
ray_fly_up1:
  .byte $09
  .byte $00,$47,$02,$00,$18
  .byte $00,$2d,$02,$08,$10
  .byte $00,$48,$02,$10,$08
  .byte $00,$49,$02,$18,$00
  .byte $08,$52,$02,$00,$18
  .byte $08,$53,$02,$08,$10
  .byte $08,$54,$02,$10,$08
  .byte $08,$55,$02,$18,$00
  .byte $10,$5d,$02,$08,$10
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
  .byte $00,$28,$02,$08,$10
  .byte $08,$33,$02,$18,$00
  .byte $08,$32,$02,$10,$08
  .byte $08,$31,$02,$08,$10
  .byte $08,$30,$02,$00,$18
  .byte $10,$40,$00,$18,$00
  .byte $10,$3f,$02,$10,$08
  .byte $10,$3e,$02,$08,$10
  .byte $10,$3d,$02,$00,$18
ray_fly_down1_reversed:
  .byte $09
  .byte $00,$28,$02,$08,$10
  .byte $08,$4d,$02,$18,$00
  .byte $08,$4c,$02,$10,$08
  .byte $08,$4b,$02,$08,$10
  .byte $08,$4a,$02,$00,$18
  .byte $10,$59,$02,$18,$00
  .byte $10,$58,$02,$10,$08
  .byte $10,$57,$02,$08,$10
  .byte $10,$56,$02,$00,$18
ray_fly_side0_reversed:
  .byte $0a
  .byte $00,$2b,$02,$18,$00
  .byte $00,$2a,$02,$10,$08
  .byte $00,$29,$00,$08,$10
  .byte $08,$37,$02,$18,$00
  .byte $08,$36,$02,$10,$08
  .byte $08,$35,$02,$08,$10
  .byte $08,$34,$02,$00,$18
  .byte $10,$43,$02,$18,$00
  .byte $10,$42,$02,$10,$08
  .byte $10,$41,$02,$08,$10
ray_fly_side1_reversed:
  .byte $0a
  .byte $00,$46,$02,$18,$00
  .byte $00,$45,$02,$10,$08
  .byte $00,$29,$00,$08,$10
  .byte $08,$51,$02,$18,$00
  .byte $08,$50,$02,$10,$08
  .byte $08,$4f,$02,$08,$10
  .byte $08,$4e,$02,$00,$18
  .byte $10,$5c,$02,$18,$00
  .byte $10,$5b,$02,$10,$08
  .byte $10,$5a,$02,$08,$10
ray_fly_up0_reversed:
  .byte $0a
  .byte $00,$2f,$02,$18,$00
  .byte $00,$2e,$02,$10,$08
  .byte $00,$2d,$02,$08,$10
  .byte $00,$2c,$02,$00,$18
  .byte $08,$3c,$02,$18,$00
  .byte $08,$3b,$02,$10,$08
  .byte $08,$3a,$02,$08,$10
  .byte $08,$39,$02,$00,$18
  .byte $08,$38,$00,$f8,$20
  .byte $10,$44,$02,$08,$10
ray_fly_up1_reversed:
  .byte $09
  .byte $00,$49,$02,$18,$00
  .byte $00,$48,$02,$10,$08
  .byte $00,$2d,$02,$08,$10
  .byte $00,$47,$02,$00,$18
  .byte $08,$55,$02,$18,$00
  .byte $08,$54,$02,$10,$08
  .byte $08,$53,$02,$08,$10
  .byte $08,$52,$02,$00,$18
  .byte $10,$5d,$02,$08,$10
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
