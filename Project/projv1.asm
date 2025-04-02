.model small
.stack 100h
.data 
    filename db 'test.in', 0
    error_msg db 'Error opening file!$'
    buffer db 255 dup(0)
    lines db 100*255 dup(0)  
    newline db 13, 10, '$'
    line_count dw 0
    char_count dw 0
    line_pos dw 0
    handle dw ?
    key db 'aa', 0
    match_count db 0
    
.code
main proc
    mov ax, @data
    mov ds, ax

open_file:
    mov ah, 3Dh
    mov al, 00h
    lea dx, filename
    int 21h
    jnc file_opened
    mov ah, 09h
    lea dx, error_msg
    int 21h
    jmp exit
    
file_opened:
    mov handle, ax
    mov line_count, 0

read_file:
    mov ah, 3Fh
    mov bx, handle
    mov cx, 255
    lea dx, buffer
    int 21h

    cmp ax, 0
    je close_file

    mov cx, ax
    mov si, 0

process_char:
    cmp si, cx
    jae read_file

    mov al, buffer[si]
    
    cmp al, 0Dh
    je found_cr
    
    cmp al, 0Ah
    je found_lf
    
    mov di, line_count
    mov ax, 255
    mul di
    mov di, ax
    add di, line_pos
    mov lines[di], al
    inc line_pos
    
    inc si
    jmp process_char

found_cr:
    inc si
    
    cmp si, cx
    jae save_line
    
    cmp buffer[si], 0Ah
    jne save_line
    
    inc si
    jmp save_line

found_lf:
    inc si

save_line:
    mov di, line_count
    mov ax, 255
    mul di
    mov di, ax
    add di, line_pos
    mov lines[di], '$'

    call count_substring
    
    inc line_count
    mov line_pos, 0
    
    cmp line_count, 100
    jge close_file
    
    jmp process_char

close_file:
    mov ah, 3Eh
    mov bx, handle
    int 21h

exit:
    mov ax, 4C00h
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