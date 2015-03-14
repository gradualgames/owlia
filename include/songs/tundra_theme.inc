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

pitch:
  .word pitch0
  .word pitch1

duty:
  .word duty0
  .word duty1

volume0:
  .byte 2,3,4,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,ENV_STOP
volume1:
  .byte 2,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,ENV_STOP
volume2:
  .byte 4,4,4,0,ENV_STOP
volume3:
  .byte 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,ENV_STOP
volume4:
  .byte 0,ENV_STOP
volume5:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,0,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP
pitch1:
  .byte 0,ENV_STOP

duty0:
  .byte 0,64,DUTY_ENV_STOP
duty1:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,1,STP,1,SDU,0,STL,20,D2,A2,D3,A2,D2,A2,C3,G2,D2,A2
  .byte D3,A2,D2,B2,C3,G2,D2,A2,D3,A2,D2,A2,C3,G2,D2,A2,D3,A2,D2
  .byte B2,C3,G2,D2,A2,D3,A2,D2,A2,C3,G2,D2,A2,D3,A2,D2,B2,C3,G2
  .byte AS1,F2,AS2,F2,G1,D2,A2,D2,AS1,F2,AS2,F2,G1,D2,A2,D2
  .byte GOT
  .word square1

square2:
  .byte STV,4,STP,1,STL,255,D3,STL,65,D3,STV,3,STP,0,SDU,1,STL,10
  .byte D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2
  .byte E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2
  .byte B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2,A2,B2,E3,D2
  .byte A2,B2,E3,D2,A2,B2,E3,AS2,D3,A3,AS3,AS2,D3,A3,AS3,G2,D3
  .byte A3,AS3,G2,D3,A3,AS3,AS2,D3,A3,AS3,AS2,D3,A3,AS3,G2,D3,A3
  .byte AS3,G2,D3,A3,AS3
  .byte GOT
  .word square2

triangle:
  .byte STV,4,STP,1,STL,255,D3,STL,65,D3,STL,255,D3,STL,65
  .byte D3,STV,0,STP,0,SDU,0,STL,10,D4,E4,FS4,A4,STL,40,D4,STL,70
  .byte E4,STL,10,A3,E4,FS4,A4,B4,STL,40,G4,STL,80,A4,STL,20
  .byte A4,STL,10,G4,F4,STL,30,E4,STL,10,D4,STL,80,E4,STL,20
  .byte A4,STL,10,G4,A4,STL,20,C5,A4,STL,40,D5,E5
  .byte GOT
  .word triangle

noise:
  .byte STV,5,STP,1,STL,255,A0,A0,A0,A0,A0,STL,5,A0
  .byte GOT
  .word noise

