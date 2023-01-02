.data
    formatPrintf: .asciz "%ld \n"

    x: .long 3
    y: .long 5

.text
customEven:     ;/ customEven(x, y)
    pushl %ebp
    movl %esp, %ebp

    ;/ Registrii callee-saved
    pushl %ebx

    ;/ Argumente
    ;/ x = 8(%ebp)
    ;/ y = 12(%ebp)

    ;/ Variabile locale
    subl $8, %esp

    ;/ prod = -8(%ebp)
    ;/ suma = -12(%ebp)

    movl 8(%ebp), %eax
    movl 12(%ebp), %ebx
    movl $0, %edx
    imull %ebx

    ;/ eax = x * y
    movl %eax, -8(%ebp)
    movl $0, -12(%ebp)

    customEven_for:
        movl -8(%ebp), %eax
        movl $0, %ecx
        cmp %ecx, %eax
        je customEven_suma

        movl $0, %edx
        movl $10, %ebx
        divl %ebx
        
        addl %edx, -12(%ebp)
        movl %eax, -8(%ebp)

        jmp customEven_for


    customEven_suma:
        movl -12(%ebp), %eax
        movl $0, %edx
        movl $2, %ebx
        divl %ebx

        movl $1, %eax
        xor %edx, %eax
        ;/ return %eax

        addl $8, %esp

        ;/ Registrii callee-saved
        popl %ebx
        
        popl %ebp
        ret


.global main
main:
    pushl x
    pushl y
    call customEven
    addl $8, %esp

    pushl %eax
    pushl $formatPrintf
    call printf
    addl $8, %esp

main_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

