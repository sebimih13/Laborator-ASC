.data
    a: .long 4
    b: .long 7
    c: .long 13
    min: .space 4
.text
.globl main
main:
    jmp cmpAB

cmpAB:
    ;// min = min(a, b)
    mov a, %eax
    mov b, %ebx
    cmp %ebx, %eax
    jle aMic
    jg bMic

aMic:
    mov %eax, min
    jmp cmpMC

bMic:
    mov %ebx, min
    jmp cmpMC

cmpMC:
    ;// min = min(min(a, b), c)
    mov min, %eax
    mov c, %ebx
    cmp %ebx, %eax
    jle mMic
    jg cMic

mMic:
    mov %eax, min
    jmp etexit

cMic:
    mov %ebx, min
    jmp etexit

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

