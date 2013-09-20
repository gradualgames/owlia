
Song1:
  .byte 255
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
  .word 0
  .word 0
  .word 0
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
  .word duty_envelope_1
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
  .byte 5,8,8,8,7,7,6,6,5,5,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, DUTY_ENV_LOOP
duty_envelope_1:
  .byte -128,DUTY_ENV_LOOP

Square1:
  .byte STV,2,STP,0,SDU,0,STL,20,F1,C2,G2,F1,STL,40,A2,STL,20,F1,C2,G2,F1,STL,40,A2
  .byte STL,20,D1,A1,E2,D1,STL,40,F2,STL,20,D1,A1,E2,D1,STL,40,F2,STL,20,F1,C2,G2,F1
  .byte STL,40,A2,STL,20,F1,C2,G2,F1,STL,40,A2,STL,20,D1,A1,E2,D1,STL,40,F2,STL,20,D1
  .byte A1,E2,D1,STL,40,F2
  .byte GOT
  .word Square1

Square2:
  .byte STV,2,STP,0,SDU,1,STL,20,F2,STL,10,C3,D3,STL,80,C3,STL,10,F3,E3,STL,20,D3,STL
  .byte 10,C3,D3,STL,60,C3,STL,10,A2,AS2,STL,40,A2,STL,10,C3,AS2,STL,40,A2,STL,20,G2,A2
  .byte AS2,A2,G2,F2,F2,STL,10,C3,D3,STL,80,C3,STL,10,F3,E3,STL,20,D3,STL,10,C3,D3,STL
  .byte 60,C3,STL,10,A2,AS2,STL,40,A2,STL,10,C3,AS2,STL,40,A2,STL,20,G2,A2,AS2,A2,G2,F2

  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,195,A0
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,195,A0
  .byte GOT
  .word Noise
