.model small
.stack 100h
.data 
    oneChar db 0

.code
main proc
mov ax, SEG @data
mov ds, ax           

mov ah, 02h
mov dl, '0'
int 21h

read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next

exit:
mov ax, 4c00h
int 21h
main endp
end main