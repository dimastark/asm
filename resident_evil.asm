.model tiny
.code

org 100h

start:
  call arg_parse

  cmp al, 09h
  je help
  cmp al, 0ch
  je inst
  cmp al, 0ah
  je kill
  cmp al, 0bh
  je state
  cmp al, 0dh
  je uninst
  ret

  help proc far
    mov ah, 9h
    lea dx, help_text
    int 21h
    ret
  endp help

  handler	proc far
    mov ax, 'DS'
    jmp dword ptr cs:[old_2fh]
  handler	endp

  back_2fh dw ?, ?
	new_name db 20h,0,0,1,0,'2f handler',0
	name_len dw $-new_name

;------------------------- procedures ---------------------------------------
arg_parse proc
  mov si, 82h
  xor dx, dx
  read_loop:
  lodsb
  lea bx, first
  xlat
  lea bx, dka
  add al, dh
  xlat
  cmp al, 09h
  jge read_end
  mov ah, 09h
  mul ah
  mov dh, al
  jmp read_loop
  read_end:
  ret
endp arg_parse

help proc
  cmp al, 0fh
  jne with_help
  lea dx, tiny_help
  je call_print
  lea dx, full_help
  call_print:
    call print
    ret
endp help

print proc
  mov ax, 0900h
  int 21h
  ret
endp print
;---------------------------- strings ---------------------------------------
tiny_help db 'I did anything. Try call me with -h'
full_help db 'Use:  resident_evil [-h i k s u]', 10, 10 \
          db ' -h   show how to use this useless program (This message)', 10 \
          db ' -i   inject me to memory       -u   purge me from memory', 10 \
          db ' -k   kill me without mercy     -s   show how I am living', '$'
o_message db 'Everything went smoothly', '$'
e_message db 'Something went wrong'
error_inf db ?, '$'
;---------------------------- for xlat --------------------------------------
first db 13, dup(8), 7, 18 dup(8), 6, 12 dup(8), 0, \
      db 58, dup(8), 1, 4, 8, 2, 7 dup(8), 3, 8, 5, 10 dup(8)
dka   db 0, 0, 0, 0, 0, 0, 1,  15, 0
      db 2, 0, 0, 0, 0, 0, 1,  15, 0
      db 0, 3, 4, 5, 6, 7, 1,  15, 0
      db 0, 0, 0, 0, 0, 0, 9,  9,  0
      db 0, 0, 0, 0, 0, 0, 10, 10, 0
      db 0, 0, 0, 0, 0, 0, 11, 11, 0
      db 0, 0, 0, 0, 0, 0, 12, 12, 0
      db 0, 0, 0, 0, 0, 0, 13, 13, 0
;---------------------------- numbers ---------------------------------------

end start
