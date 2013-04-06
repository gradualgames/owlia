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
    village_house1_entrance, \
    village_inn_entrance, \
    village_weaponstore_entrance, \
    village_potionstore_entrance, \
    village_housebl_entrance, \
    village_housebr_entrance, \
    village_housetr_entrance, \
    village_bottom_entrance, \
    house1_exit, \
    inn_exit, \
    weaponstore_exit, \
    potionstore_exit, \
    housebl_exit, \
    housebr_exit, \
    housetr_exit, \
    overworld_top_entrance, \
    overworld_dungeon_entrance, \
    dungeon_entrance, \
    dungeon_room_a, \
    dungeon_room_b

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

.segment "ROM02"

;****************************************************************
;Location definitions.
;****************************************************************

;village locations
village_house1_entrance:
define_centered_location 0, area_index_village, 11, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_inn_entrance:
define_centered_location 0, area_index_village, 11, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_weaponstore_entrance:
define_centered_location 0, area_index_village, 54, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_potionstore_entrance:
define_centered_location 0, area_index_village, 51, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housebl_entrance:
define_centered_location 0, area_index_village, 11, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housebr_entrance:
define_centered_location 0, area_index_village, 51, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housetr_entrance:
define_centered_location 0, area_index_village, 51, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_bottom_entrance:
define_south_location 0, area_index_village, 31, 62, 0, 0, 0, HERO_DIRECTION_UP

;house1 locations
house1_exit:
define_centered_location 0, area_index_house, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;inn locations
inn_exit:
define_centered_location 0, area_index_inn, 25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;store locations
weaponstore_exit:
define_centered_location 0, area_index_store, 25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

potionstore_exit:
define_centered_location 0, area_index_store, 13, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housebl locations
housebl_exit:
define_centered_location 0, area_index_housebl, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housebr locations
housebr_exit:
define_centered_location 0, area_index_housebr, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housetr locations
housetr_exit:
define_centered_location 0, area_index_housetr, 14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;overworld locations
overworld_top_entrance:
define_north_location 0, area_index_overworld, 27, 1, 0, 0, 0, HERO_DIRECTION_DOWN

overworld_dungeon_entrance:
define_centered_location 0, area_index_overworld, 30, 13, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

;dungeon locations
dungeon_entrance:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET, \
                area_index_dungeon, 0, 0, 7, 9, \
                sfx_door, 3, soundeffect_one,\
                HERO_DIRECTION_UP

dungeon_room_a:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET, \
                area_index_dungeon, 0, 0, 7, 2, \
                0, 0, 0, \
                HERO_DIRECTION_DOWN

dungeon_room_b:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET, \
                area_index_dungeon, 16, 0, 23, 10, \
                0, 0, 0, HERO_DIRECTION_UP
