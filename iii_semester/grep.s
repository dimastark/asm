.globl _start
.text
_start:
    ldr     r0, [sp]
    cmp     r0, #3
    bne     error_args

    ldr     r0, [sp, #8]
    mov     r1, #0
    mov     r7, #5
    svc     #0

    ldr     r1, =handler
    str     r0, [r1]

    mov     r6, #0

read_row:
    ldr     r0, =buffer
    bl      strlen
    add     r6, r6, r0
    ldr     r1, =buffer
    read_row_loop:
        mov     r0, r1
        bl      read_byte
        cmp     r0, #0
        beq     file_ended
        ldrb    r0, [r1], #1
        cmp     r0, #10
        bne     read_row_loop
    read_done:
    mov     r0, #0
    strb    r0, [r1]

    ldr     r0, =buffer
    ldr     r1, [sp, #12]
    bl      strstr
    cmp     r0, #-1
    beq     read_row

    bl      print_address

    ldr     r0, =buffer
    mov     r1, r0
    bl      strlen
    mov     r2, r0
    ldr     r1, =buffer
    mov     r0, #1
    mov     r7, #4
    svc     #0

    ldr     r0, =file_readed
    ldr     r0, [r0]
    cmp     r0, #0
    beq     exit
    b       read_row

file_ended:
    ldr     r2, =buffer
    cmp     r1, r2
    mov     r0, #0
    beq     exit
    mov     r0, #10
    strb    r0, [r1], #1
    ldr     r2, =file_readed
    mov     r0, #0
    str     r0, [r2]
    b       read_done

error_args:
    mov     r0, #1
    ldr     r1, =usage1
    mov     r2, #usage1_len
    mov     r7, #4
    svc     #0

    ldr     r0, [sp, #4]
    bl      strlen
    mov     r2, r0
    ldr     r1, [sp, #4]
    mov     r0, #1
    mov     r7, #4
    svc     #0

    mov     r0, #1
    ldr     r1, =usage2
    mov     r2, #usage2_len
    mov     r7, #4
    svc     #0

    mov     r0, #2

exit:
    mov     r7, #1
    svc     #0

print_address:
    push    {r0, r1, r2, r3, r6, lr}
    
    mov     r0, #1
    ldr     r1, =address
    mov     r2, #address_len
    mov     r7, #4
    svc     #0

    mov     r0, #16
    mov     r3, #8
    digits_to_stack:
        udiv    r2, r6, r0
        mul     r1, r2, r0
        sub     r6, r6, r1
        push    {r6}
        mov     r6, r2
        subs    r3, r3, #1
        bne     digits_to_stack
    mov     r3, #8
    print_digits:
        mov     r0, #1
        ldr     r1, =alph
        pop     {r2}
        add     r1, r1, r2
        mov     r2, #1
        mov     r7, #4
        svc     #0
        subs    r3, r3, #1
        bne     print_digits
    mov     r0, #1
    ldr     r1, =dots
    mov     r2, #dots_len
    mov     r7, #4
    svc     #0

    mov     r0, #1
    ldr     r1, =alph
    add     r1, r1, #16
    mov     r2, #1
    mov     r7, #4
    svc     #0

    mov     r0, #1
    ldr     r1, =normalize
    mov     r2, #normalize_len
    mov     r7, #4
    svc     #0

    pop     {r0, r1, r2, r3, r6, pc}

strstr:
    push    {r1, r2, r3, r4, lr}
    mov     r4, #0
    ldrb    r3, [r1]
    strstr_loop:
        ldrb    r2, [r0], #1
        cmp     r2, #0
        beq     str_not_found
        cmp     r2, r3
        beq     first_letter
        sub     r0, r0, r4
        mov     r4, #0
        ldrb    r3, [r1]
        b       strstr_loop
    first_letter:
        add     r4, r4, #1
        ldrb    r3, [r1, r4]
        cmp     r3, #0
        bne     strstr_loop
    str_found:
        mov     r0, r4
        pop     {r1, r2, r3, r4, pc}
    str_not_found:
        mov     r0, #-1
        pop     {r1, r2, r3, r4, pc}

read_byte:
    push    {r1, r2, lr}
    mov     r1, r0
    ldr     r0, =handler
    ldr     r0, [r0]
    mov     r2, #1
    mov     r7, #3
    svc     #0
    pop     {r1, r2, pc}

strlen:
    push    {r1, r2, lr}
    mov     r2, #0
    strlen_loop:
        ldrb     r1, [r0, r2]
        cmp     r1, #0
        beq     done
        add     r2, r2, #1
        b       strlen_loop
    done:
    mov     r0, r2
    pop     {r1, r2, pc}

.data
alph: .ascii "0123456789ABCDEF:"
file_readed: .int  1
handler: .int   0
usage1: .ascii "Как использовать? "
usage1_len = . - usage1
usage2: .ascii " 'имя файла' 'подстрока'\n"
usage2_len = . - usage2
address: .ascii "\033[32m"
address_len = . - address
dots: .ascii "\033[36m"
dots_len = . - dots
substr: .ascii "\033[31m"
substr_len = . - substr
normalize: .ascii "\033[0m"
normalize_len = . - normalize
.comm   buffer, 10000, 4
