.feature force_range
.include "sfx_data.inc"
.include "soundengine.inc"

.segment "ROM06"

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

sfx_pitch_envelope_flat:
  .byte 0, ENV_LOOP

;used for get item melody
sfx_pitch_envelope_2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP

;used for octoboss punch
sfx_pitch_envelope_3:
  .byte 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,ENV_STOP

sfx_duty_envelope_0:
  .byte 0, DUTY_ENV_STOP
sfx_duty_envelope_1:
  .byte -128,DUTY_ENV_LOOP

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
  .word sfx_volume_envelope_monolith
  .word sfx_volume_envelope_chest_open
  .word sfx_volume_envelope_chest_melody
  .word sfx_volume_envelope_solve_puzzle
  .word sfx_volume_envelope_octoboss_rise
  .word sfx_volume_envelope_ice_explosion
  .word sfx_volume_envelope_whoosh

sfx_pitch_envelopes:
  .word sfx_pitch_envelope_flat
  .word 0
  .word sfx_pitch_envelope_2
  .word sfx_pitch_envelope_3

sfx_duty_envelopes:
  .word sfx_duty_envelope_0
  .word sfx_duty_envelope_1

sfx_set1:
  .word sfx_volume_envelopes
  .word sfx_pitch_envelopes
  .word sfx_duty_envelopes

sfx_hit:
  .byte STV,sfx_volume_envelope_index_hit,STP,0,SDU,0,STL,20,8
  .byte TRM

sfx_sword:
  .byte STV,sfx_volume_envelope_index_sword,STP,0,SDU,0,STL,6,8
  .byte TRM

sfx_door:
  .byte STV,sfx_volume_envelope_index_door,STP,0,SDU,0,STL,6,10,15
  .byte TRM

sfx_flap:
  .byte STV,sfx_volume_envelope_index_flap,STP,0,SDU,0,STL,45,9
  .byte TRM

sfx_explosion:
  .byte STV,sfx_volume_envelope_index_explosion,STP,0,SDU,0,STL,2,3,4,6,8,10,11,STL,6,13
  .byte TRM

sfx_text:
  .byte STV,sfx_volume_envelope_index_text,STP,0,SDU,0,STL,3,F4
  .byte TRM

sfx_get_item:
  .byte STV,sfx_volume_envelope_index_get_item,STP,0,SDU,1,STL,3,D6,A6,STV,0,D6
  .byte TRM

sfx_move_cursor:
  .byte STV,sfx_volume_envelope_index_cursor,STP,0,SDU,0,STL,5,11
  .byte TRM

sfx_select:
  .byte STV,sfx_volume_envelope_index_select,STP,0,SDU,1,STL,2,GS3,GS4,GS5
  .byte TRM

sfx_inventory:
  .byte STV,sfx_volume_envelope_index_inventory,STP,0,SDU,1,STL,6,G4,G3,G2,G1,G2,G3
  .byte TRM

sfx_error:
  .byte STV,sfx_volume_envelope_index_error,STP,0,SDU,0,STL,4,B1,F1
  .byte TRM

sfx_monolith_slam:
  .byte STV,sfx_volume_envelope_index_monolith,STP,0,SDU,0,STL,24,15
  .byte TRM

sfx_chest_open:
  .byte STV,sfx_volume_envelope_index_chest_open,SDU,0,STL,4,$6,$3
  .byte TRM

sfx_chest_melody:
  .byte STV,sfx_volume_envelope_index_chest_melody,STP,2,SDU,1,STL,4,C2,D2,E2,FS2,GS2,AS2,C3,E3,GS3,STL,32
  .byte C4
  .byte TRM

sfx_solved_puzzle_instrument_one:
  .byte STV,sfx_volume_envelope_index_solve_puzzle,STP,2,SDU,1,STL,6,C3,G3,E3,G3,F3,C4,A3,C4,G3,D4,B3
  .byte F4,STL,32,E4
  .byte TRM

sfx_solved_puzzle_instrument_two:
  .byte STV,sfx_volume_envelope_index_solve_puzzle,STP,2,SDU,1,STL,6,E3,C4,G3,C4,A3,F4,C4,F4,D4,B4,F4
  .byte B4,STL,32,C5
  .byte TRM

sfx_octoboss_rise:
  .byte STV,sfx_volume_envelope_index_octoboss_rise,STL,64,$10
  .byte TRM

sfx_octoboss_punch:
  .byte STV,sfx_volume_envelope_index_loud,STP,3,STL,50,C4
  .byte TRM

sfx_ice_shatter_square:
  .byte STV,sfx_volume_envelope_index_ice_explosion,STP,0,SDU,0,STL,2,C7,C7,AS7,F7,STL,16,A7
  .byte TRM

sfx_ice_shatter_noise:
  .byte STV,sfx_volume_envelope_index_ice_explosion,STP,0,SDU,0,STL,16,$8
  .byte TRM

sfx_whoosh:
  .byte STV,sfx_volume_envelope_index_whoosh,STP,0,STL,64,$9
  .byte TRM
