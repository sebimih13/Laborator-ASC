.data
    x: .space 4
    formatString: .asciz "%ld"

.text

.global main
main:
    pushl $x
    pushl $formatString
    call scanf
    popl %ebx
    popl %ebx

exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

