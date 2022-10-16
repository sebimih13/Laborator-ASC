.data
    x: .long 20
    y: .long 17

    corect: .asciz "PASS\n"
    incorect: .asciz "FAIL\n"

    op1: .space 4
    op2: .space 4

    ;// Modul 1 si 2
    rez1: .space 4
    rez2: .space 4
.text
.globl main
main:
    ;// Modul 1
    ;// x / 16
    mov $0, %edx
    mov x, %eax
    mov $16, %ebx
    idiv %ebx
    mov %eax, op1

    ;// y * 16
    mov y, %eax
    mov $16, %ebx
    imul %ebx
    mov %eax, op2

    mov op1, %eax
    add op2, %eax
    mov %eax, rez1

    ;// Modul 2
    ;// x / 16
    mov x, %eax
    sar $4, %eax
    mov %eax, op1

    ;// y * 16
    mov y, %eax
    sal $4, %eax
    mov %eax, op2

    mov op1, %eax
    add op2, %eax
    mov %eax, rez2

    mov rez1, %eax
    mov rez2, %ebx 
    cmp %eax, %ebx
    je afisCorect
    jne afisIncorect

etexit:
   mov $1, %eax
   mov $0, %ebx
   int $0x80

afisCorect:
    mov $4, %eax
    mov $1, %ebx
    mov $corect, %ecx
    mov $5, %edx
    int $0x80
    
    jmp etexit

afisIncorect:
    mov $4, %eax
    mov $1, %ebx
    mov $incorect, %ecx
    mov $5, %edx
    int $0x80
    
    jmp etexit

