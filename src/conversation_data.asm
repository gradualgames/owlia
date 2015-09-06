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
    welcome_to_my_house, \
    shh, \
    welcome_to_my_library, \
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
    dungeon_statue_deny_entry, \
    rescue_siberianeagleowl, \
    rescue_greatgrayowl, \
    rescue_sawwhetowl, \
    rescue_barnowl, \
    welcome_to_pirate_bay, \
    advice, \
    if_you_want_my_submarine, \
    target_game_intro, \
    target_game_not_enough_gp, \
    target_game_during, \
    target_game_win, \
    target_game_lose, \
    ring_game_intro, \
    ring_game_not_enough_gp, \
    ring_game_during, \
    ring_game_win, \
    ring_game_lose, \
    welcome_aboard,\
    what_was_that, \
    mermon_threat, \
    mermon_ha_ha_ha, \
    silmaran_final_encounter

conversations_lo:
  .lobytes conversations

conversations_hi:
  .hibytes conversations

.segment "ROM17"

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

welcome_to_my_house:
  .byte    1, "WELCOME TO MY HOUSE!",WT
  .byte NL,2, "MAKE YOURSELF AT HOME!",WT,EC

shh:
  .byte    1, "SSSSSHHHH!!!!!",WT,EC

welcome_to_my_library:
  .byte    1, "WELCOME TO MY LIBRARY!",WT
  .byte NL,2, "CHECK OUT SOME BOOKS!!",WT,EC

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
  .byte NL,4, "HIS WINGS.",TM,30,".",TM,30,".",TM,30,".",EC

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

rescue_siberianeagleowl:
  .byte    1, "I HAD A VISION THAT YOU"
  .byte NL,2, "MIGHT RESCUE ME FROM THIS"
  .byte NL,3, "ICY PRISON.",TM,30," YOU HAVE MY"
  .byte NL,4, "THANKS.",TM,30," I HAVE RECEIVED",WT,EP

  .byte NL,1, "WORD THAT ANOTHER OF MY"
  .byte NL,2, "PEERS IS HELD BY ONE OF"
  .byte NL,3, "MERMON'S HENCHMEN IN THE"
  .byte NL,4, "MOUNTAINS EAST OF HERE.",WT,EP

  .byte NL,1, "I WILL CARRY YOU THERE.",TM,30
  .byte NL,2, "BUT FIRST,",TM,20," ALLOW ME TO"
  .byte NL,3, "BEQUEATHE THE ABILITY TO"
  .byte NL,4, "CARRY LANTERNS UPON TYTO.",WT,EP

  .byte NL,1, "HE WILL NEED THIS IN THE"
  .byte NL,2, "DARK CAVES.",TM,20,".",TM,20,".",WT,EC

rescue_greatgrayowl:
  .byte    1, "ADLANNIEL.",TM,30," I HAVE FELT"
  .byte NL,2, "YOUR PRESENCE DRAW NEAR.",TM,30
  .byte NL,3, "THANK YOU FOR RESCUING ME.",TM,30
  .byte NL,4, "SOUTH OF THIS GREAT",WT,EP

  .byte NL,1, "MOUNTAIN,",TM,20," ACROSS A GULF,",TM,20
  .byte NL,2, "IS A BEAUTIFUL ISLAND.",TM,30
  .byte NL,3, "AT THE CENTER OF IT IS A"
  .byte NL,4, "TEMPLE.",TM,30," I FEEL STRONGLY",WT,EP

  .byte NL,1, "THAT ANOTHER OF MY PEERS"
  .byte NL,2, "IS CAPTIVE THERE.",TM,20," I WILL"
  .byte NL,3, "BE HONORED TO FLY YOU"
  .byte NL,4, "THERE.",TM,30," THE TEMPLE HAS",WT,EP

  .byte NL,1, "MANY CHASMS.",TM,30," FOR THIS,",TM,20," I"
  .byte NL,2, "TEACH TYTO THE ABILITY TO"
  .byte NL,3, "CARRY YOU SHORT DISTANCES.",TM,30
  .byte NL,4, "GOOD LUCK!!!",WT,EC

rescue_sawwhetowl:
  .byte    1, "I SINCERELY THOUGHT I WAS"
  .byte NL,2, "GOING TO BE SUPPER FOR"
  .byte NL,3, "THOSE RAYS.",TM,30," THANK YOU FOR"
  .byte NL,4, "ELIMINATING THEM.",WT,EP

  .byte NL,1, "WE,",TM,20," THE KING OWLS OF"
  .byte NL,2, "OWLIA,",TM,20," ARE ALWAYS"
  .byte NL,3, "CONNECTED EVEN IF WE ARE"
  .byte NL,4, "APART.",TM,20,".",TM,20,".",TM,20,"I BELIEVE THAT",WT,EP

  .byte NL,1, "ONE OF MY STILL CAPTIVE"
  .byte NL,2, "PEERS IS ABOUT TO BE"
  .byte NL,3, "SHIPPED TO MERMON'S"
  .byte NL,4, "FORTRESS!",TM,30," I WILL FLY YOU",WT,EP

  .byte NL,1, "TO THE DOCKS WHERE HE IS"
  .byte NL,2, "LOCATED.",TM,30," SADLY,",TM,20," I DO NOT"
  .byte NL,3, "KNOW PRECISELY WHICH"
  .byte NL,4, "VESSEL HOLDS HIM.",TM,20,".",TM,20,".",TM,20,WT,EP

  .byte NL,1, "TO HELP YOU FIGHT OFF"
  .byte NL,2, "MERMON'S EVER INCREASING"
  .byte NL,3, "HORDE,",TM,20," TYTO CAN NOW FLY"
  .byte NL,4, "AROUND YOU AT GREAT SPEED",WT,EP

  .byte NL,1, "TO PROTECT YOU.",WT,EC

