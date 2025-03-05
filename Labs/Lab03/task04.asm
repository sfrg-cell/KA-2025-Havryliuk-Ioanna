.model small
.stack 100h
.code
main proc

xor dx, dx 

mov ax, 4C00h       
int 21h             

main endp
end main