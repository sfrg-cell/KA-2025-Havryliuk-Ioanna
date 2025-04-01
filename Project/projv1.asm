.model small
.stack 100h
.data 
    filename db 'test.in', 0
    buffer db 255 dup(0)
    newline db 13, 10, '$'
    line_count db 0 
.code
main proc
mov ax, SEG @data
mov ds, ax           

open_file:
mov ah, 3Dh
mov al, 00h 
mov dx, offset filename
int 21h
mov bx, ax

read_file:
mov ah, 3Fh
mov cx, 255
mov dx, offset buffer
int 21h

cmp ax, 0
je close_file

mov dx, offset buffer
mov ah, 09h
int 21h

new_line:
mov dx, offset newline
mov ah, 09h
int 21h

count_lines:
inc line_count
cmp line_count, 100
je close_file

jmp read_file

close_file:
mov ah, 3Eh      
int 21h 

exit:
mov ax, 4c00h
int 21h
main endp
end main