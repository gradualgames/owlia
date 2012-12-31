.include "sfx_data.inc"
.include "soundengine.inc"

.segment "CODE"

sfx_volume_envelope_silence:
  .byte 0, ENV_STOP

sfx_volume_envelope_loud:
  .byte 15, ENV_STOP

;used for hit
sfx_volume_envelope_2:
  .byte 14, 12, 11, 9, 7, 6, 4, 2, 1, 0, 0, ENV_STOP

;used for door slam
sfx_volume_envelope_3:
  .byte 10,7,5,4,0,ENV_STOP

;used for flapping
sfx_volume_envelope_4:
  .byte 3,5,9,12,13,10,6,3,5,7,8,9,8,6,0,ENV_LOOP

;used for sword
sfx_volume_envelope_5:
  .byte 3,4,6,9,9,0,ENV_STOP

;used for explosion
sfx_volume_envelope_6:
  .byte 15,10,6,2,0,0,ENV_STOP

;used for text
sfx_volume_envelope_7:
  .byte 3,1,0,ENV_STOP

sfx_pitch_envelope_0:
  .byte 0, ENV_LOOP

sfx_pitch_envelope_1:
  .byte 0, 1, 2, 3, 4, 5, 4, 3, 2, 1, -1, -2, -3, -4, -5, ENV_LOOP

sfx_duty_envelope_0:
  .byte 0, ENV_LOOP
sfx_duty_envelope_1:
  .byte -128,ENV_LOOP

sfx_volume_envelopes:
  .word sfx_volume_envelope_silence
  .word sfx_volume_envelope_loud
  .word sfx_volume_envelope_2
  .word sfx_volume_envelope_3
  .word sfx_volume_envelope_4
  .word sfx_volume_envelope_5
  .word sfx_volume_envelope_6
  .word sfx_volume_envelope_7

sfx_pitch_envelopes:
  .word sfx_pitch_envelope_0
  .word sfx_pitch_envelope_1

sfx_duty_envelopes:
  .word sfx_duty_envelope_0
  .word sfx_duty_envelope_1

sfx_set1:
  .word sfx_volume_envelopes
  .word sfx_pitch_envelopes
  .word sfx_duty_envelopes

sfx_test:
  .byte STV,2, STP, 0, SDU, 0, STL, 50, 5
  .byte TRM

sfx_sword:
  .byte STV,5,STP,0,SDU,0,STL,6,8
  .byte TRM

sfx_door:
  .byte STV,3,STP,0,SDU,0,STL,6,10,15
  .byte TRM

sfx_flap:
  .byte STV,4,STP,0,SDU,0,STL,45,9
  .byte TRM

sfx_explosion:
  .byte STV,6,STP,0,SDU,0,STL,2,3,4,6,8,10,11,13
  .byte TRM

sfx_text:
  .byte STV,7,STP,0,SDU,0,STL,3,F4
  .byte TRM
