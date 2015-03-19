.include "map_data.inc"
.include "map.inc"
.include "play_state.inc"
.include "areas.inc"
.include "locations.inc"

.segment "ROM13"

.scope blank_data
.include "blank.inc"
.endscope
blank_metatile_table_properties = blank_data::metatile_table_properties
blank_metatile_table_params = blank_data::metatile_table_params
blank_metatile_table_attributes = blank_data::metatile_table_attributes
blank_metatile_table_top_left_tiles = blank_data::metatile_table_top_left_tiles
blank_metatile_table_top_right_tiles = blank_data::metatile_table_top_right_tiles
blank_metatile_table_bottom_left_tiles = blank_data::metatile_table_bottom_left_tiles
blank_metatile_table_bottom_right_tiles = blank_data::metatile_table_bottom_right_tiles
blank_big_metatile_table_top_left = blank_data::big_metatile_table_top_left
blank_big_metatile_table_top_right = blank_data::big_metatile_table_top_right
blank_big_metatile_table_bottom_left = blank_data::big_metatile_table_bottom_left
blank_big_metatile_table_bottom_right = blank_data::big_metatile_table_bottom_right
blank_map = blank_data::map

.scope village_data
.include "village.inc"
.endscope
village_metatile_table_properties = village_data::metatile_table_properties
village_metatile_table_params = village_data::metatile_table_params
village_metatile_table_attributes = village_data::metatile_table_attributes
village_metatile_table_top_left_tiles = village_data::metatile_table_top_left_tiles
village_metatile_table_top_right_tiles = village_data::metatile_table_top_right_tiles
village_metatile_table_bottom_left_tiles = village_data::metatile_table_bottom_left_tiles
village_metatile_table_bottom_right_tiles = village_data::metatile_table_bottom_right_tiles
village_big_metatile_table_top_left = village_data::big_metatile_table_top_left
village_big_metatile_table_top_right = village_data::big_metatile_table_top_right
village_big_metatile_table_bottom_left = village_data::big_metatile_table_bottom_left
village_big_metatile_table_bottom_right = village_data::big_metatile_table_bottom_right
village_map = village_data::map

.scope house1_data
.include "house1.inc"
.endscope

house1_metatile_table_properties = house1_data::metatile_table_properties
house1_metatile_table_params = house1_data::metatile_table_params
house1_metatile_table_attributes = house1_data::metatile_table_attributes
house1_metatile_table_top_left_tiles = house1_data::metatile_table_top_left_tiles
house1_metatile_table_top_right_tiles = house1_data::metatile_table_top_right_tiles
house1_metatile_table_bottom_left_tiles = house1_data::metatile_table_bottom_left_tiles
house1_metatile_table_bottom_right_tiles = house1_data::metatile_table_bottom_right_tiles
house1_big_metatile_table_top_left = house1_data::big_metatile_table_top_left
house1_big_metatile_table_top_right = house1_data::big_metatile_table_top_right
house1_big_metatile_table_bottom_left = house1_data::big_metatile_table_bottom_left
house1_big_metatile_table_bottom_right = house1_data::big_metatile_table_bottom_right
house1_map = house1_data::map

.scope housebl_data
.include "housebl.inc"
.endscope

housebl_metatile_table_properties = housebl_data::metatile_table_properties
housebl_metatile_table_params = housebl_data::metatile_table_params
housebl_metatile_table_attributes = housebl_data::metatile_table_attributes
housebl_metatile_table_top_left_tiles = housebl_data::metatile_table_top_left_tiles
housebl_metatile_table_top_right_tiles = housebl_data::metatile_table_top_right_tiles
housebl_metatile_table_bottom_left_tiles = housebl_data::metatile_table_bottom_left_tiles
housebl_metatile_table_bottom_right_tiles = housebl_data::metatile_table_bottom_right_tiles
housebl_big_metatile_table_top_left = housebl_data::big_metatile_table_top_left
housebl_big_metatile_table_top_right = housebl_data::big_metatile_table_top_right
housebl_big_metatile_table_bottom_left = housebl_data::big_metatile_table_bottom_left
housebl_big_metatile_table_bottom_right = housebl_data::big_metatile_table_bottom_right
housebl_map = housebl_data::map

