house1_palette = palette
house1_metatile_table_properties = metatile_table_properties
house1_metatile_table_params = metatile_table_params
house1_metatile_table_attributes = metatile_table_attributes
house1_metatile_table_top_left_tiles = metatile_table_top_left_tiles
house1_metatile_table_top_right_tiles = metatile_table_top_right_tiles
house1_metatile_table_bottom_left_tiles = metatile_table_bottom_left_tiles
house1_metatile_table_bottom_right_tiles = metatile_table_bottom_right_tiles
house1_big_metatile_table_top_left = big_metatile_table_top_left
house1_big_metatile_table_top_right = big_metatile_table_top_right
house1_big_metatile_table_bottom_left = big_metatile_table_bottom_left
house1_big_metatile_table_bottom_right = big_metatile_table_bottom_right
house1_map = map

palette:
  .byte $0d,$07,$27,$37,$0d,$1b,$2b,$37,$0d,$0d,$10,$20,$00,$00,$00,$00
  .byte $0d,$0d,$14,$35,$0d,$00,$00,$00,$0d,$00,$00,$00,$0d,$00,$00,$00

metatile_table_properties:
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
.byte ($00 | ACTION_NOP)
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


metatile_table_attributes:
  .byte $00,$00,$00,$00,$11,$22,$00,$00,$00,$00,$00,$00,$11,$11,$22,$00,$00,$00,$22,$00,$11,$22,$22,$11,$22,$22

metatile_table_top_left_tiles:
  .byte $00,$02,$03,$02,$04,$06,$02,$03,$02,$0d,$0e,$0e,$02,$15,$16,$02,$12,$13,$0e,$00,$1d,$0e,$0e,$15,$0e,$0e

metatile_table_top_right_tiles:
  .byte $01,$03,$03,$02,$05,$07,$03,$03,$0c,$0c,$0e,$0f,$14,$14,$17,$11,$11,$13,$1a,$01,$1e,$0e,$0f,$14,$0e,$0f

metatile_table_bottom_left_tiles:
  .byte $00,$02,$03,$02,$08,$0a,$02,$10,$02,$12,$13,$13,$02,$14,$18,$02,$12,$13,$1b,$03,$1f,$0e,$0e,$02,$21,$22

metatile_table_bottom_right_tiles:
  .byte $01,$03,$03,$02,$09,$0b,$10,$10,$11,$11,$13,$13,$15,$15,$19,$11,$11,$13,$1c,$03,$20,$0e,$0f,$15,$22,$23

big_metatile_table_top_left:
  .byte $03,$03,$03,$03,$00,$04,$00,$05,$02,$02,$00,$0d,$00,$10,$11,$11,$0d,$13,$0d,$14,$0d,$0d,$18,$0c,$00,$0d,$0d,$0d,$0d

big_metatile_table_top_right:
  .byte $03,$03,$03,$03,$01,$02,$01,$05,$02,$00,$0c,$0e,$0f,$10,$03,$00,$13,$0c,$0d,$14,$00,$0d,$19,$00,$0c,$0d,$0d,$0d,$00

big_metatile_table_bottom_left:
  .byte $03,$00,$02,$02,$00,$07,$00,$09,$0a,$0b,$00,$0d,$00,$0d,$0d,$0d,$0d,$07,$0d,$15,$17,$0d,$0d,$0d,$13,$13,$13,$0d,$13

big_metatile_table_bottom_right:
  .byte $03,$01,$02,$00,$06,$07,$08,$09,$0a,$00,$0c,$12,$0c,$0d,$0d,$00,$07,$0c,$14,$16,$00,$0d,$0d,$00,$13,$13,$17,$13,$13

map:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$01,$02,$02,$02,$02,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$04,$05,$06,$07,$08,$09,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$0a,$0b,$0c,$0d,$0e,$0f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$0a,$10,$11,$12,$13,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$0a,$15,$15,$15,$16,$17,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$18,$19,$1a,$1b,$19,$1c,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

