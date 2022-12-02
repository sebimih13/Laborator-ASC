.data
    nrMax: .long 0
    nrAp: .long 0
    n: .long 5
    v: .long 2, 1, 2, 1, 2
.text
.globl main
main:
    lea v, %edi
    mov $0, %ecx

etloop:
    cmp n, %ecx
    je etexit

    movl (%edi, %ecx, 4), %edx
    add $1, %ecx
    
    cmp nrMax, %edx
    ;// nr > nrMax
    ja newNrMax
    ;// nr == nrMax
    je incNrAp

    jmp etloop

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

newNrMax:
    movl %edx, nrMax
    movl $1, nrAp
    jmp etloop

incNrAp:
    mov nrAp, %eax      ;// ??? add $1, %nrAp
    add $1, %eax
    movl %eax, nrAp
    jmp etloop