.scope housebr_data
.include "housebr.inc"
.endscope

housebr_metatile_table_properties = housebr_data::metatile_table_properties
housebr_metatile_table_params = housebr_data::metatile_table_params
housebr_metatile_table_attributes = housebr_data::metatile_table_attributes
housebr_metatile_table_top_left_tiles = housebr_data::metatile_table_top_left_tiles
housebr_metatile_table_top_right_tiles = housebr_data::metatile_table_top_right_tiles
housebr_metatile_table_bottom_left_tiles = housebr_data::metatile_table_bottom_left_tiles
housebr_metatile_table_bottom_right_tiles = housebr_data::metatile_table_bottom_right_tiles
housebr_big_metatile_table_top_left = housebr_data::big_metatile_table_top_left
housebr_big_metatile_table_top_right = housebr_data::big_metatile_table_top_right
housebr_big_metatile_table_bottom_left = housebr_data::big_metatile_table_bottom_left
housebr_big_metatile_table_bottom_right = housebr_data::big_metatile_table_bottom_right
housebr_map = housebr_data::map

.scope housetr_data
.include "housetr.inc"
.endscope

housetr_metatile_table_properties = housetr_data::metatile_table_properties
housetr_metatile_table_params = housetr_data::metatile_table_params
housetr_metatile_table_attributes = housetr_data::metatile_table_attributes
housetr_metatile_table_top_left_tiles = housetr_data::metatile_table_top_left_tiles
housetr_metatile_table_top_right_tiles = housetr_data::metatile_table_top_right_tiles
housetr_metatile_table_bottom_left_tiles = housetr_data::metatile_table_bottom_left_tiles
housetr_metatile_table_bottom_right_tiles = housetr_data::metatile_table_bottom_right_tiles
housetr_big_metatile_table_top_left = housetr_data::big_metatile_table_top_left
housetr_big_metatile_table_top_right = housetr_data::big_metatile_table_top_right
housetr_big_metatile_table_bottom_left = housetr_data::big_metatile_table_bottom_left
housetr_big_metatile_table_bottom_right = housetr_data::big_metatile_table_bottom_right
housetr_map = housetr_data::map

.scope housel_data
.include "housel.inc"
.endscope

housel_metatile_table_properties = housel_data::metatile_table_properties
housel_metatile_table_params = housel_data::metatile_table_params
housel_metatile_table_attributes = housel_data::metatile_table_attributes
housel_metatile_table_top_left_tiles = housel_data::metatile_table_top_left_tiles
housel_metatile_table_top_right_tiles = housel_data::metatile_table_top_right_tiles
housel_metatile_table_bottom_left_tiles = housel_data::metatile_table_bottom_left_tiles
housel_metatile_table_bottom_right_tiles = housel_data::metatile_table_bottom_right_tiles
housel_big_metatile_table_top_left = housel_data::big_metatile_table_top_left
housel_big_metatile_table_top_right = housel_data::big_metatile_table_top_right
housel_big_metatile_table_bottom_left = housel_data::big_metatile_table_bottom_left
housel_big_metatile_table_bottom_right = housel_data::big_metatile_table_bottom_right
housel_map = housel_data::map

.scope houser_data
.include "houser.inc"
.endscope

houser_metatile_table_properties = houser_data::metatile_table_properties
houser_metatile_table_params = houser_data::metatile_table_params
houser_metatile_table_attributes = houser_data::metatile_table_attributes
houser_metatile_table_top_left_tiles = houser_data::metatile_table_top_left_tiles
houser_metatile_table_top_right_tiles = houser_data::metatile_table_top_right_tiles
houser_metatile_table_bottom_left_tiles = houser_data::metatile_table_bottom_left_tiles
houser_metatile_table_bottom_right_tiles = houser_data::metatile_table_bottom_right_tiles
houser_big_metatile_table_top_left = houser_data::big_metatile_table_top_left
houser_big_metatile_table_top_right = houser_data::big_metatile_table_top_right
houser_big_metatile_table_bottom_left = houser_data::big_metatile_table_bottom_left
houser_big_metatile_table_bottom_right = houser_data::big_metatile_table_bottom_right
houser_map = houser_data::map

.scope meadow1_data
.include "meadow1.inc"
.endscope

