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
  .word volume_envelope_3
  .word volume_envelope_4
  .word volume_envelope_5
  .word volume_envelope_6

pitch_envelopes:
  .word pitch_envelope_0
  .word pitch_envelope_1
  .word pitch_envelope_2

duty_envelopes:
  .word duty_envelope_0
  .word duty_envelope_1
  .word duty_envelope_2
  .word duty_envelope_3
  .word duty_envelope_4

volume_envelope_0:
  .byte 0, ENV_STOP
volume_envelope_1:
  .byte 7,5,2,0,ENV_STOP
volume_envelope_2:
  .byte 0,ENV_STOP
volume_envelope_3:
  .byte 3,3,3,3,2,2,2,2,1,1,1,0,0,0,0,0,ENV_STOP
volume_envelope_4:
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,ENV_STOP
volume_envelope_5:
  .byte 3,4,4,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,2,2
  .byte 2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,ENV_STOP
volume_envelope_6:
  .byte 4,4,4,4,4,0,ENV_STOP

pitch_envelope_0:
  .byte 0, ENV_LOOP
pitch_envelope_1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1
  .byte -1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1
  .byte 1,-1,-1,-1,-1,1,1,ENV_STOP
pitch_envelope_2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1
  .byte -1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1
  .byte 1,-1,-1,-1,-1,1,1,ENV_STOP

duty_envelope_0:
  .byte 0, DUTY_ENV_STOP
duty_envelope_1:
  .byte 128,DUTY_ENV_STOP
duty_envelope_2:
  .byte 128,DUTY_ENV_STOP
duty_envelope_3:
  .byte 128,DUTY_ENV_STOP
duty_envelope_4:
  .byte 128,DUTY_ENV_STOP

Square1:
  .byte STV,5,STP,2,SDU,3,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1,AS1,STL,119,F2,STL,7
  .byte CS1,AS1,B1,STL,175,AS2,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1,AS1,STL,119,F2
  .byte STL,7,CS1,AS1,B1,STL,175,AS2,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1,AS1,STL,119
  .byte F2,STL,7,CS1,AS1,B1,STL,175,AS2,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1,AS1
  .byte STL,91,F2,STL,7,DS1,AS1,B1,STL,203,FS2,STL,56,D2,FS2,F2,C3,AS2,CS2,F2,E2,STV,4
  .byte STP,1,SDU,2,D3,FS3,F3,C4,AS3,CS3,F3,E3
  .byte GOT
  .word Square1
Square2:
  .byte STV,0,STL,255,A0,STL,214,A0,STV,5,STP,2,SDU,3,STL,112,AS2,STL,7,C3,STL,91
  .byte CS3,STL,7,D3,CS3,A2,STL,84,CS2,STL,7,B2,AS2,DS2,A2,GS2,CS2,G2,FS2,C2,F2,E2
  .byte B1,G1,DS1,STL,255,B0,STL,228,B0,STL,112,AS2,STL,7,C3,STL,105,CS3,STL,7,CS3
  .byte STL,224,D3,STL,56,D3,A2,GS2,E2,D2,CS3,GS2,G2,STV,4,STP,1,SDU,2,D4,A3,GS3,E3
  .byte D3,CS4,GS3,STL,28,G3
  .byte GOT
  .word Square2
Triangle:
  .byte STV,0,STL,255,A0,A0,A0,A0,A0,A0,A0,A0,A0,A0,STL,138,A0
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,4,4,4,4,4,4,4,4,4,STL,138,4
  .byte GOT
  .word Noise
