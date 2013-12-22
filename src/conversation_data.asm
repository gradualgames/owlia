.linecont +
.include "textbox.inc"
.include "conversation_data.inc"

.segment "CODE"

.define conversations \
    welcome_to_demo, \
    welcome_to_my_house, \
    welcome_to_my_store, \
    welcome_to_my_inn, \
    prompt_for_stay_at_inn, \
    door_is_locked, \
    purchase_bomb, \
    purchase_lantern, \
    purchase_health, \
    purchase_rope, \
    not_enough_gp, \
    intro_cut_scene_slide1_text

conversations_lo:
  .lobytes conversations

conversations_hi:
  .hibytes conversations

.segment "ROM10"

welcome_to_demo:
  .byte    1, "WELCOME!",WT
  .byte NL,2, "HAVE A LOOK AROUND AT"
  .byte NL,3, "THIS DEMO OF OUR IN"
  .byte NL,4, "DEVELOPMENT TITLE!",WT,EP

  .byte NL,1, "DO NOT FORGET"
  .byte NL,2, "TO TRY HITTING BOTH",WT
  .byte NL,3, "A AND B.",WT,EP

  .byte NL,1, "ALSO DO NOT FORGET TO"
  .byte NL,2, "VISIT HOUSES!",WT,EC

welcome_to_my_house:
  .byte    1, "WELCOME TO MY HOUSE!",WT,EC

welcome_to_my_store:
  .byte    1, "WELCOME TO MY STORE!",WT
  .byte NL,2, "IF YOU SEE ANYTHING YOU LIKE,"
  .byte NL,3, "WALK UP TO IT AND HIT A.",WT,EC

welcome_to_my_inn:
  .byte    1, "WELCOME TO MY INN!",WT
  .byte NL,2, "MAKE YOURSELF AT HOME!",WT,EC

prompt_for_stay_at_inn:
  .byte    1, "ONE NIGHT IS TEN GP."
  .byte NL,2, "TO STAY, HIT A."
  .byte NL,3, "IF NOT, HIT B.",CC,EC

door_is_locked:
  .byte    1, "THIS DOOR IS LOCKED!",WT,EC

purchase_bomb:
  .byte    1, "BOMBS ARE TEN GP."
  .byte NL,2, "BUY?"
  .byte NL,3, "HIT A FOR YES"
  .byte NL,4, "HIT B FOR NO",CC,EC

purchase_lantern:
  .byte    1, "LANTERNS ARE TEN GP."
  .byte NL,2, "BUY?"
  .byte NL,3, "HIT A FOR YES"
  .byte NL,4, "HIT B FOR NO",CC,EC

purchase_health:
  .byte    1, "HEALTH IS TEN GP."
  .byte NL,2, "BUY?"
  .byte NL,3, "HIT A FOR YES"
  .byte NL,4, "HIT B FOR NO",CC,EC

purchase_rope:
  .byte    1, "ROPE IS TEN GP."
  .byte NL,2, "BUY?"
  .byte NL,3, "HIT A FOR YES"
  .byte NL,4, "HIT B FOR NO",CC,EC

not_enough_gp:
  .byte    1, "YOU DO NOT HAVE ENOUGH GP.",WT,EC

intro_cut_scene_slide1_text:
  .byte    1, "THESE ARE OWLS.",TM,75
  .byte NL,2, "THEY WILL BORE A"
  .byte NL,3, "HOLE IN YOUR SOUL.",TM,75,EC
