.data


.text
    proc1:
        movl $0, %eax

        ret


.globl main
main:
    
    movl $15, %eax
    call proc1

exit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

