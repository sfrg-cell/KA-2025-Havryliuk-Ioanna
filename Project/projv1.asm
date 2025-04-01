.model small
.stack 100h
.data 
    filename db 'test.in', 0
    buffer db 100 dup(0)
.code
main proc
mov ax, SEG @data
mov ds, ax           

mov ah, 3Dh
mov al, 00h 
mov dx, offset filename
int 21h

mov bx, ax 

exit:
mov ax, 4c00h
int 21h
main endp
end main