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
b12: .res 1
b13: .res 1
b14: .res 1
b15: .res 1

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

;****************************************************************
;These variables keep track of the state of various PPU registers
;at runtime. Using variables in RAM for this make it easier to
;twiddle individual bits and then upload the entire byte
;preserving state of flags we already set.
;****************************************************************
ppu_2000: .res 1
ppu_2001: .res 1
ppu_2005: .res 2
ppu_2006: .res 2

rand: .res 1

spawned_entity: .res 1

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
sprite_chr_groups_address: .res 2
palette_bank: .res 1
palette_address: .res 2
palette_cycling_offset: .res 1

processor_status: .res 1
current_bank: .res 1
next_bank: .res 1
far_call_address: .res 2
far_load_address: .res 2
far_load_result: .res 1

controller_routine: .res 2

vblank_routine: .res 2
vblank_done_flag: .res 1
palette_cycling_enabled: .res 1
hide_graphics_top: .res 1
cycle_pad_lut_index: .res 1
