


.model tiny
.code

org 100h

start:
  call arg_parse

  cmp al, 09h
  je help
  cmp al, 0ch
  je install
  cmp al, 0bh
  je status
  cmp al, 0dh
  je kostul
  ;cmp al, 0dh
  ;je uninst
  mov ah, 1
  jmp help
  ret

;------------------------- procedures ---------------------------------------
arg_parse proc
  mov si, 81h
  xor dx, dx
  read_args:
  lodsb
  lea bx, first
  xlat
  lea bx, dka
  add al, dh
  xlat
  cmp al, 09h
  jge args_end
  mov ah, 09h
  mul ah
  mov dh, al
  jmp read_args
  args_end:
  ret
endp arg_parse

prog_end proc
  cmp ah, 1
  lea dx, o_message
  jne call_print_1
  jmp prog_end_end
  call_print_1:
    call print
  prog_end_end:
    ret
endp prog_end

help:
  cmp ah, 1
  lea dx, tiny_help
  je short_full_help
  lea dx, full_help
  short_full_help:
    call print
    ret
jmp super_end

kostul:
jmp remove_r

install:
  int 2fh
  cmp ax, 'DS'
  jne not_in_mem
  jmp status
  mov ah, 1
  call prog_end
  not_in_mem:
  ; get vector 2f
  mov	ax, 352fh
  int	21h
  mov	[old_2fh], bx
  mov	[old_2fh + 2], es

  ; set handler
  mov	ah, 25h
  lea	dx, handler
  int	21h

  call prog_end
  ret
jmp super_end

status:
  int 2fh
  cmp ax, 'DS'
  lea dx, no
  jne not_in_memory
  lea dx, yes
  not_in_memory:
  call print
  ret
  yes db 'I living in memory', '$'
  no  db 'I am not in memory', '$'
jmp super_end

remove_r:
  int 2fh
  cmp ax, 'DS'
  je in_mem
  jmp status
  mov ah, 1
  call prog_end
  in_mem:

  jne not_ok
  cmp dx, bx
  je ok
  not_ok:
  lea dx, not_the_t
  call print
  jmp super_end
  ok:
  mov ax, 'UN'
  int 21h
  xor bx, bx
  call prog_end
jmp super_end

print proc
  mov ax, 0900h
  int 21h
  ret
endp print

;---------------------------- handler ---------------------------------------
handler	proc far
  cmp ax, 'UN'
  jne next


  next:
  mov ax, 'DS'
  jmp dword ptr cs:[old_2fh]
  end_hadler:
handler	endp
;---------------------------- strings ---------------------------------------

o_message db 10, 'Everything went smoothly', 10, '$'
not_the_t db 10, 'I am not in the top', '$'
;---------------------------- for xlat --------------------------------------
first db 13 dup(8), 7, 18 dup(8), 6, 12 dup(8), 0, 58 dup(8), 1, 4, 8, 2, 7 dup(8), 3, 8, 5, 10 dup(8)
dka   db 0, 0, 0, 0, 0, 0, 1,  15, 0
      db 2, 0, 0, 0, 0, 0, 1,  15, 0
      db 0, 3, 4, 5, 6, 7, 1,  15, 0
      db 0, 0, 0, 0, 0, 0, 9,  9,  0
      db 0, 0, 0, 0, 0, 0, 10, 10, 0
      db 0, 0, 0, 0, 0, 0, 11, 11, 0
      db 0, 0, 0, 0, 0, 0, 12, 12, 0
      db 0, 0, 0, 0, 0, 0, 13, 13, 0
;---------------------------- addreses ---------------------------------------


super_end:
