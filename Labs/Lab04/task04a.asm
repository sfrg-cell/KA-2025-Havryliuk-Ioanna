.model small
.stack 100h
.code
main proc

push bx
push cx

push 6
push 2

call func
pop ax

pop bx
pop cx

mov ax, 4c00h
int 21h
main endp

func proc
pop cx
pop bx
pop ax

cmp bx, ax
jg ax_less

push bx
push cx
xor ax, ax
xor bx, bx
xor cx, cx
ret

ax_less:
push ax
push cx
xor ax, ax
xor bx, bx
xor cx, cx
ret

func endp
end main