.model small
.stack 100h
.data 
    error_msg db 'Error overflow!$'
    buffer db 255 dup(0)
    lines db 100*255 dup(0)  
    newline db 13, 10, '$'
    line_count dw 0
    line_pos dw 0
    handle dw ?
    key db 'aa', 0             
    key_len dw 2               
    matches dw 100 dup(0)      
    output_buffer db 6 dup(' '), '$'
    line_indexes dw 100 dup(0) 
    
.code
main proc
    mov ax, @data
    mov ds, ax

open_file:
    mov handle, 0    
    mov line_count, 0

read_file:
    mov ah, 3Fh          
    mov bx, handle
    mov cx, 255
    lea dx, buffer
    int 21h

    cmp ax, 0           
    jz check_eof
    jmp process_bytes

check_eof:
    cmp line_pos, 0
    jne skip_processing 
    jmp process_results

skip_processing:
    call count_shift
    mov byte ptr lines[di], 0

    mov bx, line_count
    call count_substring

    inc line_count
    mov line_pos, 0
    
    jmp process_results

process_bytes:
    mov cx, ax          
    xor si, si          

process_char:
    cmp si, cx          
    jae read_file       

    mov al, buffer[si]  
    
    cmp al, 0Dh         
    je found_cr
    
    cmp al, 0Ah         
    je found_lf
    
    call count_shift             
    
    mov lines[di], al  
    inc line_pos 
    cmp line_pos, 255
    jge overflow       
    
    inc si              
    jmp process_char

overflow:
    mov ah, 09h
    lea dx, error_msg
    int 21h
    jmp exit

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
    call count_shift 
    
    mov byte ptr lines[di], 0    

    push si             
    push cx             
    
    mov bx, line_count  
    call count_substring
    
    pop cx              
    pop si              
    
    inc line_count      
    mov line_pos, 0     
    
    cmp line_count, 100 
    jge overflow

    jmp process_char   

process_results:
    
    call bubble_sort

    mov cx, line_count
    xor si, si

display_loop:   
    cmp si, cx
    jae exit

    mov bx, si
    shl bx, 1 
    mov ax, matches[bx]
    
    call print_number
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    mov ax, line_indexes[bx]
    call print_number
    
    mov ah, 09h
    lea dx, newline
    int 21h 
    
    inc si
    jmp display_loop

exit:
    mov ax, 4C00h
    int 21h
main endp

count_shift proc
    push ax
    push cx
    
    mov ax, line_count
    mov cx, 255
    mul cx
    add ax, line_pos
    mov di, ax
    
    pop cx
    pop ax
    ret
count_shift endp

count_substring proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ax, 255
    mul bx              
    mov si, ax          
    xor cx, cx          
    
count_loop:
    cmp byte ptr lines[si], 0
    je count_done
    
    mov di, 0           
    
match_loop:
    mov al, key[di]     
    cmp al, 0           
    je match_found      
    
    push bx             
    mov bx, si          
    add bx, di          
    mov ah, lines[bx]   
    pop bx              
    
    cmp ah, 0           
    je count_done       
    
    cmp ah, al          
    jne match_failed    
    
    inc di              
    jmp match_loop      
    
match_found:
    inc cx              
    add si, di          
    jmp count_loop      
    
match_failed:
    inc si              
    jmp count_loop      
    
count_done:
    mov di, bx
    shl di, 1           
    mov matches[di], cx 
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
count_substring endp

bubble_sort proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov cx, line_count
    xor si, si
    
init:
    cmp si, cx
    jae sort
    
    mov bx, si
    shl bx, 1
    mov line_indexes[bx], si
    
    inc si
    jmp init
    
sort:
    mov cx, line_count
    dec cx
    jz sort_finish
    
outer_loop:
    xor si, si
    
inner_loop:
    mov bx, si
    shl bx, 1
    
    mov ax, matches[bx]
    mov dx, matches[bx+2]
    
    cmp ax, dx
    jle next_chars
    
    mov matches[bx], dx
    mov matches[bx+2], ax
    
    mov ax, line_indexes[bx]
    mov dx, line_indexes[bx+2]
    mov line_indexes[bx], dx
    mov line_indexes[bx+2], ax
    
next_chars:
    inc si
    mov ax, line_count
    dec ax
    cmp si, ax
    jl inner_loop
    
    loop outer_loop
    
sort_finish:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
bubble_sort endp

print_number proc
    push ax
    push bx
    push cx
    push dx
    
    xor cx, cx
    mov bx, 10
    
    test ax, ax
    jnz extract_digits
    
    mov ah, 02h
    mov dl, '0'
    int 21h
    jmp print_number_end
    
extract_digits:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz extract_digits
    
output_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop output_digits
    
print_number_end:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

end main