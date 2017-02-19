.model tiny
.386
.code
org 100h

start:
  jmp begin
  multipler dd 100
  half dd 165
  x dd ?
  y dd ?

begin:
  call set_video_mode
  call make_x_label
  call make_y_label
  call draw_ox_arrow
  call draw_ox
  call draw_oy_arrow
  call draw_oy
  call draw_oy_batches
  call draw_ox_batches

  mov cx, 320
  mov al, 1
  mov si, 0
  mov di, 0

  graph:
    finit
    mov word ptr [x], si
    fild x
    fidiv dword ptr [multipler]
    fsincos
    fmul st(0), st(1)
    fimul dword ptr [multipler]
    fiadd dword ptr [half]
    frndint
    fistp dword ptr [y]

    mov cx, si
    mov dx, word ptr [y]
    int 10h
    cmp al, 15
    jne one_color
    mov al, 0
    one_color:
    inc al
    call delay
    inc si
    cmp si, 639
    jne graph

set_video_mode proc
  mov al, 10h
  int 10h
  ret
set_video_mode endp

make_x_label proc
  mov ah, 02h
  mov bh, 0
  mov dl, 79
  mov dh, 11
  int 10h

  mov ah, 09h
  mov al, 78h
  mov bl, 15
  mov cx, 1
  int 10h

  ret
make_x_label endp

make_y_label proc
  mov ah, 02h
  mov dl, 42
  mov dh, 0
  int 10h

  mov ah, 09h
  mov al, 79h
  int 10h

  ret
make_y_label endp

draw_ox proc
  mov ah, 0ch
  mov al, 15
  mov bh, 0
  mov cx, 640
  mov dx, 174
  h_line:
    int 10h
    loop h_line
  ret
draw_ox endp

draw_ox_arrow proc
  mov ah, 02h
  mov bh, 0
  mov dl, 79
  mov dh, 12
  int 10h

  mov ah, 09h
  mov al, 10h
  mov bl, 15
  mov cx, 1
  int 10h

  ret
draw_ox_arrow endp

draw_oy proc
  mov ah, 0ch
  mov al, 15
  mov dx, 0
  mov cx, 323
  v_line:
    inc dx
    int 10h
    cmp dx, 400
    jne v_line
  ret
draw_oy endp

draw_oy_arrow proc
  mov ah, 02h
  mov bh, 0
  mov dl, 40
  mov dh, 0
  int 10h

  mov ah, 09h
  mov al, 1eh
  mov bl, 15
  mov cx, 1
  int 10h

  ret
draw_oy_arrow endp

draw_oy_batches proc
  mov dx, 325
  y_batches:
    mov cx, 322
    int 10h
    mov cx, 324
    int 10h
    sub dx, 20
    cmp dx, 10
    jg y_batches
  ret
draw_oy_batches endp

draw_ox_batches proc
  mov cx, 633
  x_batches:
    mov dx, 173
    int 10h
    mov dx, 175
    int 10h
    sub cx, 20
    cmp cx, 10
    jg x_batches
  ret
draw_ox_batches endp

delay proc
  mov cx, 5000
  delay_loop:
    nop
    loop delay_loop
  ret
delay endp

end start