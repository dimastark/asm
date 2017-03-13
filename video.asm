.model tiny
.code
.386
org 100h

start:
  xor dx, dx
  xor bh, bh
  xor al, al
  mov bl, 00011111b
  mov cx, 80

paint:
  call write
  inc dh
  cmp dh, 4
  je ascii_table
  cmp dh, 25
  jne paint
  ret

ascii_table:
  mov cx, 23
  call write
  add dl, 23
  cmp dh, 4
  je top_border
  cmp dh, 21
  je bottom_border
  jmp left_border

ascii_symbols:
  inc dl
  call write
  inc al
  push ax
  inc dl
  xor al, al
  call write
  pop ax
  cmp dl, 56
  je right_frame
  jmp ascii_symbols

right_frame:
  xor al, al
  call write
  mov al, 186
  inc dl
  call write
  jmp right_side

left_border:
  mov cx, 1
  mov al, 186
  call write
  xor al, al
  inc dl
  call write
  mov ah, 16
  mov al, dh
  sub al, 5
  mul ah
  jmp ascii_symbols

right_side:
  inc dl
  xor al, al
  mov cx, 22
  call write
  add dl, 22
  inc dh
  xor dl, dl
  cmp dh, 22
  jne ascii_table
  mov cx, 80
  jmp paint

bottom_border:
  mov cx, 1
  mov al, 200
  call write
  inc dl
  call line
  mov al, 188
  call write
  jmp right_side

top_border:
  mov cx, 1
  mov al, 201
  call write
  inc dl
  call line
  mov al, 187
  call write
  jmp right_side

line proc
  mov cx, 33
  mov al, 205
  call write
  add dl, 33
  mov cx, 1
  ret
endp line

write proc
  mov ah, 2
  int 10h
  mov ah, 9
  int 10h
  ret
endp write

end start
