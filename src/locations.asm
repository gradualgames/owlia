.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations village_area_house1_entrance_location, house1_area_exit_location, overworld_area_entrance_location

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Location definitions.
;****************************************************************
village_area_house1_entrance_location:
define_location area_index_village, 8, 6, 128, 136, sfx_door, 3, soundeffect_one

house1_area_exit_location:
define_location area_index_house, 0, 4, 128, 136, sfx_door, 3, soundeffect_one

overworld_area_entrance_location:
define_location area_index_overworld, 48, 0, 240, 24, 0, 0, 0
