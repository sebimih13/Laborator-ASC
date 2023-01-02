.data
    formatPrintf: .asciz "%ld "

.text
divisors:       ;/ divisors(x)
    pushl %ebp
    movl %esp, %ebp

    ;/ Registrii callee-saved
    pushl %ebx

    ;/ Argumente
    ;/ x = 8(%ebp)

    movl $1, %ecx
    divisors_for:
        cmp 8(%ebp), %ecx
        jg divisors_exit

        movl 8(%ebp), %eax
        movl $0, %edx
        divl %ecx

        movl $0, %ebx
        cmp %edx, %ebx
        jne divisors_for_cont

        pushl %ecx

        pushl %ecx
        pushl $formatPrintf
        call printf
        addl $8, %esp

        pushl $0
        call fflush
        addl $4, %esp

        popl %ecx

        divisors_for_cont:
            addl $1, %ecx
            jmp divisors_for


    divisors_exit:
        ;/ Registrii callee-saved
        popl %ebx

        popl %ebp
        ret


.global main
main:
    pushl $24
    call divisors
    addl $4, %esp

main_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

