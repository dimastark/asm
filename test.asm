.model tiny
  .code
  org 100h

start:
  mov cx, 0
  mov bx, 0
  mov ah, 02h
  call border
  mov bx, 0

outer:
  cmp bx, 256
  je exit
  mov dl, 10
  int 21h
  mov cx, 0
  jmp inner_start

inner:
  cmp bl, 10
  je unknown_char
  cmp bl, 13
  je unknown_char
  cmp bl, 7
  je unknown_char
  cmp bl, 8
  je unknown_char
  cmp bl, 9
  je unknown_char
  cmp bl, 27
  je unknown_char
  mov dl, bl
  int 21h
go_next:
  inc bx
  inc cl
  cmp cl, 16
  je inner_end
  mov dl, 0
  int 21h
  jne inner

inner_start:
  mov dl, 221
  int 21h
  jmp inner

inner_end:
  mov dl, 222
  int 21h
  jmp outer

border:
  mov dl, 219
  border_cycle:
    int 21h
    inc bx
    cmp bx, 33
    jne border_cycle
  ret

unknown_char:
  mov dl, 63
  int 21h
  jmp go_next

exit:
  mov dl, 10
  int 21h
  mov dl, 219
  mov bx, 0
  call border
  mov dl, 10
  int 21h
  int 21h
  end start
