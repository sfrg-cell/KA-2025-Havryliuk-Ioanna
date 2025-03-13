.model small
.stack 100h
.data
arr dw 16 dup(0)

.code
main proc
mov ax, SEG @data
mov ds, ax           
mov di, offset arr
mov cl, 30 

loop_arr:
mov [di], cl     
cmp cl, 21      
je new
dec cl          
inc di              
jmp loop_arr

new:
mov di, offset arr
xor al, al

zero_loop:
mov [di], al
inc di 
cmp di, 32
jne zero_loop

mov di, offset arr
mov ax, 0           
mov [di], ax       
add di, 2
mov bx, 1           
mov [di], bx      
add di, 2

mov cx, 16  

fib_loop:
add ax, bx
mov [di], ax
add di, 2 
mov ax, bx
mov bx, [di - 2]    

dec cx
cmp cx, 0
jne fib_loop


mov ax, 4c00h
int 21h

main endp
end main