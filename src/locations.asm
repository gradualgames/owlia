.linecont +
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"
.include "hero_constants.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations \
    village_area_house1_entrance_location, \
    house1_area_exit_location, \
    village_area_inn_entrance_location, \
    inn_area_exit_location, \
    village_area_west_entrance_location, \
    overworld_area_entrance_location

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Location definitions.
;****************************************************************
village_area_house1_entrance_location:
define_location area_index_village, 3, 5, 128, 136, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

house1_area_exit_location:
define_location area_index_house, 7, 15, 128, 136, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_inn_entrance_location:
define_location area_index_village, 3, 26, 128, 136, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

inn_area_exit_location:
define_location area_index_inn, 17, 15, 128, 136, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_west_entrance_location:
define_location area_index_village, 0, 0, 16, 136, 0, 0, 0, HERO_DIRECTION_RIGHT

overworld_area_entrance_location:
define_location area_index_overworld, 48, 0, 224, 96, 0, 0, 0, HERO_DIRECTION_LEFT
