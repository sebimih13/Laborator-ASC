.data
    x: .long 17
    y: .long 6
.text
.globl main
main:
    mov $1, %edx
    mov x, %eax
    
    jmp et

    mov $0, %edx

et:
    divl y

exit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

; eax = 715 827 885   catul
; edx = 3           restul

