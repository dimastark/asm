.model tiny
.code
org 100h

start:
  mov es, ax
  mov bx, es:[9h*4]
  mov cx, es:[9h*4+2]
  mov word ptr old_09h, bx
  mov word ptr old_09h + 2, cx
  mov es:[9h*4], offset handler
  mov es:[9h*4+2], ds

  next:
  xor ax, ax
  int 16h
  cmp cl, 1
  jne next

  mov bx, 10
  mov cx, 3
  mov ah, 0
  mov bp, ax

  _1:
    xor dx, dx
    div bx
    push dx
    loop _1
 
  xor di, di
  mov cx, 3

  _2:
    pop dx
    add dl, 30h
    mov ah, 2
    int 21h
    add di, 2
    loop _2

  mov dl, 10
  int 21h

  cmp bp, 27
  jne next

  mov bx, word ptr old_09h
  mov cx, word ptr old_09h + 2
  mov es:[9h*4], bx
  mov es:[9h*4+2], cx
  ret

handler proc
  pushf
  call dword ptr old_09h
  in al, 60h
  test al, 10000000b
  jnz release
  mov cl, al
  lea bx, states
  xlat
  cmp al, 0
  pushf
  mov al, 1
  add bx, cx
  mov byte ptr [bx], al
  popf
  je first_press
  mov al, 0
  mov cl, al
  iret

  first_press:
    mov cl, 1
    iret

  release:
    mov ah, 0
    and al, 01111111b
    lea bx, states
    add bx, ax
    mov al, 0
    mov [bx], al
    mov cl, 0
    iret

  old_09h dd ?
  states db 127 dup (0)
handler endp

end start