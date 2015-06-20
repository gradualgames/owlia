.ifndef LOCATIONS_INC
LOCATIONS_INC = 1

LOCATIONS_BANK = 0

LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET  = %00000001
LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_TEST = %00000001
LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET  = %00000010
LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_TEST = %00000010

;Use this to test whether both X and Y scrolling are disabled
;Note that AND should be used to isolate the bits and then CMP
;to test whether both bits are set.
LOCATION_FLAGS_CAMERA_SCROLLING_DISABLED_TEST   = %00000011

;Use this to isolate the bits of the brightness level for this
;location. We use 3 bits because we have 5 different brightness
;levels.
LOCATION_FLAGS_BRIGHTNESS_LEVEL_ISOLATE         = %00011100

LOCATION_FLAGS_DUNGEON_ENTRANCE                 = %00100000

;Use these to set the brightness level in a location definition.
LOCATION_BRIGHTNESS_LEVEL_0 = %00000000
LOCATION_BRIGHTNESS_LEVEL_1 = %00000100
LOCATION_BRIGHTNESS_LEVEL_2 = %00001000
LOCATION_BRIGHTNESS_LEVEL_3 = %00001100
LOCATION_BRIGHTNESS_LEVEL_4 = %00010000

.struct location
  flags .byte
  area_index .byte
  sprite_chr_groups_address .word
  entity_instances_address .word
  palette_address .word
  nametable_start_hibyte .byte
  camera_start_x .word
  camera_start_y .word
  camera_start_scroll_x .byte
  camera_start_scroll_y .byte
  hero_start_x .word
  hero_start_y .word
  on_enter_sfx_address .word
  on_enter_sfx_channel .byte
  on_enter_sfx_stream  .byte
  hero_direction .byte
.endstruct

.macro define_location flags, area_index, entity_set_address, entity_instances_address, palette_address, camera_start_x, camera_start_y, hero_start_x, hero_start_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte flags                                   ;flags      .byte
  .byte area_index                              ;area_index .byte
  .word entity_set_address                      ;entity_set_address .word
  .word entity_instances_address                ;entity_instances_address .word
  .word palette_address                         ;palette_address .word
  .byte $20 | ((>(16*camera_start_x) & 1) << 2) ;nametable_start_hibyte .byte
  .word (16*camera_start_x)                     ;camera_start_x .word
  .word (16*camera_start_y)                     ;camera_start_y .word
  .byte <(16*camera_start_x)                    ;camera_start_scroll_x .byte
  .byte (224 + (16*camera_start_y)) .MOD 240    ;camera_start_scroll_y .byte
  .word (hero_start_x*16)                       ;hero_start_x .word
  .word (hero_start_y*16)                       ;hero_start_y .word
  .word sfx_address                             ;on_enter_sfx_address .word
  .byte sfx_channel                             ;on_enter_sfx_channel .byte
  .byte sfx_stream                              ;on_enter_sfx_stream  .byte
  .byte hero_direction                          ;hero_direction .byte
.endmacro

.macro define_centered_location flags, area_index, entity_set_address, entity_instances_address, palette_address, hero_start_x, hero_start_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte flags                                       ;flags      .byte
  .byte area_index                                  ;area_index .byte
  .word entity_set_address                          ;entity_set_address .word
  .word entity_instances_address                    ;entity_instances_address .word
  .word palette_address                             ;palette_address .word
  .byte $20 | ((>(16*(hero_start_x-8)) & 1) << 2)   ;nametable_start_hibyte .byte
  .word (16*(hero_start_x-8))                       ;camera_start_x .word
  .word (16*(hero_start_y-7))                       ;camera_start_y .word
  .byte <(16*(hero_start_x-8))                      ;camera_start_scroll_x .byte
  .byte (224 + (16*(hero_start_y-7))) .MOD 240      ;camera_start_scroll_y .byte
  .word (16*(hero_start_x-8)+128)                   ;hero_start_x .word
  .word (16*(hero_start_y-7)+96)                    ;hero_start_y .word
  .word sfx_address                                 ;on_enter_sfx_address .word
  .byte sfx_channel                                 ;on_enter_sfx_channel .byte
  .byte sfx_stream                                  ;on_enter_sfx_stream  .byte
  .byte hero_direction                              ;hero_direction .byte
.endmacro

