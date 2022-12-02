.data
    n: .long 17

    textValid: .asciz "nr este prim\n"
    textInvalid: .asciz "nr nu este prim\n"
.text
.globl main
main:
    mov $2, %ecx

etloop:
    cmp n, %ecx
    je valid

    ;// if (n % d == 0) -> invalid
    mov $0, %edx
    mov n, %eax
    mov %ecx, %ebx
    idiv %ebx
    
    mov $0, %eax
    cmp %edx, %eax
    je invalid

    add $1, %ecx
    jmp etloop

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

valid:
    mov $4, %eax
    mov $1, %ebx
    mov $textValid, %ecx
    mov $14, %edx
    int $0x80

    jmp etexit

invalid:
    mov $4, %eax
    mov $1, %ebx
    mov $textInvalid, %ecx
    mov $17, %edx
    int $0x80

    jmp etexit

