.data
    formatPrintf: .asciz "%ld  "
    formatPrintf2: .asciz "%ld \n"
    formatPrintf3: .asciz "\n\n"

    n: .long 5
    v: .long 12, 4, 2, 3, 1
    index: .long 0

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


divisors:       ;/ divisors(x)
    pushl %ebp
    movl %esp, %ebp

    ;/ Registrii callee-saved
    pushl %ebx

    ;/ Argumente
    ;/ x = 8(%ebp)

    movl $1, %ecx
    divisors_for:
        cmp 8(%ebp), %ecx
        jg divisors_exit

        movl 8(%ebp), %eax
        movl $0, %edx
        divl %ecx

        movl $0, %ebx
        cmp %edx, %ebx
        jne divisors_for_cont

        pushl %ecx

        pushl %ecx
        pushl $formatPrintf
        call printf
        addl $8, %esp

        pushl $0
        call fflush
        addl $4, %esp

        popl %ecx

        divisors_for_cont:
            addl $1, %ecx
            jmp divisors_for


    divisors_exit:
        ;/ Registrii callee-saved
        popl %ebx

        popl %ebp
        ret


.global main
main:
    movl $0, index
    main_for:
        movl n, %eax
        subl $1, %eax
        cmp index, %eax
        je main_special

        lea v, %esi

        movl index, %eax
        pushl (%esi, %eax, 4)
        incl %eax
        pushl (%esi, %eax, 4)
        call customEven
        addl $8, %esp

        movl $1, %ebx   
        cmp %eax, %ebx
        jne main_for_cont

        ;/ afiseaza
        movl index, %eax
        pushl (%esi, %eax, 4)
        pushl $formatPrintf2
        call printf
        addl $8, %esp

        movl index, %eax
        pushl (%esi, %eax, 4)
        call divisors
        addl $4, %esp

        pushl $formatPrintf3
        call printf
        addl $4, %esp


        main_for_cont:
            incl index
            jmp main_for


main_special:
    ;/ trateaza cazul special
    lea v, %esi

    movl n, %eax
    subl $1, %eax
    pushl (%esi, %eax, 4)
    movl $0, %eax
    pushl (%esi, %eax, 4)
    call customEven
    addl $8, %esp

    movl $1, %ebx
    cmp %eax, %ebx
    jne main_exit

    ;/ afiseaza
    movl n, %eax
    subl $1, %eax
    pushl (%esi, %eax, 4)
    pushl $formatPrintf2
    call printf
    addl $8, %esp

    movl n, %eax
    pushl (%esi, %eax, 4)
    call divisors
    addl $4, %esp

    pushl $formatPrintf3
    call printf
    addl $4, %esp


main_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

