.include "map_data.inc"
.include "map.inc"
.include "actions.inc"
.include "areas.inc"
.include "locations.inc"

.segment "ROM02"

.scope village_data
.include "village.inc"
.endscope
village_palette = village_data::palette
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

house1_palette = house1_data::palette
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

.scope inn_data
.include "inn.inc"
.endscope

inn_palette = inn_data::palette
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

.scope overworld_data
.include "overworld.inc"
.endscope

overworld_palette = overworld_data::palette
overworld_metatile_table_properties = overworld_data::metatile_table_properties
overworld_metatile_table_params = overworld_data::metatile_table_params
overworld_metatile_table_attributes = overworld_data::metatile_table_attributes
overworld_metatile_table_top_left_tiles = overworld_data::metatile_table_top_left_tiles
overworld_metatile_table_top_right_tiles = overworld_data::metatile_table_top_right_tiles
overworld_metatile_table_bottom_left_tiles = overworld_data::metatile_table_bottom_left_tiles
overworld_metatile_table_bottom_right_tiles = overworld_data::metatile_table_bottom_right_tiles
overworld_big_metatile_table_top_left = overworld_data::big_metatile_table_top_left
overworld_big_metatile_table_top_right = overworld_data::big_metatile_table_top_right
overworld_big_metatile_table_bottom_left = overworld_data::big_metatile_table_bottom_left
overworld_big_metatile_table_bottom_right = overworld_data::big_metatile_table_bottom_right
overworld_map = overworld_data::map
