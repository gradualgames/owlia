.ifndef LOCATIONS_INC
LOCATIONS_INC = 1

.struct location
  area_index .byte
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

.macro define_location area_index, camera_start_x, camera_start_y, hero_offset_x, hero_offset_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte area_index                              ;area_index .byte
  .byte $20 | ((>(16*camera_start_x) & 1) << 2) ;nametable_start_hibyte .byte
  .word (16*camera_start_x)                     ;camera_start_x .word
  .word (16*camera_start_y)                     ;camera_start_y .word
  .byte <(16*camera_start_x)                    ;camera_start_scroll_x .byte
  .byte (232 + (16*camera_start_y)) .MOD 240    ;camera_start_scroll_y .byte
  .word (16*camera_start_x+hero_offset_x)       ;hero_start_x .word
  .word (16*camera_start_y+hero_offset_y)       ;hero_start_y .word
  .word sfx_address                             ;on_enter_sfx_address .word
  .byte sfx_channel                             ;on_enter_sfx_channel .byte
  .byte sfx_stream                              ;on_enter_sfx_stream  .byte
  .word hero_direction                          ;hero_direction .byte
.endmacro

.macro define_centered_location area_index, camera_start_x, camera_start_y, sfx_address, sfx_channel, sfx_stream, hero_direction
  .byte area_index                                  ;area_index .byte
  .byte $20 | ((>(16*(camera_start_x-8)) & 1) << 2) ;nametable_start_hibyte .byte
  .word (16*(camera_start_x-8))                     ;camera_start_x .word
  .word (16*(camera_start_y-7))                     ;camera_start_y .word
  .byte <(16*(camera_start_x-8))                  ;camera_start_scroll_x .byte
  .byte (232 + (16*(camera_start_y-7))) .MOD 240    ;camera_start_scroll_y .byte
  .word (16*(camera_start_x-8)+128)                 ;hero_start_x .word
  .word (16*(camera_start_y-7)+96)                  ;hero_start_y .word
  .word sfx_address                                 ;on_enter_sfx_address .word
  .byte sfx_channel                                 ;on_enter_sfx_channel .byte
  .byte sfx_stream                                  ;on_enter_sfx_stream  .byte
  .word hero_direction                              ;hero_direction .byte
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
location_index_house1_exit
location_index_village_inn_entrance
location_index_inn_exit
location_index_village_weaponstore_entrance
location_index_weaponstore_exit
location_index_village_potionstore_entrance
location_index_potionstore_exit
location_index_village_housebl_entrance
location_index_housebl_exit
location_index_village_housebr_entrance
location_index_housebr_exit
location_index_village_housetr_entrance
location_index_housetr_exit
location_index_village_west_entrance
location_index_overworld_entrance
.endenum

.endif
