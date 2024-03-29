.data
    n: .long 5
    m: .long 100
    formatPrintf: .asciz "%d "

.text

.global main
    f:
        pushl %ebp
        movl %esp, %ebp

        movl $0, %edx
        movl 8(%ebp), %ecx
        movl 12(%ebp), %eax
        divl %ecx
        pushl %eax

        f_for:
            pushl %ecx

            pushl %ecx
            pushl $formatPrintf
            call printf
            popl %ebx
            popl %ebx

            pushl $0
            call fflush
            popl %ebx

            popl %ecx

            loop f_for
        
        f_exit:
            popl %eax
            popl %ebp
            ret


main:
    movl n, %edx
    decl %edx

    pushl m
    pushl %edx
    call f
    popl %ebx
    popl %ebx

    pushl %eax
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx


et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

