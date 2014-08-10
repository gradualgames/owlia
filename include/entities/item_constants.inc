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

ITEM_PARAMS = 6

item_initial_state = entity_local0
item_type = entity_local1
item_price_lo = entity_local2
item_price_hi = entity_local3
item_quantity_lo = entity_local4
item_quantity_hi = entity_local5
item_fade_out_counter_lo = entity_local6
item_fade_out_counter_hi = entity_local7

.enum
ITEM_STATE_INIT
ITEM_STATE_PROMPT_FOR_PURCHASE_INIT
ITEM_STATE_PROMPT_FOR_PURCHASE
ITEM_STATE_ADD_ITEM_OR_NOT
ITEM_STATE_PICKUP_INIT
ITEM_STATE_PICKUP
ITEM_STATE_PICKUP_AND_FADE_OUT_INIT
ITEM_STATE_PICKUP_AND_FADE_OUT
ITEM_STATE_DROP_RANDOM_ITEM_INIT
.endenum

.endif
