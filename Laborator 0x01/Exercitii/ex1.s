.data
    n: .space 4
    index: .space 4
    cnt: .long 0
    x: .space 4
	
    formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld \n"

.text

perfect:    ;/ perfect(x)
    push %ebp
    mov %esp, %ebp

    subl $12, %esp

    ;/ Parametrii
    ;/ x = 8(%ebp)

    ;/ Variabile locale:
    ;/ d = -4(%ebp)
	;/ s = -8(%ebp)
	;/ jumatate = -12(%ebp)
    movl $0, -8(%ebp)

	;/ calculeaza jumatate = x / 2
	movl $0, %edx
	movl 8(%ebp), %eax
	movl $2, %ebx
	divl %ebx
	movl %eax, -12(%ebp)

    movl $1, -4(%ebp)       ;/ d = 1
    et_for_perfect:
        movl -4(%ebp), %eax		;/ eax = d
        movl -12(%ebp), %ebx	;/ ebx = x / 2

        cmp %ebx, %eax      ;/ d ? x
        jg et_verifica_perfect

        movl $0, %edx
        movl 8(%ebp), %eax
        divl -4(%ebp)       ;/ edx = x % d

        movl $0, %eax
        cmp %eax, %edx
        je et_divizor_perfect
		
		et_for_continua_perfect:
			incl -4(%ebp)
			jmp et_for_perfect
			
		et_divizor_perfect:
			movl -4(%ebp), %eax
			addl %eax, -8(%ebp)

			jmp et_for_continua_perfect

    et_verifica_perfect:
		;/ verifica daca s == x
        movl -8(%ebp), %eax
        movl 8(%ebp), %ebx
		
		cmp %eax, %ebx
		je et_valid_perfect
		
		movl $0, %eax
		jmp et_exit_perfect
		
	et_valid_perfect:
		movl $1, %eax
	
	et_exit_perfect:
        addl $12, %esp

        pop %ebp
        ret

.global main
main:
    ;/ citeste n
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp

    movl $0, index      ;/ index = 0
    et_for:
        movl n, %eax
        movl index, %ebx
        
        cmp %eax, %ebx
        je et_exit

        ;/ citeste x
        pushl $x
        pushl $formatScanf
        call scanf
        addl $8, %esp

        pushl x
        call perfect
        addl $4, %esp

        cmp $1, %eax
        je et_valid

        et_for_continua:
            incl index
            jmp et_for

        et_valid:
            incl cnt
            jmp et_for_continua

et_exit:
    pushl cnt
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    mov $1, %eax
    mov $0, %ebx
    int $0x80

;/ TODO : de restaurat in procedura

