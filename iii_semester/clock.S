.global main


.text

#define O_RDWR      00000002
#define O_DSYNC     00010000
#define RTC_BASE    0x01f00000
#define PROT_READ   1
#define PROT_WRITE  2
#define MAP_SHARED  1

main:
  push {lr}

  ldr r0, =dev_mem
  ldr r1, =O_RDWR | O_DSYNC
  bl open

  cmp r0, #0
  blt error

  push {r0}
  ldr r0, =clear_message
  bl printf
  pop {r0}

  ldr r1, =RTC_BASE

  push {r1}
  push {r0}

  mov r0, #0
  mov r1, #4096
  mov r2, #PROT_READ | PROT_WRITE
  mov r3, #MAP_SHARED
  bl mmap

  pop {r1}
  pop {r1}

main_loop:
  push {r0}
  ldr r0, =center_message
  bl printf
  pop {r0}
    
  push {r0}
  ldr r0, [r0, #0x14]
  mov r3, r0
  and r3, #0x3f
  lsr r0, #8
  mov r2, r0
  and r2, #0x3f
  lsr r0, #8
  mov r1, r0
  and r1, #0x1f
  ldr r0, =clocks1
  push {r1, r2, r3}
  bl printf

  ldr r0, =100000
  bl usleep

  ldr r0, =center_message
  bl printf

  pop {r1, r2, r3}
  ldr r0, =clocks2
  bl printf

  ldr r0, =400000
  bl usleep

  pop {r0}

  b main_loop


error:
  ldr r0, =error_message
  bl printf
  pop {pc}


.data

  clear_message: .asciz "\033[2J"
  center_message: .asciz "\033[1;3;32m\033[25A\033[80D\033[11B\033[36C"
  error_message: .asciz "Sorry, only the superuser can use the Hardware Clock.\n"

  dev_mem: .asciz "/dev/mem"
  clocks1: .asciz "%02d %02d %02d\n"
  clocks2: .asciz "%02d:%02d:%02d\n"
