.ifndef CONVERSATION_DATA
CONVERSATION_DATA = 1

;please note, this bank is intended to be the same as TEXTBOX_BANK,
;as the run_conversation routine assumes that the conversation data is
;loaded in the same bank as the textbox code.
CONVERSATIONS_BANK = 10

.global conversations_lo
.global conversations_hi

.enum
conversation_index_welcome_to_demo
conversation_index_welcome_to_my_house
conversation_index_welcome_to_my_store
conversation_index_welcome_to_my_inn
conversation_index_prompt_for_stay_at_inn
conversation_index_door_is_locked
conversation_index_purchase_bomb
conversation_index_purchase_lantern
conversation_index_purchase_health
conversation_index_purchase_rope
conversation_index_not_enough_gp
conversation_index_intro_cut_scene_slide1_text
.endenum

.endif
