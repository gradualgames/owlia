.linecont +
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations \
    village_area_house1_entrance_location, \
    village_area_west_entrance_location, \
    house1_area_exit_location, \
    overworld_area_entrance_location

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Location definitions.
;****************************************************************
village_area_house1_entrance_location:
define_location area_index_village, 8, 6, 128, 136, sfx_door, 3, soundeffect_one, WalkDown, %00000000

village_area_west_entrance_location:
define_location area_index_village, 0, 0, 16, 136, 0, 0, 0, WalkSide, %00000000

house1_area_exit_location:
define_location area_index_house, 0, 4, 128, 136, sfx_door, 3, soundeffect_one, WalkUp, %00000000

overworld_area_entrance_location:
define_location area_index_overworld, 48, 0, 224, 96, 0, 0, 0, WalkSide, %01000000
