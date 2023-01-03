.data
    v: .long 4, 5, 6, 7
    i: .long 2

    formatPrintf: .asciz "%ld \n"

.text

.global main
main:
    lea v, %edi
    movl i, %ecx
    movl (%edi, %ecx, 4), %ebx

    pushl %ebx
    pushl $formatPrintf
    call printf
    addl $8, %esp

    lea i, %edi
    movl v, %ecx
    movl (%edi, %ecx, 4), %ebx

    pushl %ebx
    pushl $formatPrintf
    call printf
    addl $8, %esp

main_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

