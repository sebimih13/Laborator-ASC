.data
.text
.globl main
main:
    mov $1, %eax
    mov $0, %ebx
    int $0x80
    
    
