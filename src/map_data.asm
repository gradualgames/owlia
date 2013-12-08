.include "map_data.inc"
.include "map.inc"
.include "actions.inc"
.include "areas.inc"
.include "locations.inc"

.segment "ROM11"

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

.scope inn_data
.include "inn.inc"
.endscope

inn_metatile_table_properties = inn_data::metatile_table_properties
inn_metatile_table_params = inn_data::metatile_table_params
inn_metatile_table_attributes = inn_data::metatile_table_attributes
inn_metatile_table_top_left_tiles = inn_data::metatile_table_top_left_tiles
inn_metatile_table_top_right_tiles = inn_data::metatile_table_top_right_tiles
inn_metatile_table_bottom_left_tiles = inn_data::metatile_table_bottom_left_tiles
inn_metatile_table_bottom_right_tiles = inn_data::metatile_table_bottom_right_tiles
inn_big_metatile_table_top_left = inn_data::big_metatile_table_top_left
inn_big_metatile_table_top_right = inn_data::big_metatile_table_top_right
inn_big_metatile_table_bottom_left = inn_data::big_metatile_table_bottom_left
inn_big_metatile_table_bottom_right = inn_data::big_metatile_table_bottom_right
inn_map = inn_data::map

.scope store_data
.include "store.inc"
.endscope

store_metatile_table_properties = store_data::metatile_table_properties
store_metatile_table_params = store_data::metatile_table_params
store_metatile_table_attributes = store_data::metatile_table_attributes
store_metatile_table_top_left_tiles = store_data::metatile_table_top_left_tiles
store_metatile_table_top_right_tiles = store_data::metatile_table_top_right_tiles
store_metatile_table_bottom_left_tiles = store_data::metatile_table_bottom_left_tiles
store_metatile_table_bottom_right_tiles = store_data::metatile_table_bottom_right_tiles
store_big_metatile_table_top_left = store_data::big_metatile_table_top_left
store_big_metatile_table_top_right = store_data::big_metatile_table_top_right
store_big_metatile_table_bottom_left = store_data::big_metatile_table_bottom_left
store_big_metatile_table_bottom_right = store_data::big_metatile_table_bottom_right
store_map = store_data::map

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

.segment "ROM12"

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
