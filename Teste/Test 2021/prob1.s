
.data
	x: .space 4
	
    formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld \n"
	
.text
f:	;/ f(x)
	pushl %ebp
	movl %esp, %ebp

    ;/ salveaza registrii callee-saved
    pushl %ebx

	;/ Parametrii
	;/ x = 8(%ebp)

	;/ x == 1 		-> stop
	movl $0, %eax
	movl 8(%ebp), %ebx
    movl $1, %ecx
	cmp %ebx, %ecx
	je f_exit
	
	;/ x % 2 = ?
	movl 8(%ebp), %eax
	movl $0, %edx
	movl $2, %ebx
	divl %ebx
	
	;/ rest = %edx
    movl $0, %ecx
	cmp %edx, %ecx
	je f_par
	jmp f_impar
	
	
	f_par:		;/ f(x / 2)
		pushl %eax
		call f
		addl $4, %esp
		
		addl $1, %eax
		
		jmp f_exit
	
	
	f_impar:	;/ f(3 * x + 1)
		movl 8(%ebp), %eax
		movl $0, %edx
		movl $3, %ebx
		mull %ebx
		
		addl $1, %eax
		
		pushl %eax
		call f
		addl $4, %esp
		
		addl $1, %eax
		jmp f_exit

	
	f_exit:
		;/ return %eax

        ;/ salveaza registrii callee-saved
        popl %ebx
	
		popl %ebp
		ret
	

.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp

	pushl x
	call f
	addl $4, %esp
	
	pushl %eax
	pushl $formatPrintf
	call printf
	addl $8, %esp
	

main_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
