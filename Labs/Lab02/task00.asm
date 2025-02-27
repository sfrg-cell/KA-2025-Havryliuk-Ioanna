.model small
.stack 100h

.code
main proc

xor ax, ax          ; Clear AX register (set it to 0)
xor bx, bx          ; Clear BX register (set it to 0)
xor cx, cx          ; Clear CX register (set it to 0)
xor dx, dx          ; Clear DX register (set it to 0)

mov ax, 100         ; Load value 100 into AX register
mov bx, 50          ; Load value 50 into BX register

add ax, bx          ; Add the value in BX to AX (AX = AX + BX)

mov cx, 0           ; Set CX register to 0 (initialize loop counter)

loop_start:         
inc cx              ; Increment CX by 1
cmp cx, 40          ; Compare CX with 40
jnz loop_start      ; If CX is not equal to 40, jump back to loop_start (repeat the loop)

sub bx, cx          ; Subtract the value in CX from BX (BX = BX - CX)

mov ax, 4C00h       ; Load value 4C00h into AX (prepare for program exit)
int 21h             ; Call DOS interrupt to terminate the program

main endp
end main