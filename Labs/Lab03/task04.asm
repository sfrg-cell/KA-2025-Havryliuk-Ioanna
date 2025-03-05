.model small
.stack 100h
.code
main proc

xor dx, dx ; since dx is XOR'd with itself, every bit in dx will always result in 0

mov ax, 4C00h       
int 21h             

main endp
end main