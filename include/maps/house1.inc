metatile_table_properties:
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
metatile_table_params:
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte location_index_village_house1_entrance
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
metatile_table_attributes:
  .byte $22,$22,$22,$22,$22,$22,$00,$22,$22,$22,$22,$22,$22,$00,$22,$22,$00,$22,$22,$22,$22,$22,$22,$22
  .byte $33,$22,$33,$00,$22,$33,$22,$33,$22,$11,$22,$22,$22,$33,$22,$22,$22,$22,$22,$00,$22,$22,$22,$33
  .byte $33,$22,$22,$33,$22,$22
metatile_table_top_left_tiles:
  .byte $a1,$05,$0f,$1c,$01,$c1,$00,$03,$bb,$50,$50,$9d,$39,$66,$72,$36,$64,$89,$bf,$85,$1e,$a3,$0f,$1a
  .byte $24,$8b,$13,$00,$39,$24,$62,$11,$78,$52,$03,$9b,$74,$18,$b3,$76,$bd,$d3,$8d,$87,$1c,$1e,$9f,$32
  .byte $34,$54,$38,$16,$4c,$4e
metatile_table_top_right_tiles:
  .byte $a2,$06,$10,$1d,$02,$c2,$00,$04,$bc,$b5,$51,$9e,$39,$67,$73,$37,$65,$8a,$c0,$86,$1b,$a4,$10,$1b
  .byte $24,$8c,$14,$00,$3a,$24,$63,$12,$79,$53,$04,$9c,$75,$19,$b4,$77,$be,$d4,$8e,$88,$1d,$1b,$a0,$33
  .byte $35,$55,$39,$17,$4d,$4f
metatile_table_bottom_left_tiles:
  .byte $aa,$0d,$1f,$2a,$07,$c9,$00,$09,$c3,$b9,$5c,$a7,$48,$6e,$7a,$44,$6c,$95,$c7,$91,$28,$aa,$ae,$28
  .byte $40,$97,$23,$00,$4a,$3d,$6a,$21,$81,$5e,$0b,$a5,$7d,$26,$b7,$7f,$c5,$d5,$99,$93,$58,$2c,$a9,$3b
  .byte $42,$60,$46,$24,$56,$5a
metatile_table_bottom_right_tiles:
  .byte $aa,$0e,$20,$2b,$08,$ca,$00,$0a,$c4,$ba,$5d,$a8,$49,$7c,$7b,$45,$6d,$96,$c8,$92,$29,$ab,$af,$29
  .byte $41,$98,$24,$00,$4b,$3e,$6b,$22,$82,$5f,$0c,$a6,$7e,$27,$b8,$80,$c6,$d6,$9a,$94,$59,$2d,$aa,$3c
  .byte $43,$61,$47,$25,$57,$5b
big_metatile_table_top_left:
  .byte $03,$12,$31,$1b,$02,$08,$17,$1b,$0d,$07,$0a,$1b,$02,$19,$1b,$07,$06,$2b,$1b,$1e,$29,$0d,$07,$03
  .byte $29,$23,$02,$13,$03,$17,$17,$35,$0d,$09,$2b,$02,$27,$26,$0d,$1f,$2c,$33
big_metatile_table_top_right:
  .byte $03,$07,$2d,$1b,$0d,$07,$03,$1b,$2d,$07,$21,$1b,$03,$2a,$1b,$28,$06,$2d,$1b,$0d,$29,$34,$05,$2d
  .byte $0b,$29,$0d,$0d,$03,$0d,$2c,$35,$0d,$0d,$11,$2c,$20,$0d,$24,$1a,$2c,$25
big_metatile_table_bottom_left:
  .byte $0f,$23,$0d,$22,$16,$29,$17,$07,$0d,$29,$0d,$07,$02,$00,$1b,$29,$1b,$0d,$04,$0e,$29,$0d,$29,$1c
  .byte $29,$23,$02,$23,$32,$17,$17,$0d,$0d,$0d,$0d,$02,$19,$02,$0d,$2f,$0d,$18
big_metatile_table_bottom_right:
  .byte $0f,$29,$2d,$07,$0d,$29,$03,$01,$2d,$29,$0d,$07,$03,$15,$1b,$29,$1b,$14,$07,$0d,$29,$2d,$0b,$2d
  .byte $0b,$29,$0d,$0d,$0c,$0d,$10,$0d,$0d,$0d,$2e,$10,$2a,$0d,$11,$1d,$0d,$30
map:
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$12,$0b,$0b,$03,$0b,$0b,$07,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0c,$27,$29,$06
  .byte $00,$1c,$17,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$23,$28,$28,$1e,$1f,$0a,$02,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$1a,$13,$13,$1d,$26,$24,$08,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$04,$20,$20,$1b
  .byte $22,$0d,$11,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$25,$20,$20,$21,$20,$20,$15,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$1a,$20,$20,$20,$20,$20,$08,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$05,$09,$16,$20
  .byte $01,$09,$0f,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$14,$14,$18,$20,$19,$14,$14,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$10,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
