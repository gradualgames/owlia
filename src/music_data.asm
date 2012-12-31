.include "music_data.inc"
.include "soundengine.inc"

.segment "ROM00"

song1:
.scope
  .word Square1
  .word Square2
  .word Triangle
  .word Noise
  .word volume_envelopes
  .word pitch_envelopes
  .word duty_envelopes

volume_envelopes:
  .word volume_envelope_0
  .word volume_envelope_1
  .word volume_envelope_2
  .word volume_envelope_3
  .word volume_envelope_4
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

pitch_envelopes:
  .word pitch_envelope_0
  .word pitch_envelope_1
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

duty_envelopes:
  .word duty_envelope_0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0

volume_envelope_0:
  .byte 0, ENV_STOP

volume_envelope_1:
  .byte 15, ENV_LOOP
volume_envelope_2:
  .byte 9,9,8,8,7,6,5,4,3,2,ENV_STOP
volume_envelope_3:
  .byte 8,8,7,8,8,0,ENV_STOP
volume_envelope_4:
  .byte 4,3,2,1,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP
pitch_envelope_1:
  .byte 28,45,55,68,78,90,0,ENV_STOP

duty_envelope_0:
  .byte 0, DUTY_ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,20,G2,C2,A2,C2,F2,C2,G2,C2,B2,C2,C3,C2,A2,C2,B2,C2

  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,0,STL,10,G3,F3,E3,B3,STL,40,G3,STL,10,E3,STL,20,F3,STL,50,G3
  .byte STL,10,B3,G3,B3,E3,F3,STL,30,C4,STL,10,E3,STL,20,D3,STL,50,E3
  .byte GOT
  .word Square2

Triangle:
  .byte STV,3,STP,1,SDU,0,STL,80,D4,D4,D4,D4
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,20,A0,STV,4,STP,0,SDU,0,STL,80,2,2,2,STL,60,2
  .byte GOT
  .word Noise
.endscope
