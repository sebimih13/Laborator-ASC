.data
    x: .long 23
    formatString: .asciz "Numarul de afisat este: %ld"

.text

.global main
main:
    pushl x
    pushl $formatString
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

