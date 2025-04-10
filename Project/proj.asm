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

    cmp ax, 0                                 ; Check if file read is successful           
    jz check_eof
    jmp process_bytes

check_eof:
    call count_shift
    mov byte ptr lines[di], 0                 ; Null to terminate current line

    mov bx, line_count
    call count_substring                      ; Count occurrences of key in the line

    inc line_count
    
    jmp process_results

process_bytes:
    mov cx, ax                                ; Set the number of bytes read         
    xor si, si          

process_char:
    cmp si, cx                                ; Check if end of buffer reached          
    jae read_file       

    mov al, buffer[si]                        ; Load current character  
    
    cmp al, 0Dh         
    je found_cr
    
    cmp al, 0Ah         
    je found_lf
    
    call count_shift             
    
    mov lines[di], al                         ; Store character in the current line 
    inc line_pos 
    cmp line_pos, 255                         ; Check if line exceeded maximum length
    jge overflow       
    
    inc si                                    ; Move to the next character              
    jmp process_char

overflow:
    mov ah, 09h
    lea dx, error_msg                         ; Display overflow error
    int 21h
    jmp exit

found_cr:
    inc si                                    ; Skip CR              
    
    cmp si, cx                                ; Check if end of buffer reached          
    jae save_line
    
    cmp buffer[si], 0Ah                       ; Check for LF 
    jne save_line       
    
    inc si                                    ; Skip LF              
    jmp save_line

found_lf:
    inc si                                    ; Skip LF              

save_line:
    call count_shift 
    
    mov byte ptr lines[di], 0                 ; Null to terminate current line    

    push si             
    push cx             
    
    mov bx, line_count  
    call count_substring                      ; Count occurrences of key in the line
    
    pop cx              
    pop si              
    
    inc line_count      
    mov line_pos, 0                           ; Reset line position     
    
    cmp line_count, 100                       ; Check if max line count reached 
    jge overflow

    jmp process_char   

process_results:
    
    call bubble_sort                          ; Sort the results

    mov cx, line_count
    xor si, si                                ; Initialize index for displaying results

display_loop:   
    cmp si, cx                                ; Check if all lines are processed
    jae exit

    mov bx, si
    shl bx, 1                                 ; Multiply index by 2 for 16-bit access 
    mov ax, matches[bx]
    
    call print_number                         ; Print match count
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    mov ax, line_indexes[bx]
    call print_number                         ; Print line index
    
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
    mov cx, 255                                ; Multiply line_count by 255
    mul cx
    add ax, line_pos                           ; Add current position in the line
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
    mul bx                                     ; Multiply by 255 to get the byte offset for the line             
    mov si, ax          
    xor cx, cx                                 ; Initialize match count          
    
count_loop:
    cmp byte ptr lines[si], 0                  ; Check if line is terminated
    je count_done
    
    mov di, 0                                  ; Initialize key index           
    
match_loop:
    mov al, key[di]     
    cmp al, 0                                  ; Check if the key is finished          
    je match_found      
    
    push bx             
    mov bx, si                                 ; Store line index          
    add bx, di                                 ; Add key index to line offset          
    mov ah, lines[bx]   
    pop bx              
    
    cmp ah, 0                                  ; Check if end of line reached           
    je count_done       
    
    cmp ah, al                                 ; Compare current line character with key          
    jne match_failed    
    
    inc di                                     ; Move to the next key character              
    jmp match_loop      
    
match_found:
    inc cx                                     ; Increment match count              
    add si, di                                 ; Move to the next part of the line          
    jmp count_loop      
    
match_failed:
    inc si                                     ; Move to the next character in the line              
    jmp count_loop      
    
count_done:
    mov di, bx
    shl di, 1           
    mov matches[di], cx                        ; Store the match count 
    
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
    jae sort                                   ; If all lines processed, go to sorting
    
    mov bx, si
    shl bx, 1
    mov line_indexes[bx], si                   ; Store the index in line_indexes
    
    inc si
    jmp init
    
sort:
    mov cx, line_count
    dec cx
    jz sort_finish
    
outer_loop:
    xor si, si                                 ; Reset index for outer loop
    
inner_loop:
    mov bx, si
    shl bx, 1
    
    mov ax, matches[bx]
    mov dx, matches[bx+2]
    
    cmp ax, dx                                  ; Compare current and next match counts
    jle next_chars                              ; If no swap needed, continue
    
    mov matches[bx], dx
    mov matches[bx+2], ax                       ; Swap match counts
    
    mov ax, line_indexes[bx]
    mov dx, line_indexes[bx+2]
    mov line_indexes[bx], dx
    mov line_indexes[bx+2], ax                  ; Swap line indexes
    
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
    
    test ax, ax                                 ; Check if the number is zero
    jnz extract_digits
    
    mov ah, 02h
    mov dl, '0'
    int 21h
    jmp print_number_end
    
extract_digits:
    xor dx, dx
    div bx                                      ; Divide ax by 10
    push dx
    inc cx
    test ax, ax                                 ; Test if ax is zero
    jnz extract_digits
    
output_digits:
    pop dx                                      ; Pop the last digit
    add dl, '0'                                 ; Convert the digit to ASCII
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