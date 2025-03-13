.model small
.stack 100h
.data
    array dw 6*12 dup(0)

.code
main proc
mov ax, SEG @data
mov ds, ax   

mov ch, 0 ; X
mov cl, 0 ; Y


arr_loop:
mov ax, 0
mov bh, 0
mov bl, ch
mov al, cl

call count_func

call store_pr

inc cl
cmp cl, 12
jne arr_loop

mov cl, 0
inc ch
cmp ch, 6
jne arr_loop


mov ax, 4c00h
int 21h

main endp

; X*(Y-3)
count_func proc
mov al, cl    
sub al, 3     
mov bl, ch    
mul bl        
ret
count_func endp

store_pr proc
sub al, 3     
mul bx        
mov bx, ax    
mov ax, 12
mov dl, cl
mov dh, 0
mul ch        
add ax, dx

add ax, ax
xchg ax, bx
mov [array + bx], ax  
ret
store_pr endp

end main
