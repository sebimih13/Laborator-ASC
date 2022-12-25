.data
	formatPrintf: .asciz "%ld\n"

.text
g:	;/ g(x) = x + 1
	pushl %ebp
	movl %esp, %ebp
	
	/; Parametrii
	;/ x = 8(%ebp)
	
	movl 8(%ebp), %eax
	addl $1, %eax
	
	popl %ebp
	ret
	
f:	;/ f(x) = 2 * g(x)
	pushl %ebp
	movl %esp, %ebp
	
	/; Parametrii
	;/ x = 8(%ebp)
	
	pushl 8(%ebp)
	call g
	addl $4, %esp
	
	;/ eax = return
	movl $2, %ebx
	mul %ebx
	
	;/ return tot in eax
	
	popl %ebp
	ret


.global main
main:
	pushl $5
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
	
