.include "zp.inc"

.segment "ZEROPAGE"

b0: .res 1
b1: .res 1
b2: .res 1
b3: .res 1
b4: .res 1
b5: .res 1
b6: .res 1
b7: .res 1
b8: .res 1
b9: .res 1
b10: .res 1
b11: .res 1

w0:  .res 2
w1:  .res 2
w2:  .res 2
w3:  .res 2
w4:  .res 2
w5:  .res 2
w6:  .res 2
w7:  .res 2
w8:  .res 2
w9:  .res 2
w10: .res 2
w11: .res 2
w12: .res 2
w13: .res 2
w14: .res 2
w15: .res 2
w16: .res 2
w17: .res 2
w18: .res 2
w19: .res 2
w20: .res 2

map_address: .res 2
metatile_table_properties_address:         .res 2
metatile_table_params_address:             .res 2
metatile_table_attributes_address:         .res 2
metatile_table_top_left_tiles_address:     .res 2
metatile_table_top_right_tiles_address:    .res 2
metatile_table_bottom_left_tiles_address:  .res 2
metatile_table_bottom_right_tiles_address: .res 2
big_metatile_table_top_left_address: .res 2
big_metatile_table_top_right_address: .res 2
big_metatile_table_bottom_left_address: .res 2
big_metatile_table_bottom_right_address: .res 2

area_address: .res 2
location_address: .res 2
entity_set_address: .res 2
palette_address: .res 2

current_bank: .res 1

vblank_routine: .res 2
vblank_wait_flag: .res 1
forward_to_default_graphics_hiding_routine: .res 1
graphics_hiding_routine: .res 2
hide_graphics_top: .res 1
cycle_pad_lut_index: .res 1
