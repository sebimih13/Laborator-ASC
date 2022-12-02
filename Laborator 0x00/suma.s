.data
    n: .long 5
    s: .space 4
.text
.globl main
main:
    mov $0, %ecx
    
etloop:
    cmp n, %ecx
    je etexit
    
    add %ecx, s
    add $1, %ecx
    
    jmp etloop
   
etexit:
   mov $1, %eax
   mov $0, %ebx
   int $0x80
   

