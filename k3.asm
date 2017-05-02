.model tiny
.code
org 100h

b_port = 61h
cmdreg = 43h
latch2 = 42h

start:
  mov es, ax
  mov bx, es:[9h*4]
  mov cx, es:[9h*4+2]
  mov word ptr old_09h, bx
  mov word ptr old_09h + 2, cx
  mov es:[9h*4], offset handler
  mov es:[9h*4+2], ds

  work:
  call next_note
  cmp al, 0ffh
  je terminate
  call next_freq
  call play_note
  jmp work

  terminate:
  call term
  mov bx, word ptr old_09h
  mov cx, word ptr old_09h + 2
  mov es:[9h*4], bx
  mov es:[9h*4+2], cx
  ret

init proc
  in al, b_port
  ; таймер и динамик
  or al, 00000011b
  out b_port, al
  xor si, si
  ret
endp init

term proc
  in al, b_port
  and al, 0fch
  out b_port, al
  ret
endp term

next_note proc
  xor ax, ax
  int 16h

  call init
  xchg al, ah
  mov ah, 0
  call calc_al
  ret
endp next_note

calc_al proc
  cmp al, 43
  jg bad_al
  ret
  bad_al:
  mov al, 0ffh
  ret
endp calc_al

next_freq proc
  lea bx, frequency
  shl ax, 1
  mov di, ax
  mov dx, [bx][di]
  ret
endp next_freq

play_note proc
  mov al, dl
  out latch2, al
  mov al, dh
  out latch2, al
  ret
endp play_note

old_09h dw ?, ?

handler proc
  pushf
  call dword ptr old_09h
  in al, 60h
  cmp al, 80h
  jl press
  test al, 10000000b
  jnz release
  iret

  press:
  mov ah, 0
  mov [current_code], ax
  jmp return

  release:
  mov ah, 0
  sub ax, 80h
  cmp [current_code], ax
  jne return
  call term

  return:
  iret

handler endp
current_code dw 0

;                  C     C#    D     D#    E     F     F#    G     G#    A     A#    B
frequency dw 0, 0, 9121, 8609, 8126, 7670, 7239, 6833, 6449, 6087, 5746, 5423, 5119, 4831, 0, 0
                dw 4560, 4304, 4063, 3834, 3619, 3416, 3224, 3043, 2873, 2711, 2559, 2415, 0, 0
                dw 2280, 2152, 2031, 1917, 1809, 1715, 1612, 1521, 1436, 1355, 1292, 1207

end start