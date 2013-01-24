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
    village_area_weaponstore_entrance_location, \
    weaponstore_area_exit_location, \
    village_area_potionstore_entrance_location, \
    potionstore_area_exit_location, \
    village_area_housebl_entrance_location, \
    housebl_area_exit_location, \
    village_area_housebr_entrance_location, \
    housebr_area_exit_location, \
    village_area_housetr_entrance_location, \
    housetr_area_exit_location, \
    village_area_bottom_entrance_location, \
    overworld_area_top_entrance_location

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

.segment "ROM02"

;****************************************************************
;Location definitions.
;****************************************************************
village_area_house1_entrance_location:
define_centered_location area_index_village, 11, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

house1_area_exit_location:
define_centered_location area_index_house, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_inn_entrance_location:
define_centered_location area_index_village, 11, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

inn_area_exit_location:
define_centered_location area_index_inn, 25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_weaponstore_entrance_location:
define_centered_location area_index_village, 54, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

weaponstore_area_exit_location:
define_centered_location area_index_store, 25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_potionstore_entrance_location:
define_centered_location area_index_village, 51, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

potionstore_area_exit_location:
define_centered_location area_index_store, 13, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_housebl_entrance_location:
define_centered_location area_index_village, 11, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

housebl_area_exit_location:
define_centered_location area_index_housebl, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_housebr_entrance_location:
define_centered_location area_index_village, 51, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

housebr_area_exit_location:
define_centered_location area_index_housebr, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_housetr_entrance_location:
define_centered_location area_index_village, 51, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

housetr_area_exit_location:
define_centered_location area_index_housetr, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

village_area_bottom_entrance_location:
define_south_location area_index_village, 31, 62, 0, 0, 0, HERO_DIRECTION_UP

overworld_area_top_entrance_location:
define_north_location area_index_overworld, 27, 1, 0, 0, 0, HERO_DIRECTION_DOWN
