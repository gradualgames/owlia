.ifndef LOCATIONS_INC
LOCATIONS_INC = 1

.struct location
  area_index .byte
  camera_start_x .word
  camera_start_y .word
  camera_start_scroll_x .byte
  camera_start_scroll_y .byte
  hero_start_x .word
  hero_start_y .word
.endstruct

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
location_index_village_house1_entrance = 0
location_index_house1_exit = 1

.endif
