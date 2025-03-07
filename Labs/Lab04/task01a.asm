.model small
.stack 100h
.data
arr db 10 dup(0)

.code
main proc
mov ax, SEG @data
mov ds, ax           
mov di, offset arr
mov cl, 30 

loop_start_arr:
mov [di], cl     
cmp cl, 21      
je end_array
dec cl          
inc di              
jmp loop_start_arr

end_array:
mov si, offset arr 

view:
mov al, [si]       
cmp al, 0          
je exit         

mov ah, 0  
mov bl, al     
    
mov dl, 0 

divide_10:
cmp bl, 10       
jl done_divide
sub bl, 10       
inc dl        
jmp divide_10

done_divide:
add dl, '0' 
mov dl, dl 
mov ah, 02h
int 21h

add bl, '0'
mov dl, bl
mov ah, 02h 
int 21h
inc si
jmp view

exit:
mov ax, 4c00h
int 21h
main endp
end main