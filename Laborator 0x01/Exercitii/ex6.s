.data
	formatPrintf: .asciz "%ld "

.text
proc:	;/ proc(long x)
	pushl %ebp
	movl %esp, %ebp

	;/ Parametrii
	;/ x = 8(%ebp)
	
	pushl 8(%ebp)
	pushl $formatPrintf
	call printf
	addl $8, %esp
	
	pushl $0
	call fflush
	addl $4, %esp
	
	movl $0, %eax
	movl 8(%ebp), %ebx

    cmp %eax, %ebx
	je proc_exit
	
	movl 8(%ebp), %eax
	subl $1, %eax
	
	pushl %eax
	call proc
	addl $4, %esp
	
	proc_exit:
		popl %ebp
		ret
		

.global main
main:
	pushl $10
	call proc
	addl $4, %esp

main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
