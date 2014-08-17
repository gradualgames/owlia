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

pitch:
  .word pitch0

duty:
  .word duty0

volume0:
  .byte 3,4,6,7,9,9,10,11,11,12,12,12,12,13,13,13,13,13,14,14,11,8,3,2,0,ENV_STOP
volume1:
  .byte 0,ENV_STOP

pitch0:
  .byte 0,0,0,0,0,0,0,0,0,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,1,1,-1,-1,-1,-1,1,1,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,0,STP,0,SDU,0,STL,8,DS2,F2,G2,DS2,F2,G2,F2,G2,A2,F2,G2
  .byte A2,G2,A2,B2,G2,D3,G3,STL,255,G2,STL,113,G2
  .byte GOT
  .word square1

square2:
  .byte STV,0,STP,0,SDU,0,STL,8,G2,A2,AS2,G2,A2,AS2,A2,AS2,C3,A2
  .byte AS2,C3,B2,C3,D3,B2,G2,D3,STL,255,B3,STL,113,B3
  .byte GOT
  .word square2

triangle:
  .byte STV,1,STL,255,A0,A0,STL,2,A0
  .byte GOT
  .word triangle

noise:
  .byte STV,1,STL,255,A0,A0,STL,2,A0
  .byte GOT
  .word noise

