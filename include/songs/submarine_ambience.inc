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

pitch:
  .word pitch0
  .word pitch1

duty:

volume0:
  .byte 1,1,2,2,1,1,1,1,0,0,0,0,0,0,0,0,ENV_STOP
volume1:
  .byte 1,1,0,ENV_STOP
volume2:
  .byte 0,ENV_STOP

pitch0:
  .byte -21,-20,-18,-18,-18,ENV_STOP
pitch1:
  .byte 0,ENV_STOP


square1:
  .byte STV,2,STP,1,SLL,64,SLH,2,A0
  .byte GOT
  .word square1

square2:
  .byte STV,2,STP,1,SLL,64,SLH,2,A0
  .byte GOT
  .word square2

triangle:
  .byte STV,1,STP,0,SLL,3,G2,GS2,A2,AS2,SLL,6,B2,C3,CS3,D3,SLL,180
  .byte DS3,SLL,3,G2,GS2,A2,AS2,SLL,6,B2,C3,CS3,SLL,12,D3,SLL,9
  .byte DS3,SLL,213,E3,SLL,6,B2,SLL,12,CS3,SLL,21,E3,SLL,3,F3,SLL,54
  .byte FS3
  .byte GOT
  .word triangle

noise:
  .byte STV,0,STP,1,SLL,12,13,13,13,13,13,13,13,13,13,13,13,13
  .byte 13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13
  .byte 13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13
  .byte GOT
  .word noise