rescue_barnowl:
  .byte    1, "GOODNESS GRACIOUS!",TM,30," THE"
  .byte NL,2, "PRESSURE IN MY EARS WAS"
  .byte NL,3, "GETTING UNBEARABLE.",TM,30," I CAN"
  .byte NL,4, "SEE THIS.",TM,20,".",TM,20,".",TM,20,"SUBMARINE HAS",WT,EP

  .byte NL,1, "RISEN TO THE SURFACE SINCE"
  .byte NL,2, "YOU DEFEATED THAT KRAKEN."
  .byte NL,3, "SEE.",TM,20,".",TM,20,".",TM,20,"WE HAVE ARRIVED AT"
  .byte NL,4, "MERMON'S FORTRESS!",WT,EP

  .byte NL,1, "WE'VE NOT A MOMENT TO"
  .byte NL,2, "LOSE.",TM,30," I'LL FLY YOU TO THE"
  .byte NL,3, "SURFACE OF MERMON'S VAST"
  .byte NL,4, "MECHANICAL FORTRESS.",TM,20,".",TM,20,".",TM,20,WT,EP

  .byte NL,1, "BY THE WAY,",TM,20," TYTO CAN NOW"
  .byte NL,2, "EXECUTE A POWERFUL HOMING"
  .byte NL,3, "ATTACK.",TM,30," SURELY THIS WILL"
  .byte NL,4, "HELP YOU DEFEAT MERMON!!",WT,EC

welcome_to_pirate_bay:
  .byte    1, "TOP O' THE MORNIN' TO 'E"
  .byte NL,2, "SIR...ER, FAIR..MAI..ER."
  .byte NL,3, "ELF WARRIOR...PRINCESS?"
  .byte NL,4, "WELCOME TO HUMBLE PIRATE",WT,EP

  .byte NL,1, "BAY. IF YE BE SEEKIN'"
  .byte NL,2, "QUICK RICHES, THIS BE THE"
  .byte NL,3, "PLACE FOR 'E, HEHEHEH."
  .byte NL,4, "...OH, BE THAT AN OWL?",WT,EP

  .byte NL,1, "HE BE A MIGHTY FINE"
  .byte NL,2, "SPECIMEN, AYE.",WT,EC

advice:
  .byte    1, "IF YE WANT SOME KINDLY"
  .byte NL,2, "ADVICE...BE CAREFUL WHO"
  .byte NL,3, "YOU TRUST AROUND THESE"
  .byte NL,4, "HERE DOCKS...",WT,EC

if_you_want_my_submarine:
  .byte    1, "MERMON'S FARTRESS IS WHAT"
  .byte NL,2, "YE SEEK??? ...THE ONLY WAY"
  .byte NL,3, "TA GET THERE STEALTH LIKE"
  .byte NL,4, "MIGHT BE IN MY SUBMARINE.",WT,EP

  .byte NL,1, "YE'LL HAVE TA PAY NEARLY"
  .byte NL,2, "SIXTY THOUSAND GOLD PIECES"
  .byte NL,3, "TA THE OWL TOTEM TA RENT"
  .byte NL,4, "IT FROM ME MATEY...I",WT,EP

  .byte NL,1, "RECKON YE HAVEN'T THE"
  .byte NL,2, "FUNDS...",WT,EC

target_game_intro:
  .byte    1, "WELCOME TO ME HUMBLE"
  .byte NL,2, "POYRIT TARRGET GAME."
  .byte NL,3, "IT'LL COST YA TEN"
  .byte NL,4, "THOUSAND GOLD PIECES TA",WT,EP

  .byte NL,1, "PLAY. FASTER TARGETS"
  .byte NL,2, "EARN MORE POINTS. SEE"
  .byte NL,3, "THE NUMBER AT THE TOP"
  .byte NL,4, "O' THE BOARD?",WT,EP

  .byte NL,1, "WILL YOU PAY?"
  .byte NL,2, "PRESS A FOR YES"
  .byte NL,3, "PRESS B FOR NO",CC,EC

target_game_not_enough_gp:
  .byte    1, "ARRR...WHAT'RE YE TRYIN'"
  .byte NL,2, "TA PULL MATEY? YE HAVEN'T"
  .byte NL,3, "SUFFICIENT FUNDS TA PLAY"
  .byte NL,4, "ME GAME.",WT,EC

