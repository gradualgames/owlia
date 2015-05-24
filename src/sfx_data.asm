.feature force_range
.include "sfx_data.inc"
.include "soundengine.inc"

.segment "ROM06"

;****************************************************************
;volume envelopes
;****************************************************************

sfx_volume_envelope_silence:
  .byte 0, ENV_STOP

sfx_volume_envelope_loud:
  .byte 15, ENV_STOP

sfx_volume_envelope_door:
  .byte 10,7,5,4,0,ENV_STOP

sfx_volume_envelope_flap:
  .byte 3,5,9,12,13,10,6,3,5,7,8,9,8,6,0,ENV_LOOP

sfx_volume_envelope_sword:
  .byte 3,4,6,9,9,0,ENV_STOP

sfx_volume_envelope_explosion:
  .byte 15,10,6,2,0,0,ENV_STOP

sfx_volume_envelope_text:
  .byte 3,1,0,ENV_STOP

sfx_volume_envelope_get_item:
  .byte 10,7,4,2,0,ENV_STOP

sfx_volume_envelope_key:
  .byte 10,7,3,0,ENV_STOP

sfx_volume_envelope_cursor:
  .byte 11,6,1,0,0,ENV_STOP

sfx_volume_envelope_select:
  .byte 14,11,8,5,2,0,ENV_STOP

sfx_volume_envelope_inventory:
  .byte 2,3,5,7,8,10,12,0,ENV_STOP

sfx_volume_envelope_error:
  .byte 12,10,9,8,6,2,ENV_STOP

sfx_volume_envelope_hit:
  .byte 15,6,10,15,9,2,0,ENV_STOP

sfx_volume_envelope_hero_hit:
  .byte 14, 12, 11, 9, 7, 6, 4, 2, 1, 0, 0,ENV_STOP

sfx_volume_envelope_monolith:
  .byte 2,3,3,4,5,6,6,8,9,9,0,15,14,12,9,6,4,3,2,2,1,1,1,0,ENV_STOP

sfx_volume_envelope_chest_open:
  .byte 10,7,4,2,0,ENV_STOP

sfx_volume_envelope_chest_melody:
  .byte 3,4,6,7,9,9,10,11,11,12,12,12,12,13,13,13,13,13,14,14,11,8,3,2,0,ENV_STOP

sfx_volume_envelope_solve_puzzle:
  .byte 3,4,6,7,9,9,10,11,11,12,12,12,12,13,13,13,13,13,14,14,11,8,3,2,0,ENV_STOP

sfx_volume_envelope_octoboss_rise:
  .byte 0,1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,7,7,8,8,8,9,9,10,11,11,12,12,12,12,13,13,13,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,12,11,10,8,5,3,1,0,0,0,ENV_STOP

sfx_volume_envelope_ice_explosion:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP

sfx_volume_envelope_whoosh:
  .byte 1,2,2,3,4,4,4,4,5,5,6,6,6,7,8,8,8,8,7,7,7,7,7,7,7,6,6,6,6,6,6,6,5,5,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,2,2,2,2,2,2,2,1,1,1,0,0,0,0,ENV_STOP

sfx_volume_envelope_coins:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP

sfx_volume_envelope_boom:
  .byte 12,12,11,11,10,10,9,9,9,8,8,8,7,7,7,5,5,5,4,4,3,3,3,3,2,3,3,3,2,2,2,1,0,ENV_STOP

;****************************************************************
;pitch envelopes
;****************************************************************

sfx_pitch_envelope_flat:
  .byte 0, ENV_LOOP

sfx_pitch_envelope_vibrato:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP

sfx_pitch_envelope_long_slide_down:
  .byte 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,ENV_STOP

;****************************************************************
;duty envelopes
;****************************************************************

sfx_duty_envelope_standard:
  .byte 0, DUTY_ENV_STOP
sfx_duty_envelope_ooo:
  .byte -128,DUTY_ENV_LOOP

;****************************************************************
;luts
;****************************************************************

sfx_volume_envelopes:
  .word sfx_volume_envelope_silence
  .word sfx_volume_envelope_loud
  .word sfx_volume_envelope_door
  .word sfx_volume_envelope_flap
  .word sfx_volume_envelope_sword
  .word sfx_volume_envelope_explosion
  .word sfx_volume_envelope_text
  .word sfx_volume_envelope_get_item
  .word sfx_volume_envelope_key
  .word sfx_volume_envelope_cursor
  .word sfx_volume_envelope_select
  .word sfx_volume_envelope_inventory
  .word sfx_volume_envelope_error
  .word sfx_volume_envelope_hit
  .word sfx_volume_envelope_hero_hit
  .word sfx_volume_envelope_monolith
  .word sfx_volume_envelope_chest_open
  .word sfx_volume_envelope_chest_melody
  .word sfx_volume_envelope_solve_puzzle
  .word sfx_volume_envelope_octoboss_rise
  .word sfx_volume_envelope_ice_explosion
  .word sfx_volume_envelope_whoosh
  .word sfx_volume_envelope_coins
  .word sfx_volume_envelope_boom

