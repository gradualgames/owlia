
Song1:
  .word 255
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
  .word 0
  .word 0
  .word 0
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

pitch_envelope_0:
  .byte 0, ENV_LOOP
pitch_envelope_1:
  .byte 0,0,2,2,0,0,-2,-2,ENV_LOOP

duty_envelope_0:
  .byte 0, DUTY_ENV_LOOP

Square1:
  .byte STV,1,STP,0,SDU,0,STL,96,D1,C1,D1,AS0,A0,AS0,C1,D1
  .byte GOT
  .word Square1

Square2:
  .byte STV,1,STP,0,SDU,0,STL,96,A1,G1,A1,F1,E1,F1,G1,A1
  .byte GOT
  .word Square2

Triangle:
  .byte STV,0,STL,48,A0,STV,1,STP,1,SDU,0,STL,96,A3,G3,STL,192,A3,STL,96,A3,G3,STL,144
  .byte A3
  .byte GOT
  .word Triangle

Noise:
  .byte STV,0,STL,255,A0,STL,255,A0,STL,255,A0,STL,3,A0
  .byte GOT
  .word Noise
