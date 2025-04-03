.model small
.stack 100h
.data 
    filename db 'test.in', 0
    error_msg db 'Error opening file!$'
    buffer db 255 dup(0)
    lines db 100*255 dup(0)  
    newline db 13, 10, '$'
    line_count dw 0
    line_pos dw 0
    handle dw ?
    key db 'aa', 0             
    key_len dw 2               
    matches dw 100 dup(0)      
    
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
    jnz process_bytes   
    jmp close_file

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
    
    push ax             
    push cx             
    
    mov ax, line_count
    mov cx, 255
    mul cx
    add ax, line_pos
    mov di, ax          
    
    pop cx              
    pop ax              
    
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
    push ax
    push cx
    
    mov ax, line_count
    mov cx, 255
    mul cx
    add ax, line_pos
    mov di, ax
    
    pop cx
    pop ax
    
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
    
    cmp byte ptr lines[si], 0
    je count_done

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

end main