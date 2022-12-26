.data
	formatPrintf: .asciz "%ld \n"
	
.text
factorial: 	;/factorial(x)
	pushl %ebp
	movl %esp, %ebp
	
	;/ Parametrii
	;/ x = 8(%ebp)
	
	movl $0, %eax
	movl 8(%ebp), %ebx
	
	cmp %eax, %ebx
	je factorial_0
	
	subl $1, %ebx
	
	pushl %ebx
	call factorial
	addl $4, %esp
	
	movl 8(%ebp), %ebx
	mul %ebx
	
	jmp factorial_exit
	
	factorial_0:
		movl $1, %eax
	
	factorial_exit:
		popl %ebp
		ret
	

.global main
main:
    pushl $5
    call factorial
    addl $4, %esp

	pushl %eax
	pushl $formatPrintf
	call printf	
	addl $8, %esp
	
	
main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80

