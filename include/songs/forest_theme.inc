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
  .byte STV,5,STP,0,SDU,1,STL,20,D2,A2,E3,A2,D2,A2,E3,A2,D2,A2,E3
  .byte A2,D2,A2,E3,A2,D2,A2,E3,B3,D2,A2,E3,B3,D2,A2,E3,B3,D2,A2
  .byte E3,B3,STL,10,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3
  .byte E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3
  .byte D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3
  .byte E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3
  .byte D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3
  .byte E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,D3,E3,C3,D3,C3,D3,C3,D3
  .byte C3,D3,B2,C3,B2,C3,B2,C3,B2,C3,AS2,C3,AS2,C3,A2,E3,A2,E3
  .byte GOT
  .word square1

square2:
  .byte STV,3,STP,1,SDU,2,STL,80,D3,STL,10,D3,STL,50,E3,STL,20,A2
  .byte STL,10,FS3,G3,A3,G3,STL,40,FS3,STV,5,STP,0,SDU,1,STL,10,FS4
  .byte G4,A4,G4,STL,40,FS4,STV,3,STP,1,SDU,2,STL,80,D3,STL,10,D3
  .byte E3,STL,60,B3,STL,10,CS4,A3,B3,FS4,STL,40,D4,STV,5,STP,0,SDU,1
  .byte STL,10,CS4,A3,B3,FS4,STL,40,D4,STV,3,STP,1,SDU,2,STL,20,D4
  .byte STL,10,C4,B3,STL,20,A3,STL,10,B3,C4,STL,20,D4,STL,10,D4,A3
  .byte STL,20,D3,STL,10,D3,A3,STL,20,D4,STL,10,C4,B3,STL,20,A3,STL,10
  .byte B3,C4,STL,20,F4,STL,10,E4,D4,STL,40,D3,STL,20,D4,STL,10,C4
  .byte B3,STL,20,A3,STL,10,B3,C4,STL,20,D4,STL,10,D4,A3,STL,20,D3
  .byte STL,10,D3,A3,STL,20,D4,STL,10,C4,B3,STL,20,A3,STL,10,B3,C4
  .byte STL,20,F4,STL,10,E4,D4,STL,40,D3,STL,10,E3,F3,B3,C4,STL,120
  .byte F4,STL,10,E3,F3,A3,B3,STL,120,E4,STL,10,D3,E3,F3,A3,STL,120
  .byte D4,STL,10,D3,E3,F3,A3,STL,40,B3,AS3,A3
  .byte GOT
  .word square2

triangle:
  .byte STV,4,STP,2,SDU,3,STL,20,D2,STL,140,D2,STL,20,D2,STL,140
  .byte D2,STL,20,D2,STL,140,D2,STL,20,D2,STL,140,D2,STL,10,D3,A3
  .byte STL,60,D4,STL,10,D3,A3,STL,60,D4,STL,10,D3,A3,STL,60,D4,STL,10
  .byte D3,A3,STL,60,D4,STL,10,D3,A3,STL,60,D4,STL,10,D3,A3,STL,60
  .byte D4,STL,10,D3,A3,STL,60,D4,STL,10,D3,A3,STL,140,D4,STL,10
  .byte D2,D2,D2,D2,STL,120,D2,STL,10,D2,D2,D2,D2,STL,120,D2,STL,10
  .byte C2,C2,C2,C2,STL,120,C2,STL,10,AS1,AS1,AS1,AS1,A1,A1,A1,A1
  .byte GOT
  .word triangle

noise:
  .byte STV,6,STP,2,STL,255,A0,A0,A0,A0,A0,A0,A0,STL,135,A0
  .byte GOT
  .word noise
