.model tiny
.code
.386
org 100h

start:
  ; start attributes
  mov bx, 001fh
  mov ah, 0fh
  int 10h
  mov byte ptr columns_count, ah
  mov byte ptr current_page,  bh
  mov al, 20h
  call background
  mov dh, 04h
  call top_border
  mov al, 186
  mov dh, 05h
  dec dl
  call side_border
  mov dh, 05h
  call place_col
  call side_border
  call bot_border
  call place_col
  inc dl
  inc dl
  mov dh, 05h
  mov cx, 1
  call ascii_table
  wait_input:
  xor ax, ax
  int 16h
  mov ax, 0B800h
  xor di, di
  mov cx, 25*80
  mov es, ax
  mov ax, 720h
  rep stosw
  ret

ascii_table proc
  xor al, al
  write_loop:
  call write
  inc dl
  inc al
  call check_div
  jne write_loop
  inc dh
  call place_col
  inc dl
  inc dl
  cmp dh, 15h
  je wait_input
  jmp write_loop
  ret
endp ascii_table

bot_border proc
  call place_col
  mov cx, 01h
  mov al, 200
  call write
  mov cx, 33
  mov al, 205
  call write
  mov cx, 01h
  mov al, 188
  call write
  ret
endp bot_border

top_border proc
  call place_col
  mov cx, 01h
  mov al, 201
  call write
  mov cx, 33
  mov al, 205
  call write
  mov cx, 01h
  mov al, 187
  call write
  ret
endp top_border

side_border proc
  mov cx, 16
  puts:
    call put
    loop puts
  ret
endp side_border

place_col proc
  mov dl, [columns_count]
  sub dl, 35
  shr dl, 1
  ret
endp place_col

write proc
  mov ah, 02h
  int 10h
  mov ah, 09h
  int 10h
  add dx, cx
  ret
endp write

put proc
  push cx
  mov cx, 1
  call write
  dec dx
  inc dh
  pop cx
  ret
endp put

background proc
  mov bh, [current_page]
  mov cl, [columns_count]
  xor dx, dx
  draw:
    call write
    cmp dx, 2500h
    jne draw
  ret
endp background

check_div proc
  push ax
  push cx
    xor ah, ah
    mov ch, 16
    div ch
    cmp ah, 0
  pop cx
  pop ax
  ret
endp check_div

columns_count db ?
current_page  db ?

end start