meadow1_metatile_table_properties = meadow1_data::metatile_table_properties
meadow1_metatile_table_params = meadow1_data::metatile_table_params
meadow1_metatile_table_attributes = meadow1_data::metatile_table_attributes
meadow1_metatile_table_top_left_tiles = meadow1_data::metatile_table_top_left_tiles
meadow1_metatile_table_top_right_tiles = meadow1_data::metatile_table_top_right_tiles
meadow1_metatile_table_bottom_left_tiles = meadow1_data::metatile_table_bottom_left_tiles
meadow1_metatile_table_bottom_right_tiles = meadow1_data::metatile_table_bottom_right_tiles
meadow1_big_metatile_table_top_left = meadow1_data::big_metatile_table_top_left
meadow1_big_metatile_table_top_right = meadow1_data::big_metatile_table_top_right
meadow1_big_metatile_table_bottom_left = meadow1_data::big_metatile_table_bottom_left
meadow1_big_metatile_table_bottom_right = meadow1_data::big_metatile_table_bottom_right
meadow1_map = meadow1_data::map

.scope meadow2_data
.include "meadow2.inc"
.endscope

meadow2_metatile_table_properties = meadow2_data::metatile_table_properties
meadow2_metatile_table_params = meadow2_data::metatile_table_params
meadow2_metatile_table_attributes = meadow2_data::metatile_table_attributes
meadow2_metatile_table_top_left_tiles = meadow2_data::metatile_table_top_left_tiles
meadow2_metatile_table_top_right_tiles = meadow2_data::metatile_table_top_right_tiles
meadow2_metatile_table_bottom_left_tiles = meadow2_data::metatile_table_bottom_left_tiles
meadow2_metatile_table_bottom_right_tiles = meadow2_data::metatile_table_bottom_right_tiles
meadow2_big_metatile_table_top_left = meadow2_data::big_metatile_table_top_left
meadow2_big_metatile_table_top_right = meadow2_data::big_metatile_table_top_right
meadow2_big_metatile_table_bottom_left = meadow2_data::big_metatile_table_bottom_left
meadow2_big_metatile_table_bottom_right = meadow2_data::big_metatile_table_bottom_right
meadow2_map = meadow2_data::map

.segment "ROM14"

.scope meadow3_data
.include "meadow3.inc"
.endscope

meadow3_metatile_table_properties = meadow3_data::metatile_table_properties
meadow3_metatile_table_params = meadow3_data::metatile_table_params
meadow3_metatile_table_attributes = meadow3_data::metatile_table_attributes
meadow3_metatile_table_top_left_tiles = meadow3_data::metatile_table_top_left_tiles
meadow3_metatile_table_top_right_tiles = meadow3_data::metatile_table_top_right_tiles
meadow3_metatile_table_bottom_left_tiles = meadow3_data::metatile_table_bottom_left_tiles
meadow3_metatile_table_bottom_right_tiles = meadow3_data::metatile_table_bottom_right_tiles
meadow3_big_metatile_table_top_left = meadow3_data::big_metatile_table_top_left
meadow3_big_metatile_table_top_right = meadow3_data::big_metatile_table_top_right
meadow3_big_metatile_table_bottom_left = meadow3_data::big_metatile_table_bottom_left
meadow3_big_metatile_table_bottom_right = meadow3_data::big_metatile_table_bottom_right
meadow3_map = meadow3_data::map

.scope dungeon_data
.include "dungeon.inc"
.endscope

dungeon_metatile_table_properties = dungeon_data::metatile_table_properties
dungeon_metatile_table_params = dungeon_data::metatile_table_params
dungeon_metatile_table_attributes = dungeon_data::metatile_table_attributes
dungeon_metatile_table_top_left_tiles = dungeon_data::metatile_table_top_left_tiles
dungeon_metatile_table_top_right_tiles = dungeon_data::metatile_table_top_right_tiles
dungeon_metatile_table_bottom_left_tiles = dungeon_data::metatile_table_bottom_left_tiles
dungeon_metatile_table_bottom_right_tiles = dungeon_data::metatile_table_bottom_right_tiles
dungeon_big_metatile_table_top_left = dungeon_data::big_metatile_table_top_left
dungeon_big_metatile_table_top_right = dungeon_data::big_metatile_table_top_right
dungeon_big_metatile_table_bottom_left = dungeon_data::big_metatile_table_bottom_left
dungeon_big_metatile_table_bottom_right = dungeon_data::big_metatile_table_bottom_right
dungeon_map = dungeon_data::map

