.data
	formatPrintf: .asciz "%ld \n"
	
.text
fibonacci:	;/ fibonacci(x)
	pushl %ebp	
	movl %esp, %ebp
	
	subl $8, %esp
	
	;/ Parametrii
	;/ x = 8(%ebp)
	
	;/ Variabile locale
	;/ t1 = -4(%ebp)
	;/ t2 = -8(%ebp)
	
	movl 8(%ebp), %ebx
	
	movl $0, %eax
	cmp %eax, %ebx
	je fibonacci_exit
	
	movl $1, %eax
	cmp %eax, %ebx
	je fibonacci_exit
	
	
	;/ get fibonacci(x - 1)
	movl 8(%ebp), %ebx
	subl $1, %ebx
	pushl %ebx
	call fibonacci
	addl $4, %esp
	
	movl %eax, -4(%ebp)
	
	;/ get fibonacci(x - 2)
	movl 8(%ebp), %ebx
	subl $2, %ebx
	pushl %ebx
	call fibonacci
	addl $4, %esp
	
	movl %eax, -8(%ebp)
	
	;/ eax = fibonacci(x - 1) + fibonacci(x - 1)
	movl -4(%ebp), %eax
	addl -8(%ebp), %eax
	
	
	fibonacci_exit:
		;/ return %eax
		addl $8, %esp
	
		popl %ebp
		ret	


.global main
main:
    pushl $10
    call fibonacci
    addl $4, %esp

	pushl %eax
	pushl $formatPrintf
	call printf	
	addl $8, %esp
	
	
main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80

