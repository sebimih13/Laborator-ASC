.data
.text
.globl main
main:
    mov $8, %eax
    shr $2, %eax
    
    mov $8, %eax
    shl $2, %eax
    
    mov $-8, %eax
    sar $2, %eax
    
    mov $-8, %eax
    sal $2, %eax
    
    mov $1, %eax
    mov $0, %ebx
    int $0x80
    
    
