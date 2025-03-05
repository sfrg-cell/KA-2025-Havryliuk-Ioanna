.model small
.stack 100h

.code
main proc

mov ax, 200
mov dx, 100

mov cx, ax
mov ax, dx
mov dx, cx

mov ax, 4C00h       ; Load value 4C00h into AX (prepare for program exit)
int 21h             ; Call DOS interrupt to terminate the program

main endp
end main