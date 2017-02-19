.model tiny
.code
org 100h

start:
  mov ax, 1
  mov cx, 6
  call fact
  mov bx, 10
  xor cx, cx

number_in_stack: 
  xor dx, dx
  div bx
  push dx
  inc cx
  test ax, ax
  jnz number_in_stack

@@2:
  pop dx
  cmp dl, 9
  jbe @@3
  add dl, 7

@@3:
  add dl, 30h
  mov ah, 2
  int 21h
  loop @@2

fact proc
  mul cx
  dec cx
  cmp cx, 1
  jl endFact
  call fact
  endFact:
  ret
fact endp

end start