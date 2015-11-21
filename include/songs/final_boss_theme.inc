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
  .byte 4,4,4,4,0,0,ENV_STOP
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
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
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
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
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
  .byte 128,DUTY_ENV_STOP
duty4:
  .byte 128,0,DUTY_ENV_STOP

square1:
  .byte STV,9,STP,4,SDU,4,SLL,6,C2,C2,C2,C2,B1,B1,B1,B1,AS1,AS1
  .byte AS1,AS1,A1,A1,A1,A1,C2,C2,C2,C2,B1,B1,B1,B1,AS1,AS1,AS1
  .byte AS1,A1,A1,A1,A1,G1,G1,G1,G1,FS1,FS1,FS1,FS1,F1,F1,F1,F1
  .byte E1,E1,E1,E1,G1,G1,G1,G1,FS1,FS1,FS1,FS1,F1,F1,F1,F1,E1
  .byte E1,E1,E1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1
  .byte B1,B1,B1,D1,D1,D1,D1,D1,D1,D1,D1,AS1,AS1,AS1,AS1,AS1,AS1
  .byte AS1,AS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1
  .byte B1,B1,B1,E1,E1,C2,C2,F1,F1,CS2,CS2,FS1,FS1,D2,D2,G1,G1
  .byte DS2,DS2,DS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1
  .byte B1,B1,B1,D1,D1,D1,D1,D1,D1,D1,D1,AS1,AS1,AS1,AS1,AS1,AS1
  .byte AS1,AS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1
  .byte B1,B1,B1,E1,E1,C2,C2,F1,F1,CS2,CS2,FS1,FS1,D2,D2,G1,G1
  .byte DS2,DS2
  .byte GOT
  .word square1

square2:
  .byte STV,9,STP,4,SDU,4,SLL,6,G2,G2,G2,G2,FS2,FS2,FS2,FS2,F2
  .byte F2,F2,F2,E2,E2,E2,E2,G2,G2,G2,G2,FS2,FS2,FS2,FS2,F2,F2
  .byte F2,F2,E2,E2,E2,E2,D2,D2,D2,D2,CS2,CS2,CS2,CS2,C2,C2,C2
  .byte C2,B1,B1,B1,B1,D2,D2,D2,D2,CS2,CS2,CS2,CS2,C2,C2,C2,C2
  .byte B1,B1,B1,B1,DS2,FS2,F2,GS2,G2,AS2,A2,AS2,SLL,48,B2,SLL,6
  .byte D2,E2,DS2,F2,E2,FS2,F2,GS2,SLL,48,AS2,SLL,6,DS2,FS2,F2
  .byte GS2,G2,AS2,A2,AS2,SLL,48,B2,SLL,6,E2,F2,B2,C3,F2,FS2,C3
  .byte CS3,FS2,G2,CS3,D3,G2,GS2,D3,DS3,DS2,FS2,F2,GS2,G2,AS2
  .byte A2,AS2,SLL,48,B2,SLL,6,D2,E2,DS2,F2,E2,FS2,F2,GS2,SLL,48
  .byte AS2,SLL,6,DS2,FS2,F2,GS2,G2,AS2,A2,AS2,SLL,48,B2,SLL,6
  .byte E2,F2,B2,C3,F2,FS2,C3,CS3,FS2,G2,CS3,D3,G2,GS2,D3,DS3

  .byte GOT
  .word square2

triangle:
  .byte STV,11,STP,4,SLL,128,SLH,1,A0,STV,0,SDU,0,SLL,6,DS2,DS1
  .byte DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1,B1,B1,B1,D1,D1,D1
  .byte D1,D1,D1,D1,D1,AS1,AS1,AS1,AS1,AS1,AS1,AS1,AS1,DS1,DS1
  .byte DS1,DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1,B1,B1,B1,E1,E1,C2
  .byte C2,F1,F1,CS2,CS2,FS1,FS1,D2,D2,G1,G1,DS2,DS2,DS2,DS1,DS1
  .byte DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1,B1,B1,B1,D1,D1,D1,D1
  .byte D1,D1,D1,D1,AS1,AS1,AS1,AS1,AS1,AS1,AS1,AS1,DS1,DS1,DS1
  .byte DS1,DS1,DS1,DS1,DS1,B1,B1,B1,B1,B1,B1,B1,B1,E1,E1,C2,C2
  .byte F1,F1,CS2,CS2,FS1,FS1,D2,D2,G1,G1,DS2,DS2
  .byte GOT
  .word triangle

noise:
  .byte STV,2,STP,4,SLL,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  .byte 0,0,0,0,0
  .byte GOT
  .word noise