.scope dungeon1_boss_data
.include "dungeon1_boss.inc"
.endscope

dungeon1_boss_metatile_table_properties = dungeon1_boss_data::metatile_table_properties
dungeon1_boss_metatile_table_params = dungeon1_boss_data::metatile_table_params
dungeon1_boss_metatile_table_attributes = dungeon1_boss_data::metatile_table_attributes
dungeon1_boss_metatile_table_top_left_tiles = dungeon1_boss_data::metatile_table_top_left_tiles
dungeon1_boss_metatile_table_top_right_tiles = dungeon1_boss_data::metatile_table_top_right_tiles
dungeon1_boss_metatile_table_bottom_left_tiles = dungeon1_boss_data::metatile_table_bottom_left_tiles
dungeon1_boss_metatile_table_bottom_right_tiles = dungeon1_boss_data::metatile_table_bottom_right_tiles
dungeon1_boss_big_metatile_table_top_left = dungeon1_boss_data::big_metatile_table_top_left
dungeon1_boss_big_metatile_table_top_right = dungeon1_boss_data::big_metatile_table_top_right
dungeon1_boss_big_metatile_table_bottom_left = dungeon1_boss_data::big_metatile_table_bottom_left
dungeon1_boss_big_metatile_table_bottom_right = dungeon1_boss_data::big_metatile_table_bottom_right
dungeon1_boss_map = dungeon1_boss_data::map

.scope tundra1_data
.include "tundra1.inc"
.endscope

tundra1_metatile_table_properties = tundra1_data::metatile_table_properties
tundra1_metatile_table_params = tundra1_data::metatile_table_params
tundra1_metatile_table_attributes = tundra1_data::metatile_table_attributes
tundra1_metatile_table_top_left_tiles = tundra1_data::metatile_table_top_left_tiles
tundra1_metatile_table_top_right_tiles = tundra1_data::metatile_table_top_right_tiles
tundra1_metatile_table_bottom_left_tiles = tundra1_data::metatile_table_bottom_left_tiles
tundra1_metatile_table_bottom_right_tiles = tundra1_data::metatile_table_bottom_right_tiles
tundra1_big_metatile_table_top_left = tundra1_data::big_metatile_table_top_left
tundra1_big_metatile_table_top_right = tundra1_data::big_metatile_table_top_right
tundra1_big_metatile_table_bottom_left = tundra1_data::big_metatile_table_bottom_left
tundra1_big_metatile_table_bottom_right = tundra1_data::big_metatile_table_bottom_right
tundra1_map = tundra1_data::map

.scope tundra2_data
.include "tundra2.inc"
.endscope

tundra2_metatile_table_properties = tundra2_data::metatile_table_properties
tundra2_metatile_table_params = tundra2_data::metatile_table_params
tundra2_metatile_table_attributes = tundra2_data::metatile_table_attributes
tundra2_metatile_table_top_left_tiles = tundra2_data::metatile_table_top_left_tiles
tundra2_metatile_table_top_right_tiles = tundra2_data::metatile_table_top_right_tiles
tundra2_metatile_table_bottom_left_tiles = tundra2_data::metatile_table_bottom_left_tiles
tundra2_metatile_table_bottom_right_tiles = tundra2_data::metatile_table_bottom_right_tiles
tundra2_big_metatile_table_top_left = tundra2_data::big_metatile_table_top_left
tundra2_big_metatile_table_top_right = tundra2_data::big_metatile_table_top_right
tundra2_big_metatile_table_bottom_left = tundra2_data::big_metatile_table_bottom_left
tundra2_big_metatile_table_bottom_right = tundra2_data::big_metatile_table_bottom_right
tundra2_map = tundra2_data::map

.scope tundra3_data
.include "tundra3.inc"
.endscope

