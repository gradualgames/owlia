.linecont +
.include "textbox.inc"
.include "conversation_data.inc"

.segment "CODE"

.define conversations \
    hi_adlanniel, \
    npc_housetr, \
    npc_housebl, \
    npc_housebr, \
    owlia_school_of_falconry, \
    welcome_to_my_store, \
    welcome_to_my_inn, \
    prompt_for_stay_at_inn, \
    door_is_locked, \
    purchase_bomb, \
    purchase_lantern, \
    purchase_health, \
    purchase_rope, \
    not_enough_gp, \
    intro_cut_scene_slide1_text, \
    house_intro_scene_window, \
    house_intro_scene_call_tyto1, \
    house_intro_scene_call_tyto2

conversations_lo:
  .lobytes conversations

conversations_hi:
  .hibytes conversations

.segment "ROM10"

hi_adlanniel:
  .byte    1, "HI,",TM,5," ADLANNIEL!",TM,10," TYTO IS"
  .byte NL,2, "LOOKING BRIGHT EYED TODAY!",TM,20
  .byte NL,3, "BE CAREFUL IF YOU GO TO THE"
  .byte NL,4, "FOREST SOUTH OF HERE, I HAVE",WT,EP

  .byte NL,1, "HEARD TELL OF A HOVERING SEA"
  .byte NL,2, "MONSTER THREATENING THE"
  .byte NL,3, "TOWNFOLK.",WT,EC

npc_housetr:
  .byte    1, "THE LAND OF OWLIA HAS ALWAYS"
  .byte NL,2, "BEEN SO PEACEFUL.",TM,20," BUT WITH"
  .byte NL,3, "THE STORIES I HAVE BEEN"
  .byte NL,4, "HEARING LATELY, ALL I WANT",WT,EP

  .byte NL,1, "TO DO IS PACE AROUND"
  .byte NL,2, "NERVOUSLY AT HOME.",WT,EC

npc_housebl:
  .byte    1, "I WENT DOWN TO THE BEACH"
  .byte NL,2, "LAST SUMMER",TM,10,".",TM,10,".",TM,10," AND I COULD"
  .byte NL,3, "SWEAR I SAW A LARGE,",TM,10," OMINOUS"
  .byte NL,4, "MOUND CRESTING THE SURFACE",WT,EP

  .byte NL,1, "OF THE WATER SEVERAL MILES"
  .byte NL,2, "OFF SHORE.",TM,30," WHAT COULD IT"
  .byte NL,3, "HAVE BEEN, ADLANNIEL?",WT,EC

npc_housebr:
  .byte    1, "I AM FAMILIAR WITH BIRDS"
  .byte NL,2, "LIKE YOUR OWL, TYTO.",TM,30
  .byte NL,3, "BUT MY HUSBAND TOLD ME HE"
  .byte NL,4, "SAW AN ENORMOUS SNOWY OWL",WT,EP

  .byte NL,1, "IN THE CANOPY OF THE FOREST"
  .byte NL,2, "EARLY THIS MORNING.",TM,30
  .byte NL,3, "I HAVE HEARD THE LEGENDS"
  .byte NL,4, "OF OWLIA...COULD THAT REALLY",WT,EP

  .byte NL,1, "BE SILMARAN, THE KING OWL???",WT,EC

owlia_school_of_falconry:
  .byte    1, "WELCOME TO OWLIA'S SCHOOL OF"
  .byte NL,2, "FALCONRY. WOULD YOU LIKE TO"
  .byte NL,3, "HEAR A SUMMARY OF HOW TO"
  .byte NL,4, "COMMAND YOUR OWL TO PERFORM",WT,EP

  .byte NL,1, "FLYING TECHNIQUES FOR YOU?"
  .byte NL,2, "HIT A IF YES."
  .byte NL,3, "HIT B IF NOT.",CC,EIC,EP

  .byte NL,1, "YOUR OWL CAN SWITCH BETWEEN"
  .byte NL,2, "TWO TECHNIQUES AT A TIME."
  .byte NL,3, "HIT SELECT TO SWITCH BETWEEN"
  .byte NL,4, "TECH ONE AND TECH TWO. HIT",WT,EP

  .byte NL,1, "START TO SEE WHAT TECHS YOUR"
  .byte NL,2, "OWL CURRENTLY KNOWS. ONCE"
  .byte NL,3, "YOUR OWL LEARNS MORE THAN TWO"
  .byte NL,4, "TECHS, YOU CAN SELECT ANY",WT,EP

  .byte NL,1, "PAIR OF TECHS YOU FIND"
  .byte NL,2, "USEFUL.",WT,EP

  .byte NL,1, "IF YOUR OWL IS HELPING YOU"
  .byte NL,2, "FIGHT OFF A FOE, YOU CAN"
  .byte NL,3, "ALWAYS DEFEND YOURSELF WITH"
  .byte NL,4, "YOUR SWORD BY HITTING A.",WT,EC

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

house_intro_scene_window:
  .byte    1, "WHAT A BEAUTIFUL DAY!",TM,30," I"
  .byte NL,2, "THINK I'M GOING TO TAKE TYTO"
  .byte NL,3, "OUTSIDE TO STRETCH HIS"
  .byte NL,4, "WINGS.",TM,75,EC

house_intro_scene_call_tyto1:
  .byte    1, "...",TM,30,"TYTO!",TM,75,EC

house_intro_scene_call_tyto2:
  .byte    1, "...",TM,30,"TO ME!",TM,75,EC
