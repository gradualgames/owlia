.ifndef ZP_INC
ZP_INC = 1

.globalzp b0
.globalzp b1
.globalzp b2
.globalzp b3
.globalzp b4
.globalzp b5
.globalzp b6
.globalzp b7
.globalzp b8
.globalzp b9
.globalzp b10
.globalzp b11
.globalzp b12
.globalzp b13
.globalzp b14
.globalzp b15

.globalzp w0
.globalzp w1
.globalzp w2
.globalzp w3
.globalzp w4
.globalzp w5
.globalzp w6
.globalzp w7
.globalzp w8
.globalzp w9
.globalzp w10
.globalzp w11
.globalzp w12
.globalzp w13
.globalzp w14
.globalzp w15
.globalzp w16
.globalzp w17
.globalzp w18
.globalzp w19
.globalzp w20

.globalzp spawned_entity

.globalzp map_address
.globalzp metatile_table_properties_address
.globalzp metatile_table_params_address
.globalzp metatile_table_attributes_address
.globalzp metatile_table_top_left_tiles_address
.globalzp metatile_table_top_right_tiles_address
.globalzp metatile_table_bottom_left_tiles_address
.globalzp metatile_table_bottom_right_tiles_address
.globalzp big_metatile_table_top_left_address
.globalzp big_metatile_table_top_right_address
.globalzp big_metatile_table_bottom_left_address
.globalzp big_metatile_table_bottom_right_address

.globalzp area_address
.globalzp location_address
.globalzp sprite_chr_groups_address
.globalzp palette_address

.globalzp processor_status
.globalzp current_bank
.globalzp next_bank
.globalzp far_call_address
.globalzp far_load_address
.globalzp far_load_result

.globalzp controller_routine

.globalzp vblank_routine
.globalzp vblank_done_flag
.globalzp forward_to_default_graphics_hiding_routine
.globalzp graphics_hiding_routine
.globalzp hide_graphics_top
.globalzp cycle_pad_lut_index

.endif