tundra3_metatile_table_properties = tundra3_data::metatile_table_properties
tundra3_metatile_table_params = tundra3_data::metatile_table_params
tundra3_metatile_table_attributes = tundra3_data::metatile_table_attributes
tundra3_metatile_table_top_left_tiles = tundra3_data::metatile_table_top_left_tiles
tundra3_metatile_table_top_right_tiles = tundra3_data::metatile_table_top_right_tiles
tundra3_metatile_table_bottom_left_tiles = tundra3_data::metatile_table_bottom_left_tiles
tundra3_metatile_table_bottom_right_tiles = tundra3_data::metatile_table_bottom_right_tiles
tundra3_big_metatile_table_top_left = tundra3_data::big_metatile_table_top_left
tundra3_big_metatile_table_top_right = tundra3_data::big_metatile_table_top_right
tundra3_big_metatile_table_bottom_left = tundra3_data::big_metatile_table_bottom_left
tundra3_big_metatile_table_bottom_right = tundra3_data::big_metatile_table_bottom_right
tundra3_map = tundra3_data::map

.scope dungeon2_data
.include "dungeon2.inc"
.endscope

dungeon2_metatile_table_properties = dungeon2_data::metatile_table_properties
dungeon2_metatile_table_params = dungeon2_data::metatile_table_params
dungeon2_metatile_table_attributes = dungeon2_data::metatile_table_attributes
dungeon2_metatile_table_top_left_tiles = dungeon2_data::metatile_table_top_left_tiles
dungeon2_metatile_table_top_right_tiles = dungeon2_data::metatile_table_top_right_tiles
dungeon2_metatile_table_bottom_left_tiles = dungeon2_data::metatile_table_bottom_left_tiles
dungeon2_metatile_table_bottom_right_tiles = dungeon2_data::metatile_table_bottom_right_tiles
dungeon2_big_metatile_table_top_left = dungeon2_data::big_metatile_table_top_left
dungeon2_big_metatile_table_top_right = dungeon2_data::big_metatile_table_top_right
dungeon2_big_metatile_table_bottom_left = dungeon2_data::big_metatile_table_bottom_left
dungeon2_big_metatile_table_bottom_right = dungeon2_data::big_metatile_table_bottom_right
dungeon2_map = dungeon2_data::map

.scope dungeon2_boss_data
.include "dungeon2_boss.inc"
.endscope

dungeon2_boss_metatile_table_properties = dungeon2_boss_data::metatile_table_properties
dungeon2_boss_metatile_table_params = dungeon2_boss_data::metatile_table_params
dungeon2_boss_metatile_table_attributes = dungeon2_boss_data::metatile_table_attributes
dungeon2_boss_metatile_table_top_left_tiles = dungeon2_boss_data::metatile_table_top_left_tiles
dungeon2_boss_metatile_table_top_right_tiles = dungeon2_boss_data::metatile_table_top_right_tiles
dungeon2_boss_metatile_table_bottom_left_tiles = dungeon2_boss_data::metatile_table_bottom_left_tiles
dungeon2_boss_metatile_table_bottom_right_tiles = dungeon2_boss_data::metatile_table_bottom_right_tiles
dungeon2_boss_big_metatile_table_top_left = dungeon2_boss_data::big_metatile_table_top_left
dungeon2_boss_big_metatile_table_top_right = dungeon2_boss_data::big_metatile_table_top_right
dungeon2_boss_big_metatile_table_bottom_left = dungeon2_boss_data::big_metatile_table_bottom_left
dungeon2_boss_big_metatile_table_bottom_right = dungeon2_boss_data::big_metatile_table_bottom_right
dungeon2_boss_map = dungeon2_boss_data::map

.scope mountain1_data
.include "mountain1.inc"
.endscope

mountain1_metatile_table_properties = mountain1_data::metatile_table_properties
mountain1_metatile_table_params = mountain1_data::metatile_table_params
mountain1_metatile_table_attributes = mountain1_data::metatile_table_attributes
mountain1_metatile_table_top_left_tiles = mountain1_data::metatile_table_top_left_tiles
mountain1_metatile_table_top_right_tiles = mountain1_data::metatile_table_top_right_tiles
mountain1_metatile_table_bottom_left_tiles = mountain1_data::metatile_table_bottom_left_tiles
mountain1_metatile_table_bottom_right_tiles = mountain1_data::metatile_table_bottom_right_tiles
mountain1_big_metatile_table_top_left = mountain1_data::big_metatile_table_top_left
mountain1_big_metatile_table_top_right = mountain1_data::big_metatile_table_top_right
mountain1_big_metatile_table_bottom_left = mountain1_data::big_metatile_table_bottom_left
mountain1_big_metatile_table_bottom_right = mountain1_data::big_metatile_table_bottom_right
mountain1_map = mountain1_data::map

