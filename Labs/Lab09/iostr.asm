.model small
.stack 100h

.data
    strings db 1000h dup(0)
    pointers dw 20 dup(0)
    prompt_msg db "Enter something: ", 0Dh, 0Ah, "$"
    output_msg db "Your input: ", 0Dh, 0Ah, "$"
    line_break db 0Dh, 0Ah, "$"
    count dw 0

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov cx, 20                        ; Max number of lines to read
    mov si, 0                         ; Index for pointers[]
    lea bx, strings                   ; BX points to start of strings buffer
    
input_loop:
    lea dx, prompt_msg
    mov ah, 09h
    int 21h
    
    mov pointers[si], bx              ; Store current string's start address
    
    mov di, bx                        ; DI points to current writing position
    
read_line:
    mov ah, 01h                       ; Read character from keyboard
    int 21h
    
    cmp al, 0Dh                       ; Check for enter
    je end_of_line
    
    mov [di], al                      ; Store character in buffer
    inc di
    jmp read_line
    
end_of_line:
    mov ax, di
    sub ax, bx                        ; Count length of string
    
    cmp ax, 0                         ; Exit if string is empty
    je exit_input
    
    mov byte ptr [di], '$'            ; Add string terminator
    inc di
    inc count
    mov bx, di
    add si, 2                         ; Move to next slot in pointers[]
    loop input_loop
    jmp display_output
    
exit_input:
    mov byte ptr [di], '$'
    jmp display_output
    
display_output:
    lea dx, output_msg
    mov ah, 09h
    int 21h
    
    mov cx, count
    jcxz exit_program                 ; If no input, exit
    
    mov ax, count
    dec ax
    shl ax, 1
    mov si, ax                        ; SI points to last pointer
    
output_loop:
    mov dx, pointers[si]
    mov ah, 09h
    int 21h
    
    cmp cx, 1
    je skip_newline                  ; Skip newline after last string
    
    lea dx, line_break
    mov ah, 09h
    int 21h
    
skip_newline:
    sub si, 2                         ; Move to previous string pointer
    loop output_loop                  ; Repeat until all lines printed
    
exit_program:
    mov ax, 4C00h
    int 21h
main endp

end main