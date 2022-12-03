;/ 2) Se citesc de la tastatura un numar x, un numar n si apoi un vector cu n numere naturale.
;/    Sa se stocheze in memorie si sa se afiseze pe ecran doar acele numere din vector care sunt multiplii de x.

.data
    x: .space 4
    n: .space 4
    t: .long 0
    nrCitit: .space 4
    v: .space 100       ;/ => 100/4 = 25 de numere

    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld"
    newSpace: .asciz " "
    
.text

.global main
main:
    ;/ citeste x
    pushl $x
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste n
    pushl $n
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx
et_for:
    cmp n, %ecx
    je et_afis

    pushl %ecx

    pushl $nrCitit
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    popl %ecx

    movl nrCitit, %eax
    movl $0, %edx
    divl x

    movl $0, %ebx
    cmp %ebx, %edx
    je memoreaza

    inc %ecx
    jmp et_for

memoreaza:
    lea v, %edi
    movl nrCitit, %ebx
    movl t, %edx
    movl %ebx, (%edi, %edx, 4)
    incl t

    incl %ecx
    jmp et_for

et_afis:
    lea v, %edi

    movl $0, %ecx
    et_afis_for:
        cmp t, %ecx
        je et_exit

        pushl %ecx

        pushl (%edi, %ecx, 4)
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

        popl %ecx

        incl %ecx
        jmp et_afis_for

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

