.data
    nrMax: .long 0
    nrAp: .long 0
    n: .long 5
    v: .long 1, 1, 2, 1, 2
.text
.globl main
main:
    lea v, %edi
    mov n, %ecx

etloop:
    mov n, %eax
    sub %ecx, %eax
    movl (%edi, %eax, 4), %edx
    
    cmp nrMax, %edx
    ;// nr > nrMax
    ja newNrMax
    ;// nr == nrMax
    je incNrAp

    loop etloop

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

newNrMax:
    movl %edx, nrMax
    movl $1, nrAp
    loop etloop

incNrAp:
    add $1, nrAp    ;// Warning: no instruction mnemonic suffix given and no register operands; using default for `add'
    loop etloop

;// SEGMENTATION FAULT

