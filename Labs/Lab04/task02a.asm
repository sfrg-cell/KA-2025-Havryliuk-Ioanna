.model small
.stack 100h
.code
main proc 

mov ax, 5
mov bx, 2

call func

mov ax, 4c00h
int 21h
main endp

func proc
cmp bx, ax
jg ax_less
mov ax, bx
mov bx, 0
ret

ax_less:
mov bx, 0
ret

func endp
end main