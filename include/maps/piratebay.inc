metatile_table_properties:
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($10 | ACTION_NOP)
  .byte ($00 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($00 | ACTION_NOP)
  .byte ($30 | ACTION_NOP)
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
  .byte ($10 | ACTION_GOTO_LOCATION_GROUP1)
  .byte ($00 | ACTION_NOP)
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
  .byte location_index_pirateshootinggallery_entrance1
  .byte location_index_piratetavern_entrance1
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte location_index_submarine_entrance
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
  .byte location_index_piratetavern_entrance2
  .byte $00
  .byte $00
  .byte $00
  .byte $00
metatile_table_attributes:
  .byte $00,$33,$22,$00,$00,$00,$22,$22,$33,$22,$33,$00,$22,$00,$33,$00,$00,$33,$11,$33,$00,$00,$22,$33
  .byte $00,$22,$00,$00,$11,$00,$00,$22,$22,$22,$33,$33,$00,$22,$00,$33,$33,$33
metatile_table_top_left_tiles:
  .byte $6a,$48,$1f,$7b,$62,$05,$21,$21,$5a,$15,$28,$2d,$02,$2d,$07,$44,$46,$5a,$09,$2f,$4a,$6c,$15,$5d
  .byte $79,$15,$4c,$2b,$09,$05,$42,$15,$02,$29,$71,$73,$64,$21,$33,$07,$1d,$1a
metatile_table_top_right_tiles:
  .byte $6b,$49,$20,$7c,$63,$06,$22,$22,$5c,$0c,$1d,$2e,$04,$2e,$08,$45,$47,$5b,$0a,$30,$4b,$6d,$0e,$5b
  .byte $7a,$0c,$4d,$2c,$0a,$06,$43,$0e,$03,$2a,$72,$74,$65,$22,$34,$08,$1e,$1a
metatile_table_bottom_left_tiles:
  .byte $6e,$54,$24,$7f,$66,$0f,$26,$26,$5e,$18,$35,$3a,$0d,$3a,$11,$50,$52,$5e,$13,$3c,$56,$6f,$15,$61
  .byte $7d,$15,$58,$38,$13,$0f,$4e,$18,$0d,$36,$75,$77,$68,$26,$40,$11,$23,$1b
metatile_table_bottom_right_tiles:
  .byte $6f,$55,$25,$80,$67,$10,$27,$27,$60,$17,$35,$3b,$0e,$3b,$12,$51,$53,$5f,$14,$3d,$57,$70,$0e,$5f
  .byte $7e,$0c,$59,$39,$14,$10,$4f,$19,$0c,$37,$76,$78,$69,$27,$41,$12,$1d,$1c
big_metatile_table_top_left:
  .byte $06,$1d,$1c,$05,$25,$1e,$1c,$23,$28,$02,$1c,$1c,$0c,$0e,$02,$09,$23,$03,$1c,$0e,$1c,$01,$28,$0f
  .byte $1f,$1a,$23,$1e,$1e,$20,$1c,$1e,$27,$1c,$28,$07,$24
big_metatile_table_top_right:
  .byte $28,$0e,$1c,$27,$28,$1e,$22,$1c,$1d,$02,$22,$1c,$05,$1c,$28,$09,$1c,$1c,$18,$1c,$1c,$14,$02,$10
  .byte $1d,$1c,$1c,$12,$1e,$20,$1c,$1e,$1c,$04,$28,$28,$1c
big_metatile_table_bottom_left:
  .byte $21,$1d,$26,$1d,$21,$11,$1c,$22,$0a,$0a,$1c,$1c,$16,$0e,$0a,$29,$03,$1c,$1c,$0e,$13,$1c,$0a,$1c
  .byte $29,$1c,$23,$11,$11,$19,$1b,$17,$0e,$1c,$0a,$21,$15
big_metatile_table_bottom_right:
  .byte $0a,$0e,$1c,$0e,$0a,$08,$22,$1c,$1d,$0a,$18,$1c,$1d,$1c,$0a,$29,$1c,$1c,$1c,$12,$0d,$1c,$0a,$1c
  .byte $1d,$1c,$1c,$1c,$11,$19,$0b,$11,$1c,$00,$0a,$0a,$1c
map:
  .byte $0b,$03,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d,$1d
  .byte $1d,$1d,$1d,$0c,$20,$0b,$0b,$0b,$0b,$01,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f
  .byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$18,$0d,$0b,$0b,$0b,$0b,$01,$22,$09,$0e,$23,$16,$22
  .byte $22,$09,$0e,$22,$16,$22,$00,$09,$0e,$22,$16,$22,$22,$09,$0e,$22,$16,$22,$04,$08,$13,$1e,$14,$02
  .byte $0b,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05,$1f,$05
  .byte $1f,$05,$1f,$1c,$1b,$17,$15,$19,$0b,$21,$24,$21,$24,$21,$24,$21,$24,$21,$24,$21,$24,$21,$24,$21
  .byte $24,$21,$24,$21,$24,$21,$24,$21,$24,$21,$24,$21,$24,$0b,$0b,$0b,$0b,$06,$1a,$06,$1a,$0a,$10,$0a
  .byte $10,$06,$1a,$0a,$10,$06,$1a,$06,$1a,$06,$1a,$0a,$10,$0a,$10,$0a,$10,$0a,$10,$0a,$10,$0b,$0b,$0b
  .byte $0b,$06,$1a,$0a,$10,$0b,$0b,$0b,$0b,$12,$11,$0b,$0b,$06,$07,$0a,$10,$12,$11,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$06,$1a,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$06,$1a,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0a,$10,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0a,$10,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
