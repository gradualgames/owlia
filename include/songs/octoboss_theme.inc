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
  .word volume4
  .word volume5
  .word volume6
  .word volume7
  .word volume8
  .word volume9
  .word volume10
  .word volume11

pitch:
  .word pitch0
  .word pitch1
  .word pitch2
  .word pitch3
  .word pitch4

duty:
  .word duty0
  .word duty1
  .word duty2
  .word duty3
  .word duty4

volume0:
  .byte 4,4,4,4,4,0,ENV_STOP
volume1:
  .byte 1,1,1,1,1,1,1,1,1,1,0,ENV_STOP
volume2:
  .byte 5,5,2,0,0,0,ENV_STOP
volume3:
  .byte 4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,4,3,0,ENV_STOP
volume4:
  .byte 3,4,4,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,3,3,3,ENV_STOP
volume5:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume6:
  .byte 6,5,4,2,2,1,0,0,0,0,0,0,0,0,0,0,ENV_STOP
volume7:
  .byte 0,ENV_STOP
volume8:
  .byte 7,5,2,0,ENV_STOP
volume9:
  .byte 11,9,6,3,1,1,1,ENV_STOP
volume10:
  .byte 1,1,1,1,1,1,0,ENV_STOP
volume11:
  .byte 0,ENV_STOP

pitch0:
  .byte 12,12,12,12,12,12,12,12,12,12,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,ENV_LOOP,11
pitch2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,ENV_LOOP,11
pitch3:
  .byte 120,120,120,120,120,120,120,120,ENV_STOP
pitch4:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 128,DUTY_ENV_STOP
duty3:
  .byte 64,DUTY_ENV_STOP
duty4:
  .byte 128,0,DUTY_ENV_STOP

square1:
  .byte STV,6,STP,4,SDU,3,SLL,6,E1,B1,B1,B1,B1,B1,B1,B1,E1,B1,B1
  .byte B1,B1,B1,B1,B1,E1,C2,C2,C2,C2,C2,C2,C2,FS1,FS1,FS1,FS1
  .byte FS1,FS1,FS1,FS1,E1,B1,B1,B1,B1,B1,B1,B1,E1,B1,B1,B1,B1
  .byte B1,B1,B1,E1,C2,C2,C2,C2,C2,C2,C2,DS2,DS2,DS2,DS2,DS2,DS2
  .byte DS2,DS2,E1,B1,B1,B1,B1,B1,B1,B1,E1,B1,B1,B1,B1,B1,B1,B1
  .byte E1,C2,C2,C2,C2,C2,C2,C2,FS1,FS1,FS1,FS1,FS1,FS1,FS1,FS1
  .byte E1,B1,B1,B1,B1,B1,B1,B1,E1,B1,B1,B1,B1,B1,B1,B1,E1,C2,C2
  .byte C2,C2,C2,C2,C2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,DS2,F1,F1,F1
  .byte F1,F1,F1,F1,F1,FS1,FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1
  .byte F1,F1,F1,F1,FS1,FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1,F1
  .byte F1,F1,F1,FS1,FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1,FS1,FS1
  .byte FS1,FS1,G1,G1,G1,G1,GS1,GS1,GS1,GS1,F1,F1,F1,F1,F1,F1,F1
  .byte F1,FS1,FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1,F1,F1,F1,F1
  .byte FS1,FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1,F1,F1,F1,F1,FS1
  .byte FS1,FS1,FS1,C1,C1,C1,C1,F1,F1,F1,F1,FS1,FS1,FS1,FS1,G1
  .byte G1,G1,G1,GS1,GS1,GS1,GS1
  .byte GOT
  .word square1

square2:
  .byte STV,4,STP,1,SDU,1,SLL,6,E2,C3,B2,C3,SLL,72,E3,SLL,6
  .byte E2,C3,B2,C3,SLL,72,DS3,SLL,6,B2,E3,DS3,E3,SLL,72,G3,SLL,6
  .byte B2,E3,DS3,E3,SLL,24,FS3,SLL,6,G3,FS3,E3,DS3,C3,B2,G2,FS2
  .byte E2,C3,B2,C3,SLL,72,E3,SLL,6,E2,C3,B2,C3,SLL,72,DS3,SLL,6
  .byte B2,E3,DS3,E3,SLL,72,G3,SLL,6,B2,E3,DS3,E3,B3,C4,A3,B3,G3
  .byte A3,FS3,G3,E3,FS3,DS3,B2,A2,GS2,A2,E3,SLL,72,F3,SLL,6
  .byte C3,B2,C3,GS3,SLL,72,A3,SLL,24,C4,B3,SLL,6,C4,B3,GS3,G3
  .byte F3,E3,C3,B2,A2,GS2,F2,E2,SLL,72,F2,SLL,6,A2,GS2,A2,E3,SLL,72
  .byte F3,SLL,6,C3,B2,C3,GS3,SLL,72,A3,SLL,24,C4,B3,SLL,12
  .byte F4,E4,B4,AS4,CS5,C5,B4,GS4,SLL,6,GS4,G4,FS4,F4,E4,F4,FS4
  .byte F4
  .byte GOT
  .word square2

triangle:
  .byte STV,11,STP,4,SLL,0,SLH,3,A0,STV,0,SDU,0,SLL,48,F2,SLL,24
  .byte FS2,C2,SLL,48,F2,SLL,24,FS2,C2,SLL,48,F2,SLL,24,FS2,C2
  .byte SLL,48,F2,SLL,24,G2,GS2,SLL,48,F2,SLL,24,FS2,C2,SLL,48
  .byte F2,SLL,24,FS2,C2,SLL,48,F2,SLL,24,FS2,C2,SLL,48,F2,SLL,24
  .byte G2,GS2
  .byte GOT
  .word triangle

noise:
  .byte STV,2,STP,4,SLL,48,0,0,0,0,0,0,0,SLL,24,0,0,SLL,48
  .byte 0,0,0,0,0,0,0,SLL,24,0,0,SLL,48,0,0,0,0,0,0,0,SLL,24
  .byte 0,0,SLL,48,0,0,0,0,0,0,0,SLL,24,0,0
  .byte GOT
  .word noise
