.data
    x: .long 13
    y: .long 4
.text
.globl main
main:
    mov x, %eax
    mov y, %ebx
    movl %ebx, x
    movl %eax, y

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

