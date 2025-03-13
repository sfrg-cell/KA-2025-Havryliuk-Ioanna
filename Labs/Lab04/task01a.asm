.model small
.stack 100h
.data
arr dw 10 dup(0)

.code
main proc
mov ax, SEG @data
mov ds, ax           
mov di, offset arr
mov cl, 30 

loop_arr:
mov [di], cl     
cmp cl, 21      
je exit
dec cl          
inc di              
jmp loop_arr

exit:
mov ax, 4c00h
int 21h
main endp
end main