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

    ;/ verifica fiecare char daca e vocala
    ;/ 65 - A         97  - a
    ;/ 69 - E         101 - e
    ;/ 73 - I         105 - i
    ;/ 79 - O         111 - o
    ;/ 85 - U         117 - u
    ;/ 0 - '\0'

    movl $0, %eax
    movl $0, %ebx

    lea s, %esi
    movl $0, %ecx
et_for:
    ;/ verifica daca suntem la '\0'
    movb (%esi, %ecx, 1), %al

    movb $0, %bl      ;/ '\0'
    cmp %bl, %al
    je et_afis

    mov $65, %bl      ;/ 'A'
    cmp %bl, %al
    je increment

    mov $69, %bl      ;/ 'E'
    cmp %bl, %al
    je increment

    mov $73, %bl      ;/ 'I'
    cmp %bl, %al
    je increment

    mov $79, %bl      ;/ 'O'
    cmp %bl, %al
    je increment

    mov $85, %bl      ;/ 'U'
    cmp %bl, %al
    je increment

    mov $97, %bl      ;/ 'a'
    cmp %bl, %al
    je increment

    mov $101, %bl     ;/ 'e'
    cmp %bl, %al
    je increment

    mov $105, %bl     ;/ 'i'
    cmp %bl, %al
    je increment

    mov $111, %bl     ;/ 'o'
    cmp %bl, %al
    je increment

    mov $117, %bl     ;/ 'u'
    cmp %bl, %al
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

