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

pitch:
  .word pitch0
  .word pitch1
  .word pitch2

duty:
  .word duty0
  .word duty1
  .word duty2
  .word duty3

volume0:
  .byte 7,5,2,0,ENV_STOP
volume1:
  .byte 0,ENV_STOP
volume2:
  .byte 3,3,3,3,2,2,2,2,1,1,1,0,0,0,0,0,ENV_STOP
volume3:
  .byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,ENV_STOP
volume4:
  .byte 3,4,4,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,ENV_STOP
volume5:
  .byte 4,4,4,4,4,0,ENV_STOP
volume6:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch2:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 128,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,4,STP,1,SDU,2,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1
  .byte AS1,STL,119,F2,STL,7,CS1,AS1,B1,STL,175,AS2,STL,7,D1,A1
  .byte D2,STL,91,DS2,STL,7,D1,A1,AS1,STL,119,F2,STL,7,CS1,AS1
  .byte B1,STL,175,AS2,STL,7,D1,A1,D2,STL,91,DS2,STL,7,D1,A1,AS1
  .byte STL,119,F2,STL,7,CS1,AS1,B1,STL,175,AS2,STL,7,D1,A1,D2
  .byte STL,91,DS2,STL,7,D1,A1,AS1,STL,91,F2,STL,7,DS1,AS1,B1,STL,203
  .byte FS2,STL,56,D2,FS2,F2,C3,AS2,CS2,F2,E2,STV,3,STP,0,SDU,1
  .byte D3,FS3,F3,C4,AS3,CS3,F3,E3
  .byte GOT
  .word square1

square2:
  .byte STV,6,STP,2,STL,255,A0,STL,214,A0,STV,4,STP,1,SDU,2
  .byte STL,112,AS2,STL,7,C3,STL,91,CS3,STL,7,D3,CS3,A2,STL,84
  .byte CS2,STL,7,B2,AS2,DS2,A2,GS2,CS2,G2,FS2,C2,F2,E2,B1,G1,DS1
  .byte STL,255,B0,STL,228,B0,STL,112,AS2,STL,7,C3,STL,105
  .byte CS3,STL,7,CS3,STL,224,D3,STL,56,D3,AS2,GS2,E2,D2,CS3,GS2
  .byte G2,STV,3,STP,0,SDU,1,D4,AS3,GS3,E3,D3,CS4,GS3,STL,28
  .byte G3
  .byte GOT
  .word square2

triangle:
  .byte STV,6,STP,2,STL,255,A0,A0,A0,A0,A0,A0,A0,A0,A0,A0,STL,138
  .byte A0
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STP,2,STL,255,A0,A0,A0,A0,A0,A0,A0,A0,A0,A0,STL,138
  .byte A0
  .byte GOT
  .word noise
