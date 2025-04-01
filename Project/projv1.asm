.model small
.stack 100h
.data 
    filename db 'test.in', 0
    buffer db 255 dup(0)
    newline db 13, 10, '$'
    line_count db 0 
    key db 'aa', 0
    match_count db 0
    
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

call count_substring

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

count_substring proc
xor cx, cx
lea si, buffer
lea di, key

compare_loop:
mov al, [si]
mov dl, [di]
cmp al, dl
jne match_not_found
je match_found

match_found:
lea si, [si + 1]
lea di, [di + 1]
cmp si, 0
je finish
cmp di, 0
je inc_count
jmp compare_loop

match_not_found:
lea si, [si + 1]
cmp si, 0
je finish
lea di, key
jmp compare_loop

inc_count:
inc cx
lea di, key
jmp compare_loop

finish:
mov match_count, cl

ret
count_substring endp

end main