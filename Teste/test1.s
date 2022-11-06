.data
.text
.globl main
main:
    mov $0x80000000, %eax
    mov $0x8, %ebx
    mov $0x1, %ecx
    mov $0x4, %edx

etmul:
    mul %ebx

exit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

; eax = 0
; edx = 4

; ebx = 8
; ecx = 1