.macro define_south_location flags, area_index, entity_set_address, entity_instances_address, palette_address, hero_start_x, hero_start_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte flags                                       ;flags      .byte
  .byte area_index                                  ;area_index .byte
  .word entity_set_address                          ;entity_set_address .word
  .word entity_instances_address                    ;entity_instances_address .word
  .word palette_address                             ;palette_address .word
  .byte $20 | ((>(16*(hero_start_x-8)) & 1) << 2)   ;nametable_start_hibyte .byte
  .word (16*(hero_start_x-8))                       ;camera_start_x .word
  .word (16*(hero_start_y-12))                      ;camera_start_y .word
  .byte <(16*(hero_start_x-8))                      ;camera_start_scroll_x .byte
  .byte (224 + (16*(hero_start_y-12))) .MOD 240     ;camera_start_scroll_y .byte
  .word (16*hero_start_x)                           ;hero_start_x .word
  .word (16*(hero_start_y-1))                       ;hero_start_y .word
  .word sfx_address                                 ;on_enter_sfx_address .word
  .byte sfx_channel                                 ;on_enter_sfx_channel .byte
  .byte sfx_stream                                  ;on_enter_sfx_stream  .byte
  .byte hero_direction                              ;hero_direction .byte
.endmacro

.macro define_north_location flags, area_index, entity_set_address, entity_instances_address, palette_address, hero_start_x, hero_start_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte flags                                       ;flags      .byte
  .byte area_index                                  ;area_index .byte
  .word entity_set_address                          ;entity_set_address .word
  .word entity_instances_address                    ;entity_instances_address .word
  .word palette_address                             ;palette_address .word
  .byte $20 | ((>(16*(hero_start_x-8)) & 1) << 2)   ;nametable_start_hibyte .byte
  .word (16*(hero_start_x-8))                       ;camera_start_x .word
  .word (16*(hero_start_y-1))                       ;camera_start_y .word
  .byte <(16*(hero_start_x-8))                      ;camera_start_scroll_x .byte
  .byte (224 + (16*(hero_start_y-1))) .MOD 240      ;camera_start_scroll_y .byte
  .word (16*(hero_start_x))                         ;hero_start_x .word
  .word (16*(hero_start_y-1))                       ;hero_start_y .word
  .word sfx_address                                 ;on_enter_sfx_address .word
  .byte sfx_channel                                 ;on_enter_sfx_channel .byte
  .byte sfx_stream                                  ;on_enter_sfx_stream  .byte
  .byte hero_direction                              ;hero_direction .byte
.endmacro

;****************************************************************
;Location LUTs
;****************************************************************
.global locations_lo
.global locations_hi

;****************************************************************
;Location definitions
;****************************************************************
.global village_area_house1_entrance_location
.global house1_exit_location

