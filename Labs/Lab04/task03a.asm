.model small
.stack 100h
.code
main proc  

push 6
push 2

call func
pop ax

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
ret

ax_less:
push ax
push cx
ret

func endp
end main