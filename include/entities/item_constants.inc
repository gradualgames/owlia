.linecont +
.ifndef ITEM_CONSTANTS_INC
ITEM_CONSTANTS_INC = 1

.enum
ITEM_TYPE_GP
ITEM_TYPE_HEALTH
ITEM_TYPE_BOMB
ITEM_TYPE_LANTERN
.endenum

;these constants represent the size of the inventory
;variable affected by picking up the item.
.enum
ITEM_8_BIT_VAR
ITEM_24_BIT_VAR
.endenum

ITEM_WIDTH = $07
ITEM_HEIGHT = $07

ITEM_FADE_OUT_LENGTH = 400

ITEM_PARAMS = 7

define_entity_properties item_initial_state,\
                         item_type,\
                         item_dungeon_flags_mask,\
                         item_price_lo,\
                         item_price_hi,\
                         item_quantity_lo,\
                         item_quantity_hi,\
                         item_fade_out_counter_lo,\
                         item_fade_out_counter_hi

.enum
ITEM_STATE_INIT
ITEM_STATE_PICKUP_INIT
ITEM_STATE_PICKUP
ITEM_STATE_PICKUP_AND_FADE_OUT_INIT
ITEM_STATE_PICKUP_AND_FADE_OUT
ITEM_STATE_DROP_RANDOM_ITEM_INIT
.endenum

.endif