;****************************************************************
;Constants for names of locations, to make it easy to tie things
;together in the source code
;****************************************************************
.enum
location_index_village_house1_entrance
location_index_village_housel_entrance
location_index_village_houser_entrance
location_index_village_housebl_entrance
location_index_village_housebr_entrance
location_index_village_housetr_entrance
location_index_village_bottom_entrance
location_index_house1_intro
location_index_house1_exit
location_index_housel_exit
location_index_houser_exit
location_index_housebl_exit
location_index_housebr_exit
location_index_housetr_exit
location_index_meadow1_top_entrance
location_index_meadow1_west_entrance
location_index_meadow2_north_entrance
location_index_meadow2_east_entrance
location_index_meadow3_southwest_entrance
location_index_meadow3_dungeon_entrance
location_index_dungeon_0_0_s
location_index_dungeon_0_0_e
location_index_dungeon_1_0_w
location_index_dungeon_1_0_e
location_index_dungeon_2_0_w
location_index_dungeon_2_0_e
location_index_dungeon_3_0_w
location_index_dungeon_3_0_n
location_index_dungeon_0_1_n
location_index_dungeon_0_1_e
location_index_dungeon_0_1_s
location_index_dungeon_1_1_w
location_index_dungeon_1_1_e
location_index_dungeon_2_1_w
location_index_dungeon_2_1_e
location_index_dungeon_3_1_w
location_index_dungeon_3_1_s
location_index_dungeon_0_2_n
location_index_dungeon_0_2_s
location_index_dungeon_1_2_s
location_index_dungeon_1_2_e
location_index_dungeon_2_2_w
location_index_dungeon_2_2_e
location_index_dungeon_3_2_w
location_index_dungeon_3_2_n
location_index_dungeon_0_3_n
location_index_dungeon_0_3_s
location_index_dungeon_1_3_n
location_index_dungeon_1_3_e
location_index_dungeon_2_3_w
location_index_dungeon_2_3_s
location_index_dungeon_2_3_e
location_index_dungeon_3_3_w
location_index_dungeon1_boss_entrance
location_index_dungeon1_boss_area_east_exit
location_index_dungeon1_boss_area_owl_dungeon
location_index_tundra1_entrance
location_index_tundra1_north_entrance
location_index_tundra1_south_entrance
location_index_tundra2_south_entrance
location_index_tundra3_north_entrance
location_index_tundra3_dungeon2_entrance
location_index_dungeon2_0_0_s
location_index_dungeon2_0_0_e
location_index_dungeon2_1_0_s
location_index_dungeon2_1_0_w
location_index_dungeon2_2_0_n
location_index_dungeon2_2_0_e
location_index_dungeon2_3_0_s
location_index_dungeon2_3_0_w
location_index_dungeon2_0_1_n
location_index_dungeon2_1_1_n
location_index_dungeon2_1_1_s
location_index_dungeon2_1_1_e
location_index_dungeon2_2_1_w
location_index_dungeon2_3_1_n
location_index_dungeon2_3_1_s
location_index_dungeon2_0_2_s
location_index_dungeon2_0_2_e
location_index_dungeon2_1_2_n
location_index_dungeon2_1_2_e
location_index_dungeon2_1_2_w
location_index_dungeon2_2_2_s
location_index_dungeon2_2_2_w
location_index_dungeon2_3_2_n
location_index_dungeon2_3_2_s
location_index_dungeon2_0_3_n
location_index_dungeon2_0_3_e
location_index_dungeon2_1_3_w
location_index_dungeon2_2_3_n
location_index_dungeon2_2_3_s
location_index_dungeon2_2_3_e
location_index_dungeon2_3_3_n
location_index_dungeon2_3_3_w
location_index_dungeon2_boss_entrance
location_index_dungeon2_boss_east_exit
location_index_dungeon2_boss_owl_dungeon
location_index_mountain1_south_entrance
location_index_mountain1_dungeon3_entrance
location_index_mountain1_top_left_cave_entrance
location_index_mountain1_bottom_left_cave_entrance
location_index_mountain1_bottom_right_cave_entrance
location_index_cave_top_left
location_index_cave_bottom_left
location_index_cave_bottom_right
location_index_dungeon3_entrance
location_index_dungeon3_0_0_s
location_index_dungeon3_0_0_e
location_index_dungeon3_1_0_s
location_index_dungeon3_1_0_e
location_index_dungeon3_1_0_w
location_index_dungeon3_2_0_e
location_index_dungeon3_2_0_w
location_index_dungeon3_3_0_s
location_index_dungeon3_3_0_w
location_index_dungeon3_0_1_n
location_index_dungeon3_0_1_s
location_index_dungeon3_1_1_n
location_index_dungeon3_1_1_e
location_index_dungeon3_2_1_s
location_index_dungeon3_2_1_w
location_index_dungeon3_3_1_n
location_index_dungeon3_3_1_s
location_index_dungeon3_0_2_n
location_index_dungeon3_0_2_e
location_index_dungeon3_1_2_s
location_index_dungeon3_1_2_w
location_index_dungeon3_2_2_n
location_index_dungeon3_3_2_n
location_index_dungeon3_3_2_s
location_index_dungeon3_0_3_e
location_index_dungeon3_1_3_n
location_index_dungeon3_1_3_e
location_index_dungeon3_1_3_w
location_index_dungeon3_2_3_w
location_index_dungeon3_3_3_n
location_index_dungeon3_3_3_e
location_index_dungeon3_boss_entrance
location_index_dungeon3_boss_owl_dungeon
location_index_island1_entrance
location_index_island1_north_exit
location_index_island2_entrance
location_index_island2_north_exit
location_index_temple1_entrance
location_index_temple1_dungeon4_entrance
location_index_dungeon4_entrance
location_index_dungeon4_0_0_s
location_index_dungeon4_0_0_e
location_index_dungeon4_0_1_e
location_index_dungeon4_1_0_s
location_index_dungeon4_1_0_e
location_index_dungeon4_1_0_w
location_index_dungeon4_2_0_e
location_index_dungeon4_2_0_w
location_index_dungeon4_3_0_s
location_index_dungeon4_3_0_w
location_index_dungeon4_1_1_n
location_index_dungeon4_1_1_s
location_index_dungeon4_1_1_e
location_index_dungeon4_1_1_w
location_index_dungeon4_2_1_w
location_index_dungeon4_3_1_n
location_index_dungeon4_0_2_e
location_index_dungeon4_1_2_n
location_index_dungeon4_1_2_e
location_index_dungeon4_1_2_w
location_index_dungeon4_2_2_s
location_index_dungeon4_2_2_e
location_index_dungeon4_2_2_w
location_index_dungeon4_3_2_w
location_index_dungeon4_0_3_e
location_index_dungeon4_1_3_e
location_index_dungeon4_1_3_w
location_index_dungeon4_2_3_n
location_index_dungeon4_2_3_e
location_index_dungeon4_2_3_w
location_index_dungeon4_3_3_w
location_index_dungeon4_boss_area_entrance
location_index_dungeon4_boss_area_owl_dungeon
location_index_piratebay_entrance
location_index_piratebay_piratetavern_entrance1
location_index_piratebay_pirateshootinggallery_entrance1
location_index_piratebay_piratetavern_entrance2
location_index_piratetavern_entrance1
location_index_piratetavern_entrance2
location_index_pirateshootinggallery_entrance1
location_index_submarine_entrance
location_index_submarine_kraken_room_east
location_index_submarine_rescueowl_room_east
location_index_tortoise_entrance
location_index_tortoise_23_7
location_index_tortoise_23_11
location_index_tortoise_19_22
location_index_tortoise_7_29
location_index_tortoise_19_62
location_index_tortoise_31_33
location_index_tortoise_39_33
location_index_tortoise_39_29
location_index_tortoise_55_55
.endenum

