.data

	formatPrintf: .asciz "%ld \n"

.text

print:  ;/ print(x)
    push %ebp
    mov %esp, %ebp

    pushl 8(%ebp)
    pushl $formatPrintf
    call printf
    addl $8, %esp

    popl %ebp
    ret

    