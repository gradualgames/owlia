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

duty:
  .word duty0
  .word duty1
  .word duty2
  .word duty3

volume0:
  .byte 3,2,1,0,ENV_STOP
volume1:
  .byte 0,ENV_STOP
volume2:
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume3:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume4:
  .byte 7,7,6,6,6,5,5,4,4,3,3,3,2,2,1,1,0,0,0,0,0,ENV_STOP
volume5:
  .byte 4,4,4,4,4,0,ENV_STOP
volume6:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP

duty0:
  .byte 64,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP
duty2:
  .byte 64,DUTY_ENV_STOP
duty3:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,4,STP,1,SDU,2,STL,8,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1
  .byte E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1
  .byte E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1
  .byte E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1,E1,DS1,FS1,CS1
  .byte E1,DS1,FS1,CS1,E1,DS1,FS1,STV,2,SDU,0,CS1,CS1,CS1,CS1,C1
  .byte C1,C1,C1,A0,A0,A0,A0,C1,C1,C1,C1,CS1,CS1,CS1,CS1,C1,C1,C1
  .byte C1,A0,A0,A0,A0,C1,C1,C1,C1,CS1,CS1,CS1,CS1,C1,C1,C1,C1,A0
  .byte A0,A0,A0,C1,C1,C1,C1,CS1,CS1,CS1,CS1,C1,C1,C1,C1,A0,A0,A0
  .byte A0,C1,C1,C1,C1
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,0,SDU,1,STL,96,CS3,STL,32,C3,STL,128,E3,STL,96
  .byte CS3,STL,32,C3,STL,128,E3,STL,112,GS2,STL,8,G2,E2,STL,128
  .byte GS2,STL,112,CS3,STL,8,A3,C3,STL,128,GS3
  .byte GOT
  .word square2

triangle:
  .byte STV,6,STL,255,A0,A0,A0,A0,STL,4,A0
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STL,255,A0,A0,A0,A0,STL,4,A0
  .byte GOT
  .word noise
