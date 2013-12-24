Song1:
  .byte 100
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
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume_envelope_3:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume_envelope_4:
  .byte 0,1,2,2,3,3,4,4,4,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,ENV_STOP
volume_envelope_5:
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
  .byte 1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1
  .byte 1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1
  .byte -1,-1,1,1,ENV_STOP

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
  .byte STV,0,STL,5,A0,STV,4,STP,2,SDU,3,STL,20,D4,STL,10,D3,A3,STL,30,C4,STL,10,D4
  .byte STL,20,A4,STL,10,G4,A4,STL,30,E4,STL,10,E4,F4,A4,D5,F4,STL,30,E4,STL,10,C4
  .byte D4,F4,AS4,D4,STL,30,C4,STL,10,A3,STL,20,D4,STL,10,D3,A3,STL,30,C4,STL,10,D4
  .byte STL,20,A4,STL,10,B4,A4,STL,30,E4,STL,10,E4,F4,A4,D5,F4,STL,30,E4,STL,10,D4
  .byte E4,G4,C5,E4,STL,35,D4
  .byte GOT
  .word Square1
Square2:
  .byte STV,4,STP,2,SDU,3,STL,20,D4,STL,10,D3,A3,STL,30,C4,STL,10,D4,STL,20,A4,STL,10
  .byte G4,A4,STL,30,E4,STL,10,E4,F4,A4,D5,F4,STL,30,E4,STL,10,C4,D4,F4,AS4,D4,STL,30
  .byte C4,STL,10,A3,STL,20,D4,STL,10,D3,A3,STL,30,C4,STL,10,D4,STL,20,A4,STL,10,B4
  .byte A4,STL,30,E4,STL,10,E4,F4,A4,D5,F4,STL,30,E4,STL,10,D4,E4,G4,C5,E4,STL,40
  .byte D4
  .byte GOT
  .word Square2
Triangle:
  .byte STV,0,STL,255,A0,A0,STL,130,A0
  .byte GOT
  .word Triangle
Noise:
  .byte STV,0,STL,255,4,4,STL,130,4
  .byte GOT
  .word Noise
