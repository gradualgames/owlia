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
  .word volume_envelope_5
  .word 0
  .word 0
  .word 0
  .word 0

pitch_envelopes:
  .word pitch_envelope_0
  .word 0
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
  .byte 10,9,8,7,6,6,5,4,2,1,ENV_STOP
volume_envelope_3:
  .byte 11,10,9,8,7,7,0,0,0,0,ENV_STOP
volume_envelope_4:
  .byte 8,8,7,7,7,6,6,6,5,4,4,3,2,1,1,ENV_STOP
volume_envelope_5:
  .byte 7,3,1,0,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,10,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,A1,A1,A1,A1
  .byte A1,A1,A1,A1,A1,A1,A1,A1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,G1,G1,G1,G1
  .byte G1,G1,G1,G1,G1,G1,G1,G1,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,D1,A1,A1,A1,A1
  .byte A1,A1,A1,A1,A1,A1,A1,A1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,F1,G1,G1,G1,G1
  .byte G1,G1,G1,G1,G1,G1,G1,G1
  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,0,STL,20,D3,STL,10,A2,STL,30,A2,STL,50,D3,STL,5,C3,B2,STL,30
  .byte C3,STL,20,B2,STL,10,F2,STL,60,C3,STL,20,A2,STL,10,A2,STL,30,A2,STL,50,B2,STL,10
  .byte G2,STL,40,B2,STL,10,G2,B2,D3,E3,F3,G3,A3,F3,STL,20,D3,STL,10,A2,STL,30,A2,STL
  .byte 50,D3,STL,5,C3,B2,STL,30,C3,STL,20,B2,STL,10,F2,STL,60,C3,STL,20,A2,STL,10,A2
  .byte STL,30,A2,STL,50,B2,STL,10,G2,STL,40,B2,STL,10,G2,B2,D3,E3,F3,G3,A3,F3
  .byte GOT
  .word Square2

Triangle:
  .byte STV,3,STP,0,SDU,0,STL,20,D4,STL,10,A3,STL,30,A3,STL,50,D4,STL,5,C4,B3,STL,30
  .byte C4,STL,20,B3,STL,10,F3,STL,60,C4,STL,20,A3,STL,10,A3,STL,30,A3,STL,50,B3,STL,10
  .byte G3,STL,40,B3,STL,10,G3,B3,D4,E4,F4,G4,A4,F4,STL,20,D4,STL,10,A3,STL,30,A3,STL
  .byte 10,D4,A3,D4,D4,A3,STL,5,C4,B3,STL,30,C4,STL,20,B3,STL,10,F3,C4,F3,C4,C4,F3
  .byte C4,STL,20,A3,STL,10,A3,STL,30,A3,STL,50,B3,STL,10,G3,STL,40,B3,STL,10,G3,B3,D4
  .byte E4,F4,G4,A4,F4
  .byte GOT
  .word Triangle

Noise:
  .byte STV,4,STP,0,SDU,0,STL,60,13,10,STL,50,13,STL,10,13,STL,60,10,13,10,STL,40,13
  .byte STV,5,STL,10,9,7,9,7,9,7,9,7,STV,4,STL,60,13,10,STL,50,13,STL,10,13
  .byte STL,60,10,13,10,STL,40,13,STV,5,STL,10,9,7,9,7,9,7,9,7
  .byte GOT
  .word Noise
.endscope
