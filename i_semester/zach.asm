.model tiny
.386
.code
org 100h

start:
	jmp begin
	m1 dw 11h
	m2 dw 22h

begin:
  	mov ax, 4
	mov bx, ax
	mov bx, m1
	mov m2, bx
	mov cx, m2
	xchg cx, ax
	lea ax, m1
	mov ax, offset m1
	lea ecx, dword ptr [edx+eax+1]
	lea ecx, delay
	ret

delay proc
  mov cx, 5000
  delay_loop:
    nop
    loop delay_loop
  ret
delay endp

end start
