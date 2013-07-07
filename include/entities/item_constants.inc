.ifndef ITEM_CONSTANTS_INC
ITEM_CONSTANTS_INC = 1

;these constants are for initializing the item's state
;machine. ITEM_PURCHASE means that the item will prompt
;the user for purchase if they hit A while contacting it,
;ITEM_PICKUP means that the item will simply increment
;that inventory slot and then disappear.
ITEM_PURCHASE   = %00000000
ITEM_PICKUP     = %00000001
ITEM_MODE_TEST  = %00000001

;these constants are for telling this item whether the
;variable it is incrementing is an 8 bit or a 16 bit
;variable (whether to carry to second byte). Typically
;this is only used to differentiate between GP and
;regular types of items.
ITEM_8_BIT_VAR  = %00000000
ITEM_16_BIT_VAR = %00000010
ITEM_WIDTH_TEST = %00000010

.endif
