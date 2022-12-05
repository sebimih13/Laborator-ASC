;/ 3) Se citeste un string de la tastatura. Sa se afizeze pe ecran numarul de vocale.

.data
    s: .space 100   ;/ => 100/1 = 100 de char
    v: .long 0

    formatPrintf: .asciz "%ld"

.text

.global main
main:
    ;/ citeste s
    pushl $s
    call gets
    popl %ebx

    movl $0, %eax
    movl $0, %ebx

    lea s, %esi
    movl $0, %ecx
et_for:
    movb (%esi, %ecx, 1), %al

    ;/ verifica daca suntem la '\0'
    movb $0, %bl      ;/ '\0'
    cmp %bl, %al
    je et_afis

    cmp $'A', %al
    je increment

    cmp $'E', %al
    je increment

    cmp $'I', %al
    je increment

    cmp $'O', %al
    je increment

    cmp $'U', %al
    je increment

    cmp $'a', %al
    je increment

    cmp $'e', %al
    je increment

    cmp $'i', %al
    je increment

    cmp $'o', %al
    je increment

    cmp $'u', %al
    je increment

    incl %ecx
    jmp et_for

increment:
    incl v
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

