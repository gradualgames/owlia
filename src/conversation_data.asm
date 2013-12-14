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
  .byte 1, W,E,L,C,O,M,E,EN,WT,EC
  .byte 2, H,_A,V,E,SP,_A,SP,L,O,O,K,SP,_A,R,O,U,N,D,SP,_A,T,EL
  .byte 3, T,H,I,S,SP,D,E,M,O,SP,O,F,SP,O,U,R,SP,I,N,EL
  .byte 4, D,E,V,E,L,O,P,M,E,N,T,SP,T,I,T,L,E,EN,WT,EP,EL
  .byte 1, D,O,SP,N,O,T,SP,F,O,R,G,E,T,EL
  .byte 2, T,O,SP,T,R,_Y,SP,H,I,T,T,I,N,G,SP,B,O,T,H,WT,EL
  .byte 3, _A,SP,_A,N,D,SP,B,SP,_A,N,D,PD,PD,PD,WT,EP,EL
  .byte 1, V,I,S,I,T,SP,H,O,U,S,E,S,EN,WT,EC

welcome_to_my_house:
  .byte 1, W,E,L,C,O,M,E,SP,T,O,SP,M,_Y,SP,H,O,U,S,E,EN,WT,EC

welcome_to_my_store:
  .byte 1, W,E,L,C,O,M,E,SP,T,O,SP,M,_Y,SP,S,T,O,R,E,EN,WT,EL
  .byte 2, I,F,SP,_Y,O,U,SP,S,E,E,SP,_A,N,_Y,T,H,I,N,G,SP,_Y,O,U,SP,L,I,K,E,CA,EL
  .byte 3, W,_A,L,K,SP,U,P,SP,T,O,SP,I,T,SP,_A,N,D,SP,H,I,T,SP,_A,PD,WT,EC

welcome_to_my_inn:
  .byte 1, W,E,L,C,O,M,E,SP,T,O,SP,M,_Y,SP,I,N,N,EN,WT,EL
  .byte 2, M,_A,K,E,SP,_Y,O,U,R,S,E,L,F,SP,_A,T,SP,H,O,M,E,EN,WT,EC

prompt_for_stay_at_inn:
  .byte 1, O,N,E,SP,N,I,G,H,T,SP,I,S,SP,T,E,N,SP,G,P,PD,EL
  .byte 2, T,O,SP,S,T,_A,_Y,CA,SP,H,I,T,SP,_A,PD,EL
  .byte 3, I,F,SP,N,O,T,CA,SP,H,I,T,SP,B,PD,CC,EC

door_is_locked:
  .byte 1, T,H,I,S,SP,D,O,O,R,SP,I,S,SP,L,O,C,K,E,D,EN,WT,EC

purchase_bomb:
  .byte 1, B,O,M,B,S,SP,_A,R,E,SP,T,E,N,SP,G,P,PD,EL
  .byte 2, B,U,_Y,QN,EL
  .byte 3, H,I,T,SP,_A,SP,F,O,R,SP,_Y,E,S,EL
  .byte 4, H,I,T,SP,B,SP,F,O,R,SP,N,O,CC,EC

purchase_lantern:
  .byte 1, L,_A,N,T,E,R,N,S,SP,_A,R,E,SP,T,E,N,SP,G,P,PD,EL
  .byte 2, B,U,_Y,QN,EL
  .byte 3, H,I,T,SP,_A,SP,F,O,R,SP,_Y,E,S,EL
  .byte 4, H,I,T,SP,B,SP,F,O,R,SP,N,O,CC,EC

purchase_health:
  .byte 1, H,E,_A,L,T,H,SP,I,S,SP,T,E,N,SP,G,P,PD,EL
  .byte 2, B,U,_Y,QN,EL
  .byte 3, H,I,T,SP,_A,SP,F,O,R,SP,_Y,E,S,EL
  .byte 4, H,I,T,SP,B,SP,F,O,R,SP,N,O,CC,EC

purchase_rope:
  .byte 1, R,O,P,E,SP,I,S,SP,T,E,N,SP,G,P,PD,EL
  .byte 2, B,U,_Y,QN,EL
  .byte 3, H,I,T,SP,_A,SP,F,O,R,SP,_Y,E,S,EL
  .byte 4, H,I,T,SP,B,SP,F,O,R,SP,N,O,CC,EC

not_enough_gp:
  .byte 1, _Y,O,U,SP,D,O,SP,N,O,T,SP,H,_A,V,E,SP,E,N,O,U,G,H,SP,G,P,PD,WT,EC

intro_cut_scene_slide1_text:
  .byte 1, T,H,E,S,E,SP,_A,R,E,SP,O,W,L,S,PD,TM,75,EL
  .byte 2, T,H,E,_Y,SP,W,I,L,L,SP,B,O,R,E,SP,_A,EL
  .byte 3, H,O,L,E,SP,I,N,SP,_Y,O,U,R,SP,S,O,U,L,PD,TM,75,EC
