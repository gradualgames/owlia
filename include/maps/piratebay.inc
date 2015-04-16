metatile_table_properties:
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($30 | ACTION_NOP)
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($10 | ACTION_NOP)
metatile_table_params:
  .byte $00
  .byte $00
  .byte $00
  .byte location_index_piratetavern_entrance2
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
  .byte location_index_piratetavern_entrance1
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
  .byte location_index_pirateshootinggallery_entrance1
  .byte $00
metatile_table_attributes:
  .byte $00,$33,$22,$22,$00,$00,$00,$00,$33,$22,$33,$22,$00,$22,$33,$00,$00,$33,$11,$22,$33,$00,$00,$22
  .byte $33,$00,$22,$00,$00,$11,$00,$00,$22,$22,$22,$33,$33,$00,$00,$33,$33,$22,$33
metatile_table_top_left_tiles:
  .byte $6a,$48,$1f,$21,$62,$7b,$05,$31,$5a,$15,$28,$21,$2d,$02,$07,$44,$46,$5a,$09,$21,$2f,$4a,$6c,$15
  .byte $5d,$79,$15,$4c,$2b,$09,$05,$42,$15,$02,$29,$71,$73,$64,$33,$07,$1d,$21,$1a
metatile_table_top_right_tiles:
  .byte $6b,$49,$20,$22,$63,$7c,$06,$32,$5c,$0c,$1d,$22,$2e,$04,$08,$45,$47,$5b,$0a,$22,$30,$4b,$6d,$0e
  .byte $5b,$7a,$0c,$4d,$2c,$0a,$06,$43,$0e,$03,$2a,$72,$74,$65,$34,$08,$1e,$22,$1a
metatile_table_bottom_left_tiles:
  .byte $6e,$54,$24,$26,$66,$7f,$0f,$3e,$5e,$18,$35,$26,$3a,$0d,$11,$50,$52,$5e,$13,$26,$3c,$56,$6f,$15
  .byte $61,$7d,$15,$58,$38,$13,$0f,$4e,$18,$0d,$36,$75,$77,$68,$40,$11,$23,$26,$1b
metatile_table_bottom_right_tiles:
  .byte $6f,$55,$25,$27,$67,$80,$10,$3f,$60,$17,$35,$27,$3b,$0e,$12,$51,$53,$5f,$14,$27,$3d,$57,$70,$0e
  .byte $5f,$7e,$0c,$59,$39,$14,$10,$4f,$19,$0c,$37,$76,$78,$69,$41,$12,$1d,$27,$1c
big_metatile_table_top_left:
  .byte $21,$0e,$05,$1d,$03,$02,$24,$20,$1f,$1d,$1f,$01,$25,$29,$24,$02,$27,$06,$1d,$0b,$1e,$1f,$1d,$1d
  .byte $1d,$09,$0d,$28,$1d,$28,$1b,$0e,$1f,$1d,$24,$28,$13,$0f
big_metatile_table_top_right:
  .byte $21,$1d,$1d,$1d,$28,$02,$1d,$1e,$1f,$23,$12,$15,$1d,$28,$1d,$28,$1d,$27,$1d,$28,$0e,$1f,$23,$19
  .byte $04,$09,$06,$02,$1d,$1e,$1d,$1d,$1f,$1d,$1d,$28,$28,$10
big_metatile_table_bottom_left:
  .byte $1a,$0e,$1d,$14,$22,$0a,$24,$2a,$11,$1d,$11,$1d,$16,$22,$23,$0a,$0e,$1e,$26,$22,$1e,$18,$1d,$1d
  .byte $1d,$2a,$17,$0a,$1d,$0a,$1d,$0e,$11,$1c,$05,$0a,$22,$1d
big_metatile_table_bottom_right:
  .byte $1a,$12,$1d,$07,$0a,$0a,$1d,$1e,$08,$23,$1d,$1d,$1d,$0a,$1d,$0a,$1d,$0e,$1d,$0a,$0e,$11,$19,$1d
  .byte $00,$2a,$1e,$0a,$1d,$1e,$1d,$1d,$11,$0c,$1d,$0a,$0a,$1d
map:
  .byte $1c,$11,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$1a,$10,$1c,$1c,$1c,$1c,$14,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19
  .byte $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$07,$1f,$1c,$1c,$1c,$1c,$14,$23,$05,$0f,$24,$1b,$23
  .byte $0d,$05,$0f,$04,$1b,$23,$13,$05,$0f,$13,$1b,$23,$13,$05,$0f,$13,$1b,$23,$13,$1d,$01,$21,$03,$12
  .byte $1c,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08,$15,$08
  .byte $15,$08,$15,$20,$0a,$25,$0b,$1e,$1c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18
  .byte $0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$18,$0c,$1c,$1c,$1c,$1c,$09,$06,$09,$06,$16,$22,$16
  .byte $22,$09,$06,$16,$22,$09,$06,$09,$06,$09,$06,$16,$22,$16,$22,$16,$22,$16,$22,$16,$22,$1c,$1c,$1c
  .byte $1c,$09,$06,$16,$22,$1c,$1c,$1c,$1c,$17,$02,$1c,$1c,$09,$0e,$16,$22,$17,$02,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$09,$06,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$09,$06,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$16,$22,$1c,$1c,$1c,$1c,$1c
  .byte $1c,$1c,$1c,$1c,$1c,$16,$22,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c
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
