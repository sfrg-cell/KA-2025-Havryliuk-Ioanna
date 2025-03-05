.model small
.stack 100h
.data
a dw 50
b dw 10
c dw 6
.code
main proc

mov ax, SEG @data
mov ds, ax

;if (a > 10 and b <= 50) or (c > 5 and a <= 100): 
;        a = 1
;        if b > 20:  
;            a += 200  
;    else: 
;        a = 0 

mov ax, a
mov bx, b
mov cx, c 

cmp ax, 10
jl false_1
jg true_1

false_1:
cmp cx, 5
jl result_1
jg true_2

true_1:
cmp bx, 50
jg false_1
jle result_2

result_1:
mov a, 0
jmp exit

true_2:
cmp ax, 100
jl result_1
jle result_2

result_2:
mov a, 1
cmp b, 20
jl exit
jg result_3

result_3:
add a, 200
jmp exit

exit:
mov ax, 4C00h       
int 21h             

main endp
end main