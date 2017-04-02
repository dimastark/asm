.model tiny
.code
.386
org 100h

start:
  call read_args
  cmp al, 0ch
  je install
  cmp al, 0ah
  je kill
  cmp al, 0bh
  je state
  cmp al, 0dh
  je rm_handler
  cmp al, 09h
  je help
  jmp usage

; resident
handler proc
  mov bx, cs
	mov ax, 'DS'
  cmp	al, 1
  je uninstall_handler
	iret
 	uninstall_handler:
  xor ax, ax
  mov es, ax
	cmp	bx, word ptr es:[2fh*4+2]
	jne	uninstall_failed
	iret
  uninstall_failed:
	mov	al, 'F'
	iret
  old_2fh dw ?, ?
handler	endp
len = $-handler

write_addr proc
  mov ax, ds
  mov es, ax
  mov di, dx
  mov cl, 12
mov_loop:
  mov ax, bx
  shr ax, cl
  and ax, 0fh
  cmp ax, 0ah
  jl digit
  add ax, 07h
digit:
  add ax, 30h
  stosb
  sub cl, 04h
  jns mov_loop
  ret
write_addr endp

read_args proc
  mov si, 81h
  xor dx, dx
  read:
  lodsb
  lea bx, letters
  xlat
  lea bx, automaton
  add al, dh
  xlat
  cmp al, 09h
  jge end_args
  mov ah, 09h
  mul ah
  mov dh, al
  jmp read
  end_args:
  ret
read_args endp

install:
  int 2fh
  cmp ax, 'DS'
  je installed_already

	push es ; save
	xor ax, ax
  mov es, ax
	push word ptr es:[2fh*4]
	push word ptr es:[2fh*4+2]
	pop es
	pop bx
	mov	word ptr old_2fh, bx
	mov word ptr old_2fh+2, es
	pop es ; restore

	mov bx, len
	shr bx, 4
	inc bx
	mov ax, 4800h
	int 21h

	push ax
	dec ax
	push ax
	pop es
	pop ax
	mov word ptr es:[1], ax

	lea si, handler
	mov es, ax
	mov di, 0
	mov cx, len
	rep movsb

  cli
	xor cx, cx
	mov es, cx
	mov word ptr es:[2fh*4+2], ax
	mov word ptr es:[2fh*4], 0
	sti
jmp no_errors

kill:
  mov ax, 0
  int 2fh
  cmp ax, 'DS'
  jne not_installed

  mov es, bx
	push es
	mov di, [offset old_2fh - offset handler]
	mov dx, es:di
	mov ax, [es:di+2]
	push ds
	mov ds, ax

	cli
	mov ax, 0
  mov es, ax
	mov es:[2fh*4+2], ds
	mov es:[2fh*4], dx
	sti

	pop 	ds
	pop 	es
	mov 	ah, 49h
	int 	21h
jmp no_errors

state:
  mov ax, 0
  int 2fh
  cmp ax, 'DS'
  jne not_installed
  lea dx, place_msg
  call write_addr
  lea dx, inmem_msg
jmp output

rm_handler:
  xor ax, ax
  int 2fh
  cmp ax, 'DS'
  jne not_installed
  mov ax, 0001h
  int 2fh
  cmp ax, 'DF'
  je not_in_top
  jmp kill

; outputs
help:
  lea dx, full_help
  jmp output
usage:
  lea dx, tiny_help
  jmp output
installed_already:
  lea dx, sorry_msg
  jmp output
not_installed:
  lea dx, not_inmem
  jmp output
not_in_top:
  lea dx, enot_last
  jmp output
no_errors:
  lea dx, ok_messag
output:
  mov ax, 0900h
  int 21h
  ret

    my_name 	db 	'NV', 0, 0, 0, 0, 0, 0
    tiny_help db 10, 'What are you doing? Try call me with -h', 10, '$'
    full_help db 10, 'Use:  resident_evil [-h i k s u]', 10, 10
              db ' -h   show how to use this useless program (This message)', 10
              db ' -i   inject me to memory       -u   purge me from memory', 10
              db ' -k   kill me without mercy     -s   show how I am living', 10, '$'
    sorry_msg db 'Sorry, I am sleeping in memory', '$'
    inmem_msg db 'I am wait for you call in memory: '
    place_msg dd ?
              db '$'
    not_inmem db 'I am not in memory', '$'
    enot_last db 'Sorry, I am not last', '$'
    ok_messag db 'Everything went smoothly', '$'

    letters db 13 dup(8), 7, 18 dup(8), 6, 12 dup(8), 0, 58 dup(8), 1, 4, 8, 2, 7 dup(8), 3, 8, 5, 10 dup(8)

    automaton db 0, 0, 0, 0, 0, 0, 1,  15, 0
              db 2, 0, 0, 0, 0, 0, 1,  15, 0
              db 0, 3, 4, 5, 6, 7, 1,  15, 0
              db 0, 0, 0, 0, 0, 0, 9,  9,  0
              db 0, 0, 0, 0, 0, 0, 10, 10, 0
              db 0, 0, 0, 0, 0, 0, 11, 11, 0
              db 0, 0, 0, 0, 0, 0, 12, 12, 0
              db 0, 0, 0, 0, 0, 0, 13, 13, 0

end start