.scope cave_data
.include "cave.inc"
.endscope

cave_metatile_table_properties = cave_data::metatile_table_properties
cave_metatile_table_params = cave_data::metatile_table_params
cave_metatile_table_attributes = cave_data::metatile_table_attributes
cave_metatile_table_top_left_tiles = cave_data::metatile_table_top_left_tiles
cave_metatile_table_top_right_tiles = cave_data::metatile_table_top_right_tiles
cave_metatile_table_bottom_left_tiles = cave_data::metatile_table_bottom_left_tiles
cave_metatile_table_bottom_right_tiles = cave_data::metatile_table_bottom_right_tiles
cave_big_metatile_table_top_left = cave_data::big_metatile_table_top_left
cave_big_metatile_table_top_right = cave_data::big_metatile_table_top_right
cave_big_metatile_table_bottom_left = cave_data::big_metatile_table_bottom_left
cave_big_metatile_table_bottom_right = cave_data::big_metatile_table_bottom_right
cave_map = cave_data::map

.segment "ROM30"

.scope dungeon3_data
.include "dungeon3.inc"
.endscope

dungeon3_metatile_table_properties = dungeon3_data::metatile_table_properties
dungeon3_metatile_table_params = dungeon3_data::metatile_table_params
dungeon3_metatile_table_attributes = dungeon3_data::metatile_table_attributes
dungeon3_metatile_table_top_left_tiles = dungeon3_data::metatile_table_top_left_tiles
dungeon3_metatile_table_top_right_tiles = dungeon3_data::metatile_table_top_right_tiles
dungeon3_metatile_table_bottom_left_tiles = dungeon3_data::metatile_table_bottom_left_tiles
dungeon3_metatile_table_bottom_right_tiles = dungeon3_data::metatile_table_bottom_right_tiles
dungeon3_big_metatile_table_top_left = dungeon3_data::big_metatile_table_top_left
dungeon3_big_metatile_table_top_right = dungeon3_data::big_metatile_table_top_right
dungeon3_big_metatile_table_bottom_left = dungeon3_data::big_metatile_table_bottom_left
dungeon3_big_metatile_table_bottom_right = dungeon3_data::big_metatile_table_bottom_right
dungeon3_map = dungeon3_data::map

.scope dungeon3_boss_data
.include "dungeon3_boss.inc"
.endscope

dungeon3_boss_metatile_table_properties = dungeon3_boss_data::metatile_table_properties
dungeon3_boss_metatile_table_params = dungeon3_boss_data::metatile_table_params
dungeon3_boss_metatile_table_attributes = dungeon3_boss_data::metatile_table_attributes
dungeon3_boss_metatile_table_top_left_tiles = dungeon3_boss_data::metatile_table_top_left_tiles
dungeon3_boss_metatile_table_top_right_tiles = dungeon3_boss_data::metatile_table_top_right_tiles
dungeon3_boss_metatile_table_bottom_left_tiles = dungeon3_boss_data::metatile_table_bottom_left_tiles
dungeon3_boss_metatile_table_bottom_right_tiles = dungeon3_boss_data::metatile_table_bottom_right_tiles
dungeon3_boss_big_metatile_table_top_left = dungeon3_boss_data::big_metatile_table_top_left
dungeon3_boss_big_metatile_table_top_right = dungeon3_boss_data::big_metatile_table_top_right
dungeon3_boss_big_metatile_table_bottom_left = dungeon3_boss_data::big_metatile_table_bottom_left
dungeon3_boss_big_metatile_table_bottom_right = dungeon3_boss_data::big_metatile_table_bottom_right
dungeon3_boss_map = dungeon3_boss_data::map

.scope island1_data
.include "island1.inc"
.endscope