;****************************************************************
;These constants define flags for dungeon state, per dungeon.
;The 8 bits in inventory_dungeon_flags will be modified/checked
;using these bits, per dungeon, to keep track of solved puzzles,
;unlocked doors, or obtained treasure.
;****************************************************************
DUNGEON1_DUNGEON_FLAGS_SINGLE_ANGLERFISH_COMPLETE = %00000001
DUNGEON1_DUNGEON_FLAGS_TWIN_ANGLERFISH_COMPLETE   = %00000010
DUNGEON1_DUNGEON_FLAGS_DOOR1_UNLOCKED             = %00000100
DUNGEON1_DUNGEON_FLAGS_DOOR2_UNLOCKED             = %00001000
DUNGEON1_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED    = %00010000
DUNGEON1_DUNGEON_FLAGS_TREASURE_CHEST1_OBTAINED   = %00100000

DUNGEON2_DUNGEON_FLAGS_JELLYFISH_URCHIN_EEL_PUZZLE_COMPLETE = %00000001
DUNGEON2_DUNGEON_FLAGS_TWO_ICE_BLOCKS_PUZZLE_COMPLETE       = %00000010
DUNGEON2_DUNGEON_FLAGS_DOOR1_UNLOCKED                       = %00000100
DUNGEON2_DUNGEON_FLAGS_DOOR2_UNLOCKED                       = %00001000
DUNGEON2_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED              = %00010000
DUNGEON2_DUNGEON_FLAGS_TREASURE_ROOM2_OBTAINED              = %00100000

DUNGEON3_DUNGEON_FLAGS_MONOLITH_PUZZLE_COMPLETE                       = %00000001
DUNGEON3_DUNGEON_FLAGS_TRIPLE_ANGLERFISH_PUZZLE_COMPLETE              = %00000010
DUNGEON3_DUNGEON_FLAGS_SEAHORSE_HORSESHOE_CRAB_URCHIN_PUZZLE_COMPLETE = %00000100
DUNGEON3_DUNGEON_FLAGS_DOOR1_UNLOCKED                                 = %00001000
DUNGEON3_DUNGEON_FLAGS_DOOR2_UNLOCKED                                 = %00010000
DUNGEON3_DUNGEON_FLAGS_DOOR3_UNLOCKED                                 = %00100000
DUNGEON3_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED                        = %01000000
DUNGEON3_DUNGEON_FLAGS_MONOLITH_PUZZLE2_COMPLETE                      = %10000000

DUNGEON4_DUNGEON_FLAGS_SWITCH_PUZZLE1_COMPLETE                  = %00000001
DUNGEON4_DUNGEON_FLAGS_SWITCH_PUZZLE2_COMPLETE                  = %00000010
DUNGEON4_DUNGEON_FLAGS_SEAHORSE_URCHIN_TUNICATE_PUZZLE_COMPLETE = %00000100
DUNGEON4_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED                  = %00001000
DUNGEON4_DUNGEON_FLAGS_MONOLITH_PUZZLE_COMPLETE                 = %00010000
DUNGEON4_DUNGEON_FLAGS_DOOR1_UNLOCKED                           = %00100000
DUNGEON4_DUNGEON_FLAGS_DOOR2_UNLOCKED                           = %01000000
DUNGEON4_DUNGEON_FLAGS_DOOR3_UNLOCKED                           = %10000000

.endif
