.model small
.stack 100h
.data
    msg db '  $'
.code
main proc
    
mov ax, SEG @data     ; Load data segment address into AX
mov ds, ax            ; Set DS to point to the data segment
mov dx, offset msg    ; Load address of 'msg' into DX
mov ah, 9             ; Set AH for DOS function 9 (display string)
mov di, offset msg    ; Load address of 'msg' into DI
mov cx, 30h           ; Set CX to 0 
mov [di], cl          ; Store 0 into 'msg'

start_loop:
int 21h               ; Display the string
inc cx                ; Increment CX
mov [di], cl          ; Store updated character in 'msg'
cmp cx, 3ah           ; Compare CX with 9
jnz start_loop        ; Loop if CX != 9

mov ax, 4C00h         ; Prepare for program exit
int 21h               ; Exit program

main endp
end main

