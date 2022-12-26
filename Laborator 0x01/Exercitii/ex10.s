.data
	n: .long 5
	k: .long 3

	formatPrintf: .asciz "%ld \n"
	
.text
combinari:	;/ combinari(n, k)
	pushl %ebp
	movl %esp, %ebp
	
	subl $4, %esp
	
	;/ Parametrii
	;/ n = 8(%ebp)
	;/ k = 12(%ebp)
	
	;/ Variabile locale
	;/ s = -4(%ebp)
	
	;/ k == 0 => return 1
	movl 12(%ebp), %eax		;/ eax = k
	movl $0, %ebx			;/ ebx = 0
	cmp %eax, %ebx
	je combinari_1
	
	;/ k == n => return 1
	movl 12(%ebp), %eax		;/ eax = k
	movl 8(%ebp), %ebx		;/ ebx = n
	cmp %eax, %ebx
	je combinari_1
	
	
	;/ C(n-1,k)
	movl 8(%ebp), %eax
	subl $1, %eax
	
	pushl 12(%ebp)	;/ k
	pushl %eax		;/ n-1
	call combinari
	addl $8, %esp
	
	movl %eax, -4(%ebp)
	
	;/ C(n-1,k-1)
	movl 8(%ebp), %eax
	subl $1, %eax
	
	movl 12(%ebp), %ebx
	subl $1, %ebx
	
	pushl %ebx		;/ k-1
	pushl %eax		;/ n-1
	call combinari
	addl $8, %esp
	
	addl %eax, -4(%ebp)
    movl -4(%ebp), %eax
	jmp combinari_exit
	
	combinari_1:
		movl $1, %eax

	combinari_exit:
		;/ return %eax
		addl $4, %esp
		
		popl %ebp
		ret
	

.global main
main:    
    pushl k
	pushl n
    call combinari
    addl $8, %esp

	pushl %eax
	pushl $formatPrintf
	call printf	
	addl $8, %esp
	
	
main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80

