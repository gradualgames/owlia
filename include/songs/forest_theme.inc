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
  .byte 10,9,8,7,6,5,4,4,3,3,3,2,1,1,1,0,ENV_STOP
volume2:
  .byte 3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,3,ENV_STOP
volume3:
  .byte 3,4,4,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,0,0,ENV_STOP
volume4:
  .byte 4,4,4,4,4,0,ENV_STOP
volume5:
  .byte 1,1,1,1,1,1,1,1,1,ENV_STOP
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
  .byte STV,5,STP,0,SDU,1,STL,20,CS2,GS2,DS3,GS2,CS2,GS2,DS3,GS2
  .byte CS2,GS2,DS3,GS2,CS2,GS2,DS3,GS2,CS2,GS2,DS3,AS3,CS2,GS2
  .byte DS3,AS3,CS2,GS2,DS3,AS3,CS2,GS2,DS3,AS3,STL,10,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3,CS3,DS3
  .byte CS3,DS3,CS3,DS3,B2,CS3,B2,CS3,B2,CS3,B2,CS3,AS2,B2,AS2
  .byte B2,AS2,B2,AS2,B2,A2,B2,A2,B2,GS2,DS3,GS2,DS3
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,1,SDU,2,STL,80,CS3,STL,10,CS3,STL,50,DS3,STL,20
  .byte GS2,STL,10,F3,FS3,GS3,FS3,STL,40,F3,STV,5,STP,0,SDU,1
  .byte STL,10,F4,FS4,GS4,FS4,STL,40,F4,STV,3,STP,1,SDU,2,STL,80
  .byte CS3,STL,10,CS3,DS3,STL,60,AS3,STL,10,C4,GS3,AS3,F4,STL,40
  .byte CS4,STV,5,STP,0,SDU,1,STL,10,C4,GS3,AS3,F4,STL,40,CS4
  .byte STV,3,STP,1,SDU,2,STL,20,CS4,STL,10,B3,AS3,STL,20,GS3
  .byte STL,10,AS3,B3,STL,20,CS4,STL,10,CS4,GS3,STL,20,CS3,STL,10
  .byte CS3,GS3,STL,20,CS4,STL,10,B3,AS3,STL,20,GS3,STL,10
  .byte AS3,B3,STL,20,E4,STL,10,DS4,CS4,STL,40,CS3,STL,20,CS4
  .byte STL,10,B3,AS3,STL,20,GS3,STL,10,AS3,B3,STL,20,CS4,STL,10
  .byte CS4,GS3,STL,20,CS3,STL,10,CS3,GS3,STL,20,CS4,STL,10
  .byte B3,AS3,STL,20,GS3,STL,10,AS3,B3,STL,20,E4,STL,10,DS4,CS4
  .byte STL,40,CS3,STL,10,DS3,E3,AS3,B3,STL,120,E4,STL,10,DS3
  .byte E3,GS3,AS3,STL,120,DS4,STL,10,CS3,DS3,E3,GS3,STL,120
  .byte CS4,STL,10,CS3,DS3,E3,GS3,STL,40,AS3,A3,GS3
  .byte GOT
  .word square2

triangle:
  .byte STV,4,STP,2,SDU,3,STL,20,CS2,STL,140,CS2,STL,20,CS2,STL,140
  .byte CS2,STL,20,CS2,STL,140,CS2,STL,20,CS2,STL,140,CS2,STL,10
  .byte CS3,GS3,STL,60,CS4,STL,10,CS3,GS3,STL,60,CS4,STL,10
  .byte CS3,GS3,STL,60,CS4,STL,10,CS3,GS3,STL,60,CS4,STL,10
  .byte CS3,GS3,STL,60,CS4,STL,10,CS3,GS3,STL,60,CS4,STL,10
  .byte CS3,GS3,STL,60,CS4,STL,10,CS3,GS3,STL,140,CS4,STL,10
  .byte CS2,CS2,CS2,CS2,STL,120,CS2,STL,10,CS2,CS2,CS2,CS2,STL,120
  .byte CS2,STL,10,B1,B1,B1,B1,STL,120,B1,STL,10,A1,A1,A1,A1,GS1
  .byte GS1,GS1,GS1
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STP,2,STL,255,A0,A0,A0,A0,A0,A0,A0,STL,135,A0
  .byte GOT
  .word noise
