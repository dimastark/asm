.model tiny
  .code
  org 100h

start:
  jmp begin
  dka db 1, 1, 3, 1, 5, 1, 1, 0, 2, 0, 4, 0, 4, 0, 0, 0, 0, 0, 0, 6, 0

begin:
  cld  ; dir flag ->
  mov dx, 7h
  mov cx, 0
  mov si, 81h  ; начало аргументов
  lea bx, dka

cycle:
  call next
  mul dl
  add al, cl
  xlat
  mov cl, al
  cmp cl, 6
  je yes
  cmp si, 100h
  jg no
  jmp cycle

next proc
  xor ax, ax
  lodsb
  cmp al, 61h
  je a
  cmp al, 6eh
  je n
  cmp al, 73h
  je s
  jmp wrong
  a:
    mov al, 0
    ret
  n:
    mov al, 1
    ret
  s:
    mov al, 2
    ret
  wrong:
    call next
    ret
next endp

yes:
  mov ah, 02h
  mov dl, 59h
  int 21h
  ret

no:
  mov ah, 02h
  mov dl, 4eh
  int 21h
  ret

end start
