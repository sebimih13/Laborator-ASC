.data
    x: .long 1
    y: .long 4
.text
.globl main
main:
    mov x, %eax
    not %eax

    mov x, %eax
    mov y, %ebx
    and %ebx, %eax
    
    mov x, %eax
    mov y, %ebx
    test %ebx, %eax
 
    mov x, %eax
    mov y, %ebx
    or %ebx, %eax
    
    mov x, %eax
    mov y, %ebx
    xor %ebx, %eax

    mov $1, %eax
    mov $0, %ebx
    int $0x80
    
    
