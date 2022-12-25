.data
	s: .long 4
	
	formatPrintf: .asciz "%ld \n"

.text
aduna:	;/ aduna(long *a, long n, ...)
	pushl %ebp
	movl %esp, %ebp
	
	;/ Parametrii
	;/ a = 8(%ebp)
	;/ n = 12(%ebp)

    ;/ Variabile locale
    subl $4, %esp
    movl $0, -4(%ebp)
	
	movl $0, %ecx
	movl 8(%ebp), %edi          ;/ incarca a
	movl $0, (%edi, %ecx, 4)    ;/ a = 0

	aduna_for:
		movl 12(%ebp), %eax
        movl -4(%ebp), %ebx

		cmp %eax, %ebx
		je aduna_exit

        movl -4(%ebp), %ecx
		movl 16(%ebp, %ecx, 4), %eax
		movl $0, %ecx	
		addl %eax, (%edi, %ecx, 4)
		
		incl -4(%ebp)
		jmp aduna_for
	
	aduna_exit:		
        addl $4, %esp

		popl %ebp
		ret

.global main
main:
	pushl $6
	pushl $2
	pushl $2
	pushl $3
	pushl $s
	call aduna
	addl $20, %esp

	pushl s
	pushl $formatPrintf
	call printf
	addl $8, %esp

main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
