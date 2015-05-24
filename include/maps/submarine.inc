metatile_table_properties:
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
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
metatile_table_params:
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
  .byte $11,$22,$11,$11,$00,$11,$22,$11,$11,$11,$11,$11,$11,$00,$11,$11,$11,$11,$11,$11,$22,$11,$11,$11
  .byte $11,$11,$00,$00,$11
metatile_table_top_left_tiles:
  .byte $02,$1d,$76,$9f,$2a,$17,$04,$30,$0a,$01,$21,$40,$0a,$19,$70,$8c,$00,$1f,$9e,$36,$1d,$59,$17,$88
  .byte $72,$9a,$09,$1b,$84
metatile_table_top_right_tiles:
  .byte $03,$1e,$77,$9e,$2b,$18,$05,$31,$0b,$08,$22,$41,$0b,$1a,$71,$8d,$01,$20,$9e,$37,$1e,$5a,$18,$89
  .byte $73,$9b,$09,$1c,$85
metatile_table_bottom_left_tiles:
  .byte $10,$27,$80,$09,$2c,$0c,$11,$34,$2e,$13,$0f,$4d,$15,$23,$7a,$98,$0c,$28,$09,$38,$27,$6e,$5b,$94
  .byte $7c,$90,$09,$25,$90
metatile_table_bottom_right_tiles:
  .byte $0f,$12,$81,$09,$2d,$0f,$12,$35,$2f,$14,$14,$4e,$16,$24,$7b,$99,$0d,$29,$09,$39,$12,$6f,$5c,$95
  .byte $7d,$91,$09,$26,$91
big_metatile_table_top_left:
  .byte $18,$1c,$11,$0d,$11,$11,$18,$1a,$11,$1c,$13,$11,$1a,$1a,$0e,$15,$01,$01,$0d,$05,$18,$11,$1a,$1c
  .byte $0e,$08,$05,$01,$1a,$11,$1a,$0c,$11,$1a,$0d,$11,$1c,$18,$0d,$11,$14,$11,$04,$1a,$1c,$1c,$1c
big_metatile_table_top_right:
  .byte $18,$0f,$11,$01,$0d,$0c,$02,$1a,$01,$19,$18,$11,$1a,$1a,$1c,$1c,$11,$11,$04,$11,$18,$08,$1a,$1c
  .byte $18,$11,$11,$0d,$1a,$01,$1a,$11,$11,$1a,$0d,$0a,$15,$13,$11,$11,$11,$11,$0d,$1a,$19,$1c,$1c
big_metatile_table_bottom_left:
  .byte $1c,$03,$0d,$0d,$11,$11,$1c,$0c,$0d,$12,$0b,$1b,$10,$00,$03,$03,$01,$01,$0d,$16,$1c,$11,$00,$03
  .byte $0e,$07,$05,$01,$1a,$11,$00,$0c,$0d,$06,$0d,$11,$03,$1c,$0d,$11,$01,$0d,$1b,$00,$03,$03,$12
big_metatile_table_bottom_right:
  .byte $17,$03,$0d,$01,$0d,$0c,$0f,$00,$01,$03,$1c,$0d,$00,$06,$03,$03,$0d,$11,$1b,$11,$1c,$07,$0c,$12
  .byte $1c,$11,$11,$0d,$1a,$01,$00,$11,$11,$00,$0d,$0a,$03,$0b,$11,$0d,$0d,$1b,$0d,$09,$03,$03,$03
map:
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$0c,$21,$1e,$21,$0d,$1e,$0d,$16
  .byte $1e,$1e,$1e,$1e,$1e,$1e,$1e,$07,$21,$1e,$21,$0d,$1e,$0d,$2b,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1a,$28,$0b,$11,$1d,$29,$08,$05,$27,$0b,$29,$02,$0b,$29,$20,$1f,$10,$0b,$11,$1d,$29,$08,$23,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$13,$1b,$2a,$11,$1d,$12,$03,$15,$04,$2a,$12,$22,$2a,$12,$26,$19
  .byte $1b,$2a,$11,$1d,$12,$03,$23,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$18,$14,$14,$14,$14,$14,$14,$25
  .byte $14,$14,$14,$14,$14,$14,$14,$0a,$14,$00,$00,$14,$14,$14,$06,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $0e,$2d,$2d,$2e,$2d,$17,$2d,$24,$17,$2d,$2d,$2d,$2d,$2e,$2d,$0f,$2d,$09,$2c,$17,$2d,$2d,$01,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
