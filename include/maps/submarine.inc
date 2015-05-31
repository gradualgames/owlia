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
  .byte $00
metatile_table_attributes:
  .byte $11,$22,$11,$11,$00,$11,$22,$11,$11,$11,$11,$11,$11,$11,$00,$11,$11,$11,$11,$11,$11,$22,$11,$11
  .byte $11,$11,$11,$00,$00,$11
metatile_table_top_left_tiles:
  .byte $02,$1d,$76,$9f,$2a,$17,$04,$30,$0a,$01,$59,$21,$40,$0a,$19,$70,$8c,$00,$1f,$9e,$36,$1d,$59,$17
  .byte $88,$72,$9a,$09,$1b,$84
metatile_table_top_right_tiles:
  .byte $03,$1e,$77,$9e,$2b,$18,$05,$31,$0b,$08,$5a,$22,$41,$0b,$1a,$71,$8d,$01,$20,$9e,$37,$1e,$5a,$18
  .byte $89,$73,$9b,$09,$1c,$85
metatile_table_bottom_left_tiles:
  .byte $10,$27,$80,$09,$2c,$0c,$11,$34,$2e,$13,$6e,$0f,$4d,$15,$23,$7a,$98,$0c,$28,$09,$38,$27,$6e,$5b
  .byte $94,$7c,$90,$09,$25,$90
metatile_table_bottom_right_tiles:
  .byte $0f,$12,$81,$09,$2d,$0f,$12,$35,$2f,$14,$6f,$14,$4e,$16,$24,$7b,$99,$0d,$29,$09,$39,$12,$6f,$5c
  .byte $95,$7d,$91,$09,$26,$91
big_metatile_table_top_left:
  .byte $1b,$15,$01,$12,$1d,$0e,$1d,$12,$01,$19,$1b,$08,$05,$0e,$1b,$1d,$1b,$12,$01,$1d,$1d,$1b,$12,$0e
  .byte $14,$1b,$12,$1d,$12,$0f,$05,$12,$1d,$19,$12,$19,$0f,$19,$1b,$0d,$04,$1b,$16
big_metatile_table_top_right:
  .byte $1b,$12,$12,$12,$0a,$0e,$1a,$0d,$12,$14,$1b,$12,$12,$01,$1b,$1d,$1b,$08,$0e,$10,$1a,$1b,$12,$04
  .byte $19,$1b,$12,$1d,$01,$1d,$12,$0b,$1d,$02,$01,$19,$19,$19,$1b,$12,$0e,$1b,$1d
big_metatile_table_bottom_left:
  .byte $00,$01,$01,$0e,$03,$0e,$13,$12,$01,$1d,$00,$07,$17,$0e,$1b,$13,$00,$12,$01,$03,$03,$0d,$0e,$0e
  .byte $0c,$11,$1c,$03,$0e,$03,$05,$12,$03,$1d,$12,$1d,$0f,$1d,$06,$0d,$1c,$00,$03
big_metatile_table_bottom_right:
  .byte $00,$0e,$12,$1c,$03,$0e,$03,$0d,$0e,$0c,$09,$12,$12,$01,$1b,$03,$06,$07,$0e,$03,$03,$00,$0e,$1c
  .byte $1d,$00,$0e,$13,$01,$03,$12,$0b,$03,$10,$01,$18,$1d,$1d,$00,$12,$0e,$0d,$03
map:
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$19,$26,$00,$26,$10,$00,$10
  .byte $15,$00,$00,$00,$00,$00,$00,$29,$15,$26,$00,$26,$10,$00,$10,$0a,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$1e,$01,$1a,$02,$22,$03,$1c,$27,$03,$16,$1a,$03,$16,$1a,$07,$27,$08,$1a,$02,$22,$03,$1c,$1f
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0c,$12,$28,$02,$22,$17,$0d,$0b,$17,$05,$28,$17,$05,$28,$11
  .byte $0b,$12,$28,$02,$22,$17,$0d,$1f,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$24,$25,$25,$25,$25,$25,$25
  .byte $18,$25,$25,$25,$25,$25,$25,$09,$18,$25,$23,$23,$25,$25,$25,$21,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$1d,$20,$20,$0f,$20,$1b,$20,$2a,$1b,$20,$20,$20,$20,$0f,$04,$2a,$20,$06,$14,$1b,$20,$20,$13
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
