.model tiny
.code
org 100h
start:
mov ax, 013b0h
mov bh, 10

divv:
div bh
mov ah, 0
push ax

ret
end start