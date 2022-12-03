;/ 1) Se da un numar a de la tastatura. Sa se afiseze toti divizorii acestuia pe ecran.

.data
    a: .space 4
    d: .long 1

    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld"
    newSpace: .asciz " "
    
.text

.global main
main:
    pushl $a
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

et_for:
    movl a, %eax
    cmp %eax, d
    jg et_exit

    movl $0, %edx
    divl d

    movl $0, %ecx
    cmp %ecx, %edx
    je et_afis

    incl d
    jmp et_for

et_afis:
    pushl d
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
    
    pushl $0
    call fflush
    popl %ebx

    movl $4, %eax
    movl $1, %ebx
    movl $newSpace, %ecx
    movl $2, %edx
    int $0x80

    incl d
    jmp et_for

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

