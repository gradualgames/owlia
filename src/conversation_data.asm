.feature force_range
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
    purchase_bomb, \
    purchase_lantern, \
    purchase_health, \
    purchase_rope, \
    not_enough_gp, \
    intro_cut_scene_owls_text, \
    intro_cut_scene_mermon_text, \
    intro_cut_scene_mermon_mad_text, \
    intro_cut_scene_mermon_leer_text, \
    intro_cut_scene_silmaran_text, \
    house_intro_scene_window, \
    house_intro_scene_call_tyto1, \
    house_intro_scene_call_tyto2, \
    silmaran_call_adlanniel, \
    silmaran_encounter_scene, \
    thanks_for_playing_demo

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

intro_cut_scene_owls_text:
  .byte    1, "ONCE UPON A TIME,",TM,20," ON A WORLD"
  .byte NL,2, "FAR BEYOND IMAGINING,",TM,20," SIX"
  .byte NL,3, "GREAT OWLS BROUGHT FORTH A"
  .byte NL,4, "LAND CALLED OWLIA.",TM,75,EP

  .byte NL,1, "TOGETHER,",TM,20," THEY REIGNED IN"
  .byte NL,2, "PEACE AND WISDOM FOR"
  .byte NL,3, "EIGHTY THOUSAND YEARS.",TM,30
  .byte NL,4, "HOWEVER,",TM,20," THEIR PRIDE IN THE",TM,75,EP

  .byte NL,1, "BEAUTIFUL LAND AND SKY OF"
  .byte NL,2, "OWLIA LED THEM TO FORGET THE"
  .byte NL,3, "VAST SEAS...",TM,75,EC

intro_cut_scene_mermon_text:
  .byte    1, "MERMON,",TM,20," KING OF MERMEN,",TM,20," OFT"
  .byte NL,2, "ROSE TO THE SURFACE TO VIEW"
  .byte NL,3, "THE LAND OF OWLIA.",TM,30," HIS"
  .byte NL,4, "DESIRE FOR SUNLIGHT,",TM,20," SKY,",TM,75,EC

intro_cut_scene_mermon_mad_text:
  .byte    1, "AND GREEN FORESTS GREW UNTIL"
  .byte NL,2, "HE DECIDED THE SEAS WERE NOT"
  .byte NL,3, "ENOUGH FOR HIM.",TM,30," HE STROVE TO"
  .byte NL,4, "LEARN ANCIENT DARK MAGIC",TM,75,EC

intro_cut_scene_mermon_leer_text:
  .byte    1, "TO SUMMON THE SIX GREAT OWLS"
  .byte NL,2, "ONE BY ONE.",TM,30," HE BEGAN SAPPING"
  .byte NL,3, "THEIR POWER OF FLIGHT,",TM,20
  .byte NL,4, "EMPOWERING HIS MINIONS TO",TM,75,EP

  .byte NL,1, "RISE INTO THE AIR TOWARDS"
  .byte NL,2, "THE LAND OF OWLIA TO CLAIM"
  .byte NL,3, "IT FOR HIS OWN.",TM,30," HOWEVER,",TM,20," ONE"
  .byte NL,4, "GREAT OWL ELUDED HIM...",TM,75,EC

intro_cut_scene_silmaran_text:
  .byte    1, "SILMARAN,",TM,20," THE WHITE KING.",TM,30
  .byte NL,2, "SOARING HIGH ABOVE THE LAND"
  .byte NL,3, "OF OWLIA,",TM,20," AS MERMON'S FORCES"
  .byte NL,4, "GREW IN POWER,",TM,20," HE SEARCHED",TM,75,EP

  .byte NL,1, "FOR ONE WHO MIGHT HEED"
  .byte NL,2, "HIS CALL TO RESCUE THE"
  .byte NL,3, "GREAT OWLS AND RESTORE"
  .byte NL,4, "THE LAND OF OWLIA.",TM,75,EC

house_intro_scene_window:
  .byte    1, "WHAT A BEAUTIFUL DAY!",TM,30," I"
  .byte NL,2, "THINK I'M GOING TO TAKE TYTO"
  .byte NL,3, "OUTSIDE TO STRETCH HIS"
  .byte NL,4, "WINGS.",TM,75,EC

house_intro_scene_call_tyto1:
  .byte    1, "...",TM,30,"TYTO!",TM,75,EC

house_intro_scene_call_tyto2:
  .byte    1, "...",TM,30,"TO ME!",TM,75,EC

silmaran_call_adlanniel:
  .byte    1, "...",TM,75,"ADLANNIEL",TM,30,".",TM,30,".",TM,30,".",TM,75,EC

silmaran_encounter_scene:
  .byte    1, "ADLANNIEL,",TM,30," WHO DOTH SPEAK"
  .byte NL,2, "TO OWLS.",TM,30," DO NOT BE ALARMED,",TM,20
  .byte NL,3, "FOR I AM SILMARAN!",TM,30
  .byte NL,4, "THE KING OF THE GREAT OWLS",WT,EP

  .byte NL,1, "OF OWLIA.",TM,30," I SUMMONED YOU"
  .byte NL,2, "HERE BECAUSE A GREAT EVIL"
  .byte NL,3, "STIRS IN THE DEEP,",TM,10," SEEKING"
  .byte NL,4, "TO RISE AND CONQUER THESE",WT,EP

  .byte NL,1, "FAIR LANDS.",TM,30," I SENSED IN YOU"
  .byte NL,2, "A COURAGEOUS HEART,",TM,20," AND"
  .byte NL,3, "STEADFAST DETERMINATION.",TM,30
  .byte NL,4, "FIVE OF THE GREAT OWLS HAVE",WT,EP

  .byte NL,1, "BEEN CAPTURED BY MERMON,",TM,20," THE"
  .byte NL,2, "EVIL KING OF MERMEN.",TM,30," OUR"
  .byte NL,3, "POWER IS FADING QUICKLY.",TM,30
  .byte NL,4, "WE NEED YOU,",TM,20," ADLANNIEL,",WT,EP

  .byte NL,1, "TO RESCUE THE GREAT OWLS,",TM,20
  .byte NL,2, "DEFEAT MERMON AND RESTORE"
  .byte NL,3, "BALANCE TO THE LAND OF"
  .byte NL,4, "OWLIA.",WT,EP

  .byte NL,1, "THE LAST OF OUR POWER SHALL"
  .byte NL,2, "PASS TO YOUR OWL,",TM,20," TYTO,",TM,20," TO"
  .byte NL,3, "AID YOU IN YOUR QUEST.",TM,30," EACH"
  .byte NL,4, "OF US WILL TEACH TYTO A NEW",WT,EP

  .byte NL,1, "TECHNIQUE.",TM,30," I NOW GIVE HIM"
  .byte NL,2, "THE ABILITY TO FETCH ITEMS.",TM,30
  .byte NL,3, "TRY IT OUT BY HITTING SELECT"
  .byte NL,4, "TO CHOOSE TECH TWO,",TM,20," THEN HIT",WT,EP

  .byte NL,1, "B.",TM,30," GOOD LUCK, ADLANNIEL,",TM,20
  .byte NL,2, "AND FLY TRUE,",TM,20," NOBLE TYTO.",WT,EC

thanks_for_playing_demo:
  .byte    1, "THANKS FOR PLAYING OUR DEMO"
  .byte NL,2, "OF THE LEGENDS OF OWLIA.",TM,30," WE"
  .byte NL,3, "HOPE YOU ENJOYED IT.",TM,30," PLEASE"
  .byte NL,4, "MAKE SURE TO FOLLOW US ON",WT,EP

  .byte NL,1, "TWITTER AT GRADUALGAMES.",WT,EC
