.model small            
.stack 100h             

.data                   
msg db "123 ", '$'      

.code                   
main proc               
    mov ax, SEG @data  
    mov ds, ax         
    mov di, offset msg 
    mov dx, offset msg 
    mov ah, 9h         

    add di, 2          
    mov al, [di]       
    mov cl, al         

start_loop:             
    int 21h            

    dec cx             
    mov [di], cl       
    cmp cx, 2fh        
    jne start_loop      

    dec di             
    mov cl, [di]       
    cmp cx, 30h        
    je start_loop             

    dec cl             
    mov [di], cl       
    inc di             
    mov cl, 39h        
    mov [di], cl       
    jmp start_loop      

if0:                    
    dec di             
    mov cl, [di]       
    cmp cx, 30h        
    je exit             
    dec cl             
    mov [di], cl       
    inc di             
    mov cl, 39h        
    mov [di], cl       
    inc di             
    mov [di], cl       
    jmp start_loop     

exit:                    
    mov ax, 4c00h      
    int 21h            

main ENDP               
end main                

