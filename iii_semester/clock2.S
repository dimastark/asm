.globl main
.text

#define O_RDWR      00000002
#define O_DSYNC     00010000
#define RTC_BASE    0x01f00000
#define PROT_READ   1
#define PROT_WRITE  2
#define MAP_SHARED  1
#define TCSANOW     0
#define ECHO        0000010
#define ICANON      0000002
#define STDIN       0
#define Xkey        27
#define Space       32
#define Skey        32
#define FIONREAD    0x541B

main:
    push    {lr}

    bl      canon

    @открываем /dev/mem
    ldr     r0, =mem
    ldr     r1, =O_RDWR | O_DSYNC
    bl      open

    cmp     r0, #0
    blt     sudo_err

    @clear
    push {r0}
    ldr     r0, =clear
    bl      printf
    pop {r0}

    @ммапим
    ldr     r1, =RTC_BASE
    push    {r1}
    push    {r0}
    mov     r0, #0
    mov     r1, #4096
    mov     r2, #PROT_READ | PROT_WRITE
    mov     r3, #MAP_SHARED
    bl      mmap

    @чистим стэк от мусора
    pop     {r1}
    pop     {r1}

gogo:
    @в центр
    push    {r0}
    ldr     r0, =settocenter
    bl      printf
    pop     {r0}
    
    push    {r0}
    ldr     r0, [r0, #0x14]
    mov     r3, r0
    and     r3, #0x3f
    lsr     r0, #8
    mov     r2, r0
    and     r2, #0x3f
    lsr     r0, #8
    mov     r1, r0
    and     r1, #0x1f
    ldr     r0, =clocks
    push    {r1, r2, r3}
    bl      printf

    @спим для мигания
    ldr     r0, =97000
    bl      usleep

    @ обработка stdin    
    bl      kbhit
    cmp     r0, #0
    beq     empty_stdin1
    
    bl      getchar
    cmp     r0, #Xkey
    beq     my_exit
    cmp     r0, #Skey
    bleq    stoped

empty_stdin1:
    @включаем двоеточия
    ldr     r0, =settocenter
    bl      printf
    pop     {r1, r2, r3}

    ldr     r0, =clocks_splited
    bl      printf

    mov     r4, #4
    cycle:
        ldr     r0, =97000
        bl      usleep
        bl      kbhit
        cmp     r0, #0
        beq     empty_stdin2
        bl      getchar
        cmp     r0, #Xkey
        beq     my_exit
        cmp     r0, #Skey
        bleq    stoped
        empty_stdin2:
            subs    r4, #1
            bne     cycle

    @тут дату обновим, хотя она и не будет в нашей сдаче меняться
    pop     {r0}
    push    {r0}

    pop     {r0}
    b       gogo

    pop     {pc}

my_exit:
    bl      uncanon
    mov     r0, #1
    ldr     r1, =clear_exit
    ldr     r2, =clear_len
    mov     r7, #4
    svc     #0

    mov     r0, #0
    mov     r7, #1
    svc     #0

sudo_err:
    bl      uncanon
    ldr     r0, =sudoerrmsg
    bl      printf
    pop     {pc}


@ таймер остановлен
stoped:
    push    {lr}
    stop_cycle:
        bl      kbhit
        cmp     r0, #0
        beq     stop_cycle
        bl      getchar
        cmp     r0, #Xkey
        beq     my_exit
        cmp     r0, #Space
        beq     continue
        b       stop_cycle
    continue:
        pop     {pc}


@ Чекер STDINa
@ в status простаивает первый байт будем писать в него
kbhit:
    push    {r1, r2, lr}
    mov     r0, #STDIN
    ldr     r1, =FIONREAD
    ldr     r2, =status
    bl      ioctl
    ldr     r0, =status
    ldr     r0, [r0]
    pop     {r1, r2, pc}

canon:
    push    {lr}
    @ получаем состояние терминала
    mov     r0, #STDIN
    ldr     r1, =term1
    bl      tcgetattr
    @ сохраняем состояние в term2
    ldr     r0, =term1
    ldr     r1, =term2
    mov     r2, #60
    copy_cycle:
        ldrb    r3, [r0], #1
        strb    r3, [r1], #1
        subs    r2, #1
        bne     copy_cycle
    mov     r0, #~(ICANON | ECHO)
    ldr     r1, =term1
    ldr     r2, [r1, #12]
    and     r0, r2
    str     r0, [r1, #12]
    @ включаем canon
    mov     r0, #STDIN
    mov     r1, #TCSANOW
    ldr     r2, =term1
    bl      tcsetattr
    pop     {pc}

uncanon:
    push    {lr}
    mov     r0, #STDIN
    mov     r1, #TCSANOW
    ldr     r2, =term2
    bl      tcsetattr
    pop     {pc}

.data
symbol:         .int    0
clear:          .asciz  "\033[2J\033[?25l"
clear_exit:     .asciz  "\033[2J\033[?25h\033[25A\033[80D\033[0m"
clear_len = . - clear_exit
num:            .asciz  "%08x\n"
mem:            .asciz  "/dev/mem"
settocenter:    .asciz  "\033[1;3;32m\033[25A\033[80D\033[11B\033[36C"
clocks_splited: .asciz  "%02d:%02d:%02d\n"
clocks:         .asciz  "%02d %02d %02d\n"
date:           .asciz  "\033[37C%d %s"
sudoerrmsg:     .asciz  "Sorry, only the superuser can use the Hardware Clock.\n"
status:         .int    0

.bss
    .comm   term1, 60, 4
    .comm   term2, 60, 4