target_game_during:
  .byte    1, "...WHAT'RE YE TALKIN'"
  .byte NL,2, "TA ME FORR? KEEP SHOOTIN!",WT,EC

target_game_win:
  .byte    1, "YE EARNED PLENTY POINTS!"
  .byte NL,2, "CONGRATULATIONS. HERE'S"
  .byte NL,3, "TWENTY THOUSAND GOLD"
  .byte NL,4, "PIECES IN REWARD.",WT,EC

target_game_lose:
  .byte    1, "...YA DIDN'T HIT ENOUGH"
  .byte NL,2, "TARGETS MATEY. BETTER"
  .byte NL,3, "LUCK IF YE TRY AGAIN.",WT,EC

ring_game_intro:
  .byte    1, "WELCOME TO ME HUMBLE"
  .byte NL,2, "POYRIT RING FETCHIN'"
  .byte NL,3, "GAME. IT'LL COST YA TEN"
  .byte NL,4, "THOUSAND GOLD PIECES TA",WT,EP

  .byte NL,1, "PLAY. YE GET FIFTEEN TRIES"
  .byte NL,2, "TO LAND RINGS ON ALL THEM"
  .byte NL,3, "RUM BOTTLES.",WT,EP

  .byte NL,1, "WILL YOU PAY?"
  .byte NL,2, "PRESS A FOR YES"
  .byte NL,3, "PRESS B FOR NO",CC,EC

ring_game_not_enough_gp:
  .byte    1, "ARRR...WHAT'RE YE TRYIN'"
  .byte NL,2, "TA PULL MATEY? YE HAVEN'T"
  .byte NL,3, "SUFFICIENT FUNDS TA PLAY"
  .byte NL,4, "ME GAME.",WT,EC

ring_game_during:
  .byte    1, "...WHAT'RE YE TALKIN'"
  .byte NL,2, "TA ME FORR? KEEP TRYIN!",WT,EC

ring_game_win:
  .byte    1, "ARR, CONGRATULATIONS."
  .byte NL,2, "YE LANDED A RING ON EACH"
  .byte NL,3, "BOTTLE. JUST FETCH THE"
  .byte NL,4, "GOLD THAT WERE IN EACH",WT,EP

  .byte NL,1, "BOTTLE. PLEASE COME BACK"
  .byte NL,2, "AGAIN SO'S I CAN SET UP"
  .byte NL,3, "THE GAME AGAIN.",WT,EC

ring_game_lose:
  .byte    1, "...YA DIDN'T GET ENOUGH"
  .byte NL,2, "RINGS ON BOTTLES MATEY."
  .byte NL,3, "WHY DON'T YE TRY AGAIN?",WT,EC

welcome_aboard:
  .byte    1, "WELCOME ABOARD ME HUMBLE"
  .byte NL,2, "SUBMARINE. IT'LL BE A FEW"
  .byte NL,3, "FATHOMS TIL WE CATCH UP"
  .byte NL,4, "WITH MERMON'S FORTRESS..",WT,EP

  .byte NL,1, "WHY DON'T YE ENJOY THE"
  .byte NL,2, "SIGHTS O' THE DEEP SEAS"
  .byte NL,3, "WHILE WE TRAVEL?",WT,EC

what_was_that:
  .byte    1, "WHAT WAS THAT!?"
  .byte NL,2, "WE'VE LOST POWER!!",WT,EC

mermon_ha_ha_ha:
  .byte    1, "HA HA HA.",TM,30,".",TM,30,".",WT,EC

mermon_threat:
  .byte    1, "YOU AND YOUR PUNY OWL"
  .byte NL,2, "ARE NO MATCH FOR ME. I"
  .byte NL,3, "ALREADY POSSESS THE POWER"
  .byte NL,4, "OF SILMARAN! PREPARE",WT,EP

  .byte NL,1, "YOURSELVES!!!",WT,EC

silmaran_final_encounter:
  .byte    1, "ADLANNIEL.",TM,30," TYTO.",TM,30," YOU HAVE"
  .byte NL,2, "RESCUED ALL OF THE GREAT"
  .byte NL,3, "OWL KINGS OF OWLIA AND"
  .byte NL,4, "DEFEATED MERMON.",TM,30," THIS",WT,EP

  .byte NL,1, "GREAT FORTRESS OF HIS WILL"
  .byte NL,2, "NOW SINK TO THE DEEPEST,"
  .byte NL,3, "DARKEST ABYSS,",TM,20," NEVER TO"
  .byte NL,4, "RISE AGAIN.",WT,EP

  .byte NL,1, "YOUR BRAVERY AND COURAGE"
  .byte NL,2, "WILL BE REMEMBERED FOR ALL"
  .byte NL,3, "TIME.",TM,30," NOW,",TM,20," LET ME TAKE YOU"
  .byte NL,4, "TO SAFETY!",WT,EC
