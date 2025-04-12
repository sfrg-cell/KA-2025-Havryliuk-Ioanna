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
    
    mov cx, 20
    mov si, 0
    lea bx, strings
    
input_loop:
    lea dx, prompt_msg
    mov ah, 09h
    int 21h
    
    mov pointers[si], bx
    
    mov di, bx
    
read_line:
    mov ah, 01h
    int 21h
    
    cmp al, 0Dh
    je end_of_line
    
    mov [di], al
    inc di
    jmp read_line
    
end_of_line:
    mov byte ptr [di], '$'
    inc di
    
    cmp di, bx
    je empty_line
    
    inc count
    mov bx, di
    add si, 2
    loop input_loop
    jmp display_output
    
empty_line:
    cmp count, 0
    je display_output
    
    inc count
    mov bx, di
    add si, 2
    loop input_loop
    
display_output:
    lea dx, output_msg
    mov ah, 09h
    int 21h
    
    mov cx, count
    jcxz exit_program
    
    mov ax, count
    dec ax
    shl ax, 1
    mov si, ax
    
output_loop:
    mov dx, pointers[si]
    mov ah, 09h
    int 21h
    
    cmp cx, 1
    je skip_newline
    
    lea dx, line_break
    mov ah, 09h
    int 21h
    
skip_newline:
    sub si, 2
    loop output_loop
    
exit_program:
    mov ax, 4C00h
    int 21h
main endp

end main