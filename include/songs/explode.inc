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
  .byte 2,ENV_STOP
volume1:
  .byte 0,ENV_LOOP

pitch0:
  .byte 0,ENV_STOP

duty0:
  .byte 128,DUTY_ENV_STOP

square1:
  .byte STV,1,STP,0,STL,255,C2,STL,129,C2
  .byte GOT
  .word square1

square2:
  .byte STV,1,STP,0,STL,255,C2,STL,129,C2
  .byte GOT
  .word square2

triangle:
  .byte STV,1,STP,0,STL,255,C2,STL,129,C2
  .byte GOT
  .word triangle

noise:
  .byte STV,0,STP,0,STL,255,15,STL,129,15
  .byte GOT
  .word noise

