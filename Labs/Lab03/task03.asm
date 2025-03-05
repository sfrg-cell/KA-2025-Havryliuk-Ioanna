.model small
.stack 100h
.data
a dw 0FFFFh
b dw 8000h
c dw 1
d dw 10b
.code
main proc

mov ax, SEG @data
mov ds, ax

mov ax, a
mov bx, b

and ax, bx
cmp ax, bx
jne if_not_e
mov a, 1
jmp exit1
if_not_e:
mov a, 0

exit1:
mov ax, c
mov bx, d

and ax, bx
cmp ax, bx
jne ifnote
mov c, 1
jmp exit
ifnote:
mov d, 0

exit:
mov ax, 4C00h       
int 21h             

main endp
end main