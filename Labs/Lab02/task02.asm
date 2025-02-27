.model small
.stack 100h
.data
    msg db '9 $'
.code
main proc
    
mov ax, SEG @data     ; Load the data segment address into AX
mov ds, ax            ; Set DS to point to the data segment
mov dx, offset msg    ; Load the address of 'msg' into DX
mov ah, 9             ; Set AH for DOS function 9 (display string)
mov di, offset msg    ; Load the address of 'msg' into DI
mov cl, [di]          ; Load the first character of 'msg' into CL

start_loop:
int 21h               ; Display the string
dec cl                ; Decrement CL 
mov [di], cl          ; Store the updated value of CL back into 'msg'
cmp cl, 2fh           ; Compare CL with /
jnz start_loop        ; Jump back to start_loop if CL is not /

mov ax, 4C00h         ; Prepare for program exit
int 21h               ; Exit program


main endp
end main