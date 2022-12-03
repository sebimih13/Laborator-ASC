;/ 3) Se citeste un string de la tastatura. Sa se afizeze pe ecran numarul de vocale.

.data
    s: .space 100       ;/ => 100/1 = 100 de char
    v: .long 0
    nrVocale: .long 10

    vocale: .ascii "aeiouAEIOU"
    formatPrintf: .asciz "%ld"

.text

.global main
main:
    ;/ citeste s
    pushl $s
    call gets
    popl %ebx

    ;/ initializeaza registrele
    movl $0, %eax
    movl $0, %ebx

    lea vocale, %esi
    lea s, %edi

    movl $0, %ecx
et_for:
    ;/ verifica daca suntem la '\0'
    movb (%edi, %ecx, 1), %al

    movb $0, %bl      ;/ '\0'
    cmp %bl, %al
    je et_afis

    pushl %ecx

    ;/ verifica fiecare vocala
    movl $0, %ecx
    et_for_vocale:
        cmp nrVocale, %ecx
        je et_for_end

        movb (%esi, %ecx, 1), %bl

        cmp %bl, %al
        je increment

        incl %ecx
        jmp et_for_vocale

        increment:
            incl v
            incl %ecx
            jmp et_for_vocale

        et_for_end:
            popl %ecx

            incl %ecx
            jmp et_for

et_afis:
    ;/ afiseaza v
    pushl v
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

