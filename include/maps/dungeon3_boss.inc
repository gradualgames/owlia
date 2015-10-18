metatile_table_properties:
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
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
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
  .byte $11,$00,$00,$11,$11,$11,$33,$00,$11,$00,$00,$11,$00,$00,$00,$00,$00,$11,$00,$00,$11,$11,$22,$00
  .byte $00,$11,$00,$00,$00
metatile_table_top_left_tiles:
  .byte $00,$58,$56,$14,$2e,$1c,$6a,$50,$00,$65,$2c,$78,$05,$40,$5a,$52,$3e,$12,$36,$65,$1a,$16,$54,$18
  .byte $3a,$2a,$5b,$3c,$2c
metatile_table_top_right_tiles:
  .byte $02,$59,$57,$15,$2f,$1d,$6b,$51,$01,$72,$2d,$79,$06,$41,$59,$53,$3f,$13,$37,$66,$1b,$17,$55,$19
  .byte $3b,$2b,$51,$3d,$2d
metatile_table_bottom_left_tiles:
  .byte $0a,$4a,$62,$20,$34,$28,$70,$5c,$0a,$74,$32,$80,$0e,$4c,$63,$5e,$4c,$1e,$44,$6c,$26,$22,$60,$24
  .byte $48,$30,$64,$4a,$32
metatile_table_bottom_right_tiles:
  .byte $0c,$4b,$45,$21,$35,$29,$71,$5d,$0b,$75,$33,$81,$0f,$4d,$4b,$5f,$4b,$1f,$45,$6d,$27,$23,$61,$25
  .byte $49,$31,$5d,$4b,$33
big_metatile_table_top_left:
  .byte $1b,$02,$09,$07,$1a,$00,$02,$08,$08,$10,$08,$0e,$02,$0e,$08,$09,$17,$07,$09,$00,$08,$02,$02,$04
  .byte $0b,$08,$01,$16,$04,$09,$09,$10
big_metatile_table_top_right:
  .byte $10,$02,$09,$0f,$07,$08,$0e,$19,$19,$0d,$08,$0e,$02,$02,$08,$09,$09,$07,$17,$08,$08,$02,$0e,$08
  .byte $0b,$08,$02,$02,$08,$09,$17,$10
big_metatile_table_bottom_left:
  .byte $16,$02,$12,$13,$0c,$03,$02,$03,$08,$02,$08,$02,$02,$0e,$03,$10,$1c,$13,$02,$08,$08,$0e,$02,$04
  .byte $08,$05,$16,$16,$14,$10,$02,$02
big_metatile_table_bottom_right:
  .byte $02,$0e,$10,$0c,$06,$03,$0e,$15,$19,$02,$08,$02,$02,$02,$03,$18,$02,$13,$1c,$08,$11,$02,$02,$08
  .byte $08,$08,$02,$02,$03,$10,$0a,$02
map:
  .byte $14,$05,$0e,$0e,$0e,$0e,$0e,$19,$08,$00,$1f,$1f,$1f,$1f,$09,$17,$0a,$13,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$08,$11,$11,$11,$11,$11,$11,$17,$08,$1b,$01,$0b,$0b,$15,$0c,$17
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$08,$02,$1d,$1d,$1d,$1d,$0f,$17
  .byte $08,$1b,$06,$0c,$0c,$0d,$0c,$17,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $07,$1a,$0c,$0c,$0c,$0c,$16,$1c,$07,$1b,$0c,$0b,$0b,$0c,$0c,$17,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$03,$1a,$0c,$0c,$0c,$0c,$16,$04,$03,$1b,$0c,$0c,$0c,$0c,$0c,$17
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$12,$1a,$0c,$0c,$0c,$0c,$16,$10
  .byte $1e,$1b,$0c,$0c,$0c,$0c,$0c,$17,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
