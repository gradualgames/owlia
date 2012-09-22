.include "areas.inc"
.include "locations.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
locations_lo:
  .byte <village_area_house1_entrance_location, <house1_area_exit_location
locations_hi:
  .byte >village_area_house1_entrance_location, >house1_area_exit_location

;****************************************************************
;Location definitions.
;****************************************************************
village_area_house1_entrance_location:
.scope
START_X = 8
START_Y = 6
  .byte area_index_village
  .word (16*START_X)     ;camera_start_x .word
  .word (16*START_Y)     ;camera_start_y .word
  .byte (16*START_X)     ;camera_scroll_start_x .byte
  .byte (16*START_Y-8)     ;camera_scroll_start_y .byte
  .word (16*START_X+128)       ;hero_start_x .word
  .word (16*START_Y+128) ;hero_start_y .word
.endscope

house1_area_exit_location:
.scope
START_X = 0
START_Y = 4
  .byte area_index_house
  .word (16*START_X)     ;camera_start_x .word
  .word (16*START_Y)     ;camera_start_y .word
  .byte (16*START_X)     ;camera_scroll_start_x .byte
  .byte (16*START_Y-8)     ;camera_scroll_start_y .byte
  .word (16*START_X+128)       ;hero_start_x .word
  .word (16*START_Y+128) ;hero_start_y .word
.endscope
