.data
    x: .long 2
    y: .long 3
    s: .space 4

.text
add:
    pushl %ebp
    mov %esp, %ebp
    
    movl 8(%ebp), %eax
    addl 12(%ebp), %eax

    popl %ebp
    
    ret

.global main
main:
    movl $5, %eax
    movl $6, %ebx

    pushl y
    pushl x

    call add

    popl %edx
    popl %edx

    movl %eax, s

exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

