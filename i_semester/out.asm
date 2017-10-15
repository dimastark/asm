.model tiny
 
.code
    org 100h
start:
    mov ax, 0abdh
    mov bx, 0ah
    xor cx, cx
@@1:
    xor dx, dx ; то же что и "mov dx, 0", но быстрее
    div bx
    push dx
    inc cx
    test ax, ax
    jnz @@1
 
    mov ah, 02h
@@2:
    pop dx
    add dl, 30h   ; превращаем байт в ascii цифру
    int 21h
    loop @@2
 
    ret
end start