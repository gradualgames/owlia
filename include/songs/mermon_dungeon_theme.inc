song1:
  .byte 255
  .word square1
  .word square2
  .word triangle
  .word noise
  .word volume
  .word pitch
  .word duty

volume:
  .word volume0
  .word volume1
  .word volume2
  .word volume3

pitch:
  .word pitch0
  .word pitch1
  .word pitch2

duty:
  .word duty0

volume0:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,ENV_STOP
volume1:
  .byte 1,ENV_STOP
volume2:
  .byte 0,ENV_STOP
volume3:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,0,STP,0,SDU,0,STL,48,C2,C2,STL,96,D1,STL,48,D2,D2,STL,96
  .byte DS1,STL,48,DS2,STL,24,DS2,D2,C1,C2,STL,48,C1,C3,G3,STL,24
  .byte E3,D2,STL,48,D1,F3,B3,STL,24,G3,DS2,STL,72,DS1,STL,48
  .byte C4,STL,36,G3,STL,24,C2,STL,60,C1,STL,48,C1,C3,STL,24
  .byte G3,C3,STL,48,C2,C1,C3,STL,24,G3,C3,STL,48,C2,A0,A2,STL,24
  .byte E3,A2,STL,48,A1,A0,A2,STL,24,E3,A2,STL,48,A1,C1,C3,STL,24
  .byte G3,C3,STL,48,C2,C1,C3,STL,24,G3,C3,STL,48,C2,A0,A2,STL,24
  .byte E3,A2,STL,48,A1,A0,A2,STL,24,E3,A2,STL,48,A1
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,2,STL,24,A0,STV,0,STP,0,SDU,0,STL,192,C3,D3,STL,84
  .byte DS3,STL,24,C2,STL,84,C3,STL,48,GS3,STL,36,F3,STL,24
  .byte D2,STL,84,D3,STL,48,C4,STL,36,GS3,STL,24,DS2,STL,60
  .byte C3,STL,48,G3,F3,STL,24,C3,C2,STL,72,C1,STL,48,G2,STL,36
  .byte DS3,STL,24,DS3,STL,84,G2,STL,48,G2,STL,36,DS3,STL,24
  .byte DS3,STL,84,G2,STL,48,E2,STL,36,C3,STL,24,C3,STL,84
  .byte E2,STL,48,E2,STL,36,C3,STL,24,C3,STL,84,E2,STL,48,G2,STL,36
  .byte DS3,STL,24,DS3,STL,84,G2,STL,48,G2,STL,36,DS3,STL,24
  .byte DS3,STL,84,G2,STL,48,E2,STL,36,C3,STL,24,C3,STL,84
  .byte E2,STL,48,E2,STL,36,C3,STL,24,C3,STL,60,E2
  .byte GOT
  .word square2

triangle:
  .byte STV,2,STP,2,STL,255,B3,B3,B3,B3,STL,132,B3,STV,1,STP,1
  .byte STL,12,G4,D5,DS5,G5,STL,126,D5,STL,6,D5,DS5,D5,STL,192
  .byte DS5,STL,12,E5,D5,STL,168,B4,STL,144,A4,STL,48,E4,STL,12
  .byte G4,D5,DS5,G5,STL,126,D5,STL,6,D5,DS5,D5,STL,192,DS5,STL,12
  .byte E5,D5,STL,168,B4,STL,144,A4,STL,48,E4
  .byte GOT
  .word triangle

noise:
  .byte STV,3,STP,2,STL,255,A0,A0,A0,A0,A0,A0,A0,A0,A0,A0,STL,138
  .byte A0
  .byte GOT
  .word noise
