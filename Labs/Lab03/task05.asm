.model small
.stack 100h
.code
main proc

mov ax, 200
mov dx, 100

xor ax, dx
xor dx, ax
xor ax, dx

mov ax, 4C00h       
int 21h             

main endp
end main