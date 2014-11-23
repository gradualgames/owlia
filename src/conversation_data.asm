.feature force_range
.linecont +
.include "textbox.inc"
.include "conversation_data.inc"

.segment "ROM00"

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
    rescue_greathornedowl, \
    dungeon_statue_deny_entry

conversations_lo:
  .lobytes conversations

conversations_hi:
  .hibytes conversations

.segment "ROM01"

hi_adlanniel:
  .byte    1, "HI,",TM,5," ADLANNIEL!",TM,10," TYTO IS"
  .byte NL,2, "LOOKING BRIGHT EYED TODAY!",TM,20
  .byte NL,3, "BE CAREFUL IF YOU GO TO"
  .byte NL,4, "THE FOREST SOUTH OF HERE,",WT,EP

  .byte NL,1, "I HAVE HEARD TELL OF A"
  .byte NL,2, "HOVERING SEA MONSTER"
  .byte NL,3, "THREATENING THE TOWNFOLK.",WT,EC

npc_housetr:
  .byte    1, "THE LAND OF OWLIA HAS"
  .byte NL,2, "ALWAYS BEEN SO PEACEFUL.",TM,20
  .byte NL,3, "BUT WITH THE STORIES I"
  .byte NL,4, "HAVE BEEN HEARING LATELY,",WT,EP

  .byte NL,1, "ALL I WANT TO DO IS PACE"
  .byte NL,2, "AROUND NERVOUSLY AT HOME.",WT,EC

npc_housebl:
  .byte    1, "I WENT DOWN TO THE BEACH"
  .byte NL,2, "LAST SUMMER",TM,10,".",TM,10,".",TM,10," AND I COULD"
  .byte NL,3, "SWEAR I SAW A LARGE,",TM,10
  .byte NL,4, "OMINOUS MOUND CRESTING",WT,EP

  .byte NL,1, "THE SURFACE OF THE WATER"
  .byte NL,2, "SEVERAL MILES OFF SHORE.",TM,30
  .byte NL,3, "WHAT COULD IT HAVE BEEN,",TM,20
  .byte NL,4, "ADLANNIEL?",WT,EC

npc_housebr:
  .byte    1, "I AM FAMILIAR WITH BIRDS"
  .byte NL,2, "LIKE YOUR OWL, TYTO.",TM,30
  .byte NL,3, "BUT MY HUSBAND TOLD ME HE"
  .byte NL,4, "SAW AN ENORMOUS SNOWY OWL",WT,EP

  .byte NL,1, "IN THE CANOPY OF THE"
  .byte NL,2, "FOREST EARLY THIS MORNING.",TM,30
  .byte NL,3, "I HAVE HEARD THE LEGENDS"
  .byte NL,4, "OF OWLIA...COULD THAT",WT,EP

  .byte NL,1, "REALLY BE SILMARAN, THE"
  .byte NL,2, "KING OWL???",WT,EC

owlia_school_of_falconry:
  .byte    1, "WELCOME TO OWLIA'S SCHOOL"
  .byte NL,2, "OF FALCONRY.",TM,30," WOULD YOU"
  .byte NL,3, "LIKE TO HEAR A SUMMARY OF"
  .byte NL,4, "HOW TO COMMAND YOUR OWL",WT,EP

  .byte NL,1, "TO PERFORM FLYING"
  .byte NL,2, "TECHNIQUES FOR YOU?",TM,30
  .byte NL,3, "HIT A IF YES."
  .byte NL,4, "HIT B IF NOT.",CC,EIC,EP

  .byte NL,1, "YOUR OWL CAN SWITCH"
  .byte NL,2, "BETWEEN TWO TECHNIQUES AT"
  .byte NL,3, "A TIME.",TM,30," HIT SELECT TO"
  .byte NL,4, "SWITCH BETWEEN TECH ONE",WT,EP

  .byte NL,1, "AND TECH TWO.",TM,30," HIT START TO"
  .byte NL,2, "SEE WHAT TECHS YOUR OWL"
  .byte NL,3, "CURRENTLY KNOWS.",TM,30," ONCE YOUR"
  .byte NL,4, "OWL LEARNS MORE THAN TWO",WT,EP

  .byte NL,1, "TECHS,",TM,20," YOU CAN SELECT ANY"
  .byte NL,2, "PAIR OF TECHS YOU FIND"
  .byte NL,3, "USEFUL.",WT,EP

  .byte NL,1, "WHY DON'T YOU TRY"
  .byte NL,2, "SELECTING THE FETCH TECH"
  .byte NL,3, "AND TRY GRABBING THAT"
  .byte NL,4, "HEART IN THE POOL?",WT,EP

  .byte NL,1, "IF YOUR OWL IS HELPING YOU"
  .byte NL,2, "FIGHT OFF A FOE,",TM,20," YOU CAN"
  .byte NL,3, "DEFEND YOURSELF WITH YOUR"
  .byte NL,4, "SWORD BY HITTING A.",WT,EC

welcome_to_my_store:
  .byte    1, "WELCOME TO MY STORE!",WT
  .byte NL,2, "IF YOU SEE ANYTHING YOU"
  .byte NL,3, "LIKE,",TM,20," WALK UP TO IT AND"
  .byte NL,4, "HIT A.",WT,EC

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

not_enough_gp:
  .byte    1, "YOU DON'T HAVE ENOUGH GP.",WT,EC

intro_cut_scene_owls_text:
  .byte    1, "ONCE UPON A TIME,",TM,20," ON A"
  .byte NL,2, "WORLD FAR BEYOND"
  .byte NL,3, "IMAGINING,",TM,20," SIX GREAT OWLS"
  .byte NL,4, "BROUGHT FORTH A LAND",TM,75,EP

  .byte NL,1, "CALLED OWLIA.",TM,30," TOGETHER,"
  .byte NL,2, "THEY REIGNED IN PEACE AND"
  .byte NL,3, "WISDOM FOR EIGHTY THOUSAND"
  .byte NL,4, "YEARS.",TM,20," HOWEVER,",TM,20," THEIR",TM,75,EP

  .byte NL,1, "PRIDE IN THE BEAUTIFUL"
  .byte NL,2, "LAND AND SKY OF OWLIA LED"
  .byte NL,3, "THEM TO FORGET THE VAST"
  .byte NL,4, "VAST SEAS...",TM,75,EC

intro_cut_scene_mermon_text:
  .byte    1, "MERMON,",TM,20," KING OF MERMEN,",TM,20
  .byte NL,2, "OFT ROSE TO THE SURFACE TO"
  .byte NL,3, "VIEW THE LAND OF OWLIA.",TM,30
  .byte NL,4, "HIS DESIRE FOR SUNLIGHT,",TM,75,EC

intro_cut_scene_mermon_mad_text:
  .byte    1, "SKY, AND GREEN FORESTS"
  .byte NL,2, "GREW UNTIL HE DECIDED THE"
  .byte NL,3, "SEAS WERE NOT ENOUGH FOR"
  .byte NL,4, "HIM. HE ENDEAVORED TO",TM,75,EC

intro_cut_scene_mermon_leer_text:
  .byte    1, "SUMMON THE SIX GREAT OWLS"
  .byte NL,2, "ONE BY ONE.",TM,30," HE BEGAN"
  .byte NL,3, "SAPPING THEIR POWER OF",TM,20
  .byte NL,4, "FLIGHT,",TM,20," EMPOWERING HIS",TM,75,EP

  .byte NL,1, "MINIONS TO FLOAT TOWARDS"
  .byte NL,2, "THE LAND OF OWLIA TO CLAIM"
  .byte NL,3, "IT FOR HIS OWN.",TM,30," HOWEVER,",TM,20
  .byte NL,4, "ONE GREAT OWL ELUDED HIM..",TM,75,EC

intro_cut_scene_silmaran_text:
  .byte    1, "SILMARAN,",TM,20," THE WHITE KING.",TM,30
  .byte NL,2, "SOARING HIGH ABOVE THE"
  .byte NL,3, "LAND OF OWLIA,",TM,20," AS MERMON'S"
  .byte NL,4, "FORCES GREW IN POWER,",TM,20," HE",TM,75,EP

  .byte NL,1, "SEARCHED FOR ONE WHO MIGHT"
  .byte NL,2, "HEED HIS CALL TO RESCUE"
  .byte NL,3, "THE GREAT OWLS AND RESTORE"
  .byte NL,4, "THE LAND OF OWLIA.",TM,75,EC

house_intro_scene_window:
  .byte    1, "WHAT A BEAUTIFUL DAY!",TM,30," I"
  .byte NL,2, "THINK I'M GOING TO TAKE"
  .byte NL,3, "TYTO OUTSIDE TO STRETCH"
  .byte NL,4, "HIS WINGS.",TM,75,EC

house_intro_scene_call_tyto1:
  .byte    1, "...",TM,30,"TYTO!",TM,75,EC

house_intro_scene_call_tyto2:
  .byte    1, "...",TM,30,"TO ME!",TM,75,EC

silmaran_call_adlanniel:
  .byte    1, "...",TM,75,"ADLANNIEL",TM,30,".",TM,30,".",TM,30,".",TM,75,EC

silmaran_encounter_scene:
  .byte    1, "ADLANNIEL,",TM,30," WHO DOTH SPEAK"
  .byte NL,2, "TO OWLS.",TM,30," DO NOT BE"
  .byte NL,3, "ALARMED, FOR I AM"
  .byte NL,4, "SILMARAN! THE KING OF THE",WT,EP

  .byte NL,1, "GREAT OWLS OF OWLIA.",TM,30," I"
  .byte NL,2, "SUMMONED YOU HERE BECAUSE"
  .byte NL,3, "A GREAT EVIL STIRS IN THE"
  .byte NL,4, "DEEP,",TM,20," SEEKING TO RISE AND",WT,EP

  .byte NL,1, "CONQUER THESE FAIR LANDS.",TM,30
  .byte NL,2, "I SENSED IN YOU A"
  .byte NL,3, "COURAGEOUS HEART,",TM,20," AND"
  .byte NL,4, "STEADFAST DETERMINATION.",WT,EP

  .byte NL,1, "FIVE OF THE GREAT OWLS"
  .byte NL,2, "HAVE BEEN CAPTURED BY"
  .byte NL,3, "MERMON,",TM,20," THE EVIL KING OF"
  .byte NL,4, "MERMEN.",TM,30," OUR POWER IS",WT,EP

  .byte NL,1, "FADING QUICKLY.",TM,30," WE NEED"
  .byte NL,2, "YOU, ADLANNIEL,",TM,20," TO RESCUE"
  .byte NL,3, "THE GREAT OWLS,",TM,20," DEFEAT"
  .byte NL,4, "MERMON AND RESTORE",WT,EP

  .byte NL,1, "BALANCE TO THE LAND OF"
  .byte NL,2, "OWLIA.",TM,30," THE LAST OF OUR"
  .byte NL,3, "POWER SHALL PASS TO YOUR"
  .byte NL,4, "OWL,",TM,20," TYTO,",TM,20," TO AID YOU IN",WT,EP

  .byte NL,1, "YOUR QUEST.",TM,30," EACH OF US"
  .byte NL,2, "WILL TEACH TYTO A NEW"
  .byte NL,3, "TECHNIQUE.",TM,30," I NOW GIVE HIM"
  .byte NL,4, "THE ABILITY TO UNLOCK",WT,EP

  .byte NL,1, "DOORS.",TM,30," GOOD LUCK,",TM,20
  .byte NL,2, "ADLANNIEL,",TM,20," AND FLY TRUE,",TM,20
  .byte NL,3, "NOBLE TYTO.",WT,EC

rescue_greathornedowl:
  .byte    1, "NOBLE ADLANNIEL.",TM,30," MY POWER"
  .byte NL,2, "OF FLIGHT IS RESTORED.",TM,30
  .byte NL,3, "THANK YOU.",TM,30
  .byte NL,4, "TO AID YOU FURTHER IN",WT,EP

  .byte NL,1, "YOUR QUEST,",TM,20," I NOW GIVE"
  .byte NL,2, "TYTO THE ABILITY TO TOSS"
  .byte NL,3, "BOMBS!",WT,EP

  .byte NL,1, "OWLIA IS A VAST LAND.",TM,30
  .byte NL,2, "YOU MUST NOW TRAVEL TO"
  .byte NL,3, "THE VAST NORTHERN TUNDRA.",TM,30
  .byte NL,4, "I WILL TAKE YOU THERE.",WT,EC

dungeon_statue_deny_entry:
  .byte    1, "YOU DO NOT POSSESS ENOUGH"
  .byte NL,2, "GOLD TO ENTER....",WT,EC