sfx_pitch_envelopes:
  .word sfx_pitch_envelope_flat
  .word sfx_pitch_envelope_vibrato
  .word sfx_pitch_envelope_long_slide_down

sfx_duty_envelopes:
  .word sfx_duty_envelope_standard
  .word sfx_duty_envelope_ooo

;****************************************************************
;sound effects sets
;****************************************************************

sfx_set1:
  .word sfx_volume_envelopes
  .word sfx_pitch_envelopes
  .word sfx_duty_envelopes

;****************************************************************
;sound effect definitions
;****************************************************************

sfx_hit:
  .byte STV,sfx_volume_envelope_index_hit,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,20,8
  .byte TRM

sfx_hero_hit:
  .byte STV,sfx_volume_envelope_index_hero_hit, STP, 0, SDU, 0, STL, 50, 5
  .byte TRM

sfx_sword:
  .byte STV,sfx_volume_envelope_index_sword,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,6,8
  .byte TRM

sfx_door:
  .byte STV,sfx_volume_envelope_index_door,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,6,10,15
  .byte TRM

sfx_flap:
  .byte STV,sfx_volume_envelope_index_flap,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,45,9
  .byte TRM

sfx_explosion:
  .byte STV,sfx_volume_envelope_index_explosion,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,2,3,4,6,8,10,11,STL,6,13
  .byte TRM

sfx_text:
  .byte STV,sfx_volume_envelope_index_text,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,3,F4
  .byte TRM

sfx_get_item:
  .byte STV,sfx_volume_envelope_index_get_item,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_ooo,STL,3,D6,A6,STV,0,D6
  .byte TRM

sfx_move_cursor:
  .byte STV,sfx_volume_envelope_index_cursor,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,5,11
  .byte TRM

sfx_select:
  .byte STV,sfx_volume_envelope_index_select,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_ooo,STL,2,GS3,GS4,GS5
  .byte TRM

sfx_inventory:
  .byte STV,sfx_volume_envelope_index_inventory,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_ooo,STL,6,G4,G3,G2,G1,G2,G3
  .byte TRM

sfx_error:
  .byte STV,sfx_volume_envelope_index_error,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,4,B1,F1
  .byte TRM

sfx_monolith_slam:
  .byte STV,sfx_volume_envelope_index_monolith,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,24,15
  .byte TRM

sfx_chest_open:
  .byte STV,sfx_volume_envelope_index_chest_open,SDU,sfx_duty_envelope_index_standard,STL,4,$6,$3
  .byte TRM

sfx_chest_melody:
  .byte STV,sfx_volume_envelope_index_chest_melody,STP,sfx_pitch_envelope_index_vibrato,SDU,sfx_duty_envelope_index_ooo,STL,4,C2,D2,E2,FS2,GS2,AS2,C3,E3,GS3,STL,32
  .byte C4
  .byte TRM

sfx_solved_puzzle_instrument_one:
  .byte STV,sfx_volume_envelope_index_solve_puzzle,STP,sfx_pitch_envelope_index_vibrato,SDU,sfx_duty_envelope_index_ooo,STL,6,C3,G3,E3,G3,F3,C4,A3,C4,G3,D4,B3
  .byte F4,STL,32,E4
  .byte TRM

sfx_solved_puzzle_instrument_two:
  .byte STV,sfx_volume_envelope_index_solve_puzzle,STP,sfx_pitch_envelope_index_vibrato,SDU,sfx_duty_envelope_index_ooo,STL,6,E3,C4,G3,C4,A3,F4,C4,F4,D4,B4,F4
  .byte B4,STL,32,C5
  .byte TRM

sfx_octoboss_rise:
  .byte STV,sfx_volume_envelope_index_octoboss_rise,STL,64,$10
  .byte TRM

sfx_octoboss_punch:
  .byte STV,sfx_volume_envelope_index_loud,STP,sfx_pitch_envelope_index_long_slide_down,STL,50,C4
  .byte TRM

sfx_ice_shatter_square:
  .byte STV,sfx_volume_envelope_index_ice_explosion,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,2,C7,C7,AS7,F7,STL,16,A7
  .byte TRM

sfx_ice_shatter_noise:
  .byte STV,sfx_volume_envelope_index_ice_explosion,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,16,$8
  .byte TRM

sfx_whoosh:
  .byte STV,sfx_volume_envelope_index_whoosh,STP,sfx_pitch_envelope_index_flat,STL,64,$9
  .byte TRM

sfx_coins_square1:
  .byte STV,sfx_volume_envelope_index_coins,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,4,C7,D7,E7,F7
  .byte TRM

sfx_coins_square2:
  .byte STV,sfx_volume_envelope_index_coins,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,4,C7,CS7,D7,DS7
  .byte TRM

sfx_boom:
  .byte STV,sfx_volume_envelope_index_boom,STP,sfx_pitch_envelope_index_flat,SDU,sfx_duty_envelope_index_standard,STL,33,15
  .byte TRM

