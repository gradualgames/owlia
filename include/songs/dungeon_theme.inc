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

pitch_envelopes:
  .word pitch_envelope_0

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1

volume_envelope_0:
  .byte 0, ENV_STOP
volume_envelope_1:
  .byte 11,9,6,1,1,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP

duty_envelope_0:
  .byte 0, DUTY_ENV_STOP
duty_envelope_1:
  .byte 128,DUTY_ENV_STOP

Square1:
  .byte STV,1,STP,0,SDU,1,STL,18,C2,G2,C3,STL,36,D3,STL,18,C3,C2,G2,C3,STL,36,DS3
  .byte STL,18,F3,C2,G2,C3,STL,36,D3,STL,18,C3,GS2,F2,G2
  .byte GOT
  .word Square1
Square2:
  .byte STV,0,STL,255,A0,STL,123,A0
  .byte GOT
  .word Square2
Triangle:
  .byte STV,0,STL,255,A0,STL,123,A0
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,STL,123,4
  .byte GOT
  .word Noise