island1_metatile_table_properties = island1_data::metatile_table_properties
island1_metatile_table_params = island1_data::metatile_table_params
island1_metatile_table_attributes = island1_data::metatile_table_attributes
island1_metatile_table_top_left_tiles = island1_data::metatile_table_top_left_tiles
island1_metatile_table_top_right_tiles = island1_data::metatile_table_top_right_tiles
island1_metatile_table_bottom_left_tiles = island1_data::metatile_table_bottom_left_tiles
island1_metatile_table_bottom_right_tiles = island1_data::metatile_table_bottom_right_tiles
island1_big_metatile_table_top_left = island1_data::big_metatile_table_top_left
island1_big_metatile_table_top_right = island1_data::big_metatile_table_top_right
island1_big_metatile_table_bottom_left = island1_data::big_metatile_table_bottom_left
island1_big_metatile_table_bottom_right = island1_data::big_metatile_table_bottom_right
island1_map = island1_data::map

.scope island2_data
.include "island2.inc"
.endscope

island2_metatile_table_properties = island2_data::metatile_table_properties
island2_metatile_table_params = island2_data::metatile_table_params
island2_metatile_table_attributes = island2_data::metatile_table_attributes
island2_metatile_table_top_left_tiles = island2_data::metatile_table_top_left_tiles
island2_metatile_table_top_right_tiles = island2_data::metatile_table_top_right_tiles
island2_metatile_table_bottom_left_tiles = island2_data::metatile_table_bottom_left_tiles
island2_metatile_table_bottom_right_tiles = island2_data::metatile_table_bottom_right_tiles
island2_big_metatile_table_top_left = island2_data::big_metatile_table_top_left
island2_big_metatile_table_top_right = island2_data::big_metatile_table_top_right
island2_big_metatile_table_bottom_left = island2_data::big_metatile_table_bottom_left
island2_big_metatile_table_bottom_right = island2_data::big_metatile_table_bottom_right
island2_map = island2_data::map

.scope temple1_data
.include "temple1.inc"
.endscope

temple1_metatile_table_properties = temple1_data::metatile_table_properties
temple1_metatile_table_params = temple1_data::metatile_table_params
temple1_metatile_table_attributes = temple1_data::metatile_table_attributes
temple1_metatile_table_top_left_tiles = temple1_data::metatile_table_top_left_tiles
temple1_metatile_table_top_right_tiles = temple1_data::metatile_table_top_right_tiles
temple1_metatile_table_bottom_left_tiles = temple1_data::metatile_table_bottom_left_tiles
temple1_metatile_table_bottom_right_tiles = temple1_data::metatile_table_bottom_right_tiles
temple1_big_metatile_table_top_left = temple1_data::big_metatile_table_top_left
temple1_big_metatile_table_top_right = temple1_data::big_metatile_table_top_right
temple1_big_metatile_table_bottom_left = temple1_data::big_metatile_table_bottom_left
temple1_big_metatile_table_bottom_right = temple1_data::big_metatile_table_bottom_right
temple1_map = temple1_data::map

.scope dungeon4_data
.include "dungeon4.inc"
.endscope

dungeon4_metatile_table_properties = dungeon4_data::metatile_table_properties
dungeon4_metatile_table_params = dungeon4_data::metatile_table_params
dungeon4_metatile_table_attributes = dungeon4_data::metatile_table_attributes
dungeon4_metatile_table_top_left_tiles = dungeon4_data::metatile_table_top_left_tiles
dungeon4_metatile_table_top_right_tiles = dungeon4_data::metatile_table_top_right_tiles
dungeon4_metatile_table_bottom_left_tiles = dungeon4_data::metatile_table_bottom_left_tiles
dungeon4_metatile_table_bottom_right_tiles = dungeon4_data::metatile_table_bottom_right_tiles
dungeon4_big_metatile_table_top_left = dungeon4_data::big_metatile_table_top_left
dungeon4_big_metatile_table_top_right = dungeon4_data::big_metatile_table_top_right
dungeon4_big_metatile_table_bottom_left = dungeon4_data::big_metatile_table_bottom_left
dungeon4_big_metatile_table_bottom_right = dungeon4_data::big_metatile_table_bottom_right
dungeon4_map = dungeon4_data::map
