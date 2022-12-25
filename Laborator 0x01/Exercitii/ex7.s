.data
	n: .long 5
	x: .long 1
	y: .long 1
	z: .space 4
	i: .space 4
	
	formatPrintf: .asciz "%ld \n"

.text
aduna:	;/ aduna(long a, long b) = return a+b
	pushl %ebp
	movl %esp, %ebp
	
	;/ Parametrii
	;/ a = 8(%ebp) 
	;/ b = 12(%ebp)
	
	movl 8(%ebp), %eax
	addl 12(%ebp), %eax
	
	;/ return eax
	
	popl %ebp
	ret
	
iteratie: ;/ iteratie(long *a, long *b)
	pushl %ebp
	movl %esp, %ebp
	
	subl $4, %esp
	
	;/ Parametrii
	;/ *a = 8(%ebp)
	;/ *b = 12(%ebp)
	
	;/ Valori locale
	;/ c = -4(%ebp)
	
	movl $0, %ecx
	
	movl 8(%ebp), %esi
	movl (%esi, %ecx, 4), %eax
	
	movl 12(%ebp), %esi
	movl (%esi, %ecx, 4), %ebx
	
	pushl %eax
	pushl %ebx
	call aduna
	addl $8, %esp
	;/ return in eax
	
	movl %eax, -4(%ebp)		;/ c = aduna(a, b)
	
	movl $0, %ecx
	
	;/ a = b
	movl 12(%ebp), %esi
	movl (%esi, %ecx, 4), %ebx

    movl 8(%ebp), %esi	
	movl %ebx, (%esi, %ecx, 4)
	
	;/ b = c
    movl 12(%ebp), %esi
    movl -4(%ebp), %eax
	movl %eax, (%esi, %ecx, 4)
	
	addl $4, %esp
	
	popl %ebp
	ret
	

.global main
main:
	movl $2, i
	main_for:
		movl i, %eax
		movl n, %ebx

		cmp %eax, %ebx
		je main_for_end
		
		pushl $y
		pushl $x
		call iteratie
		addl $8, %esp
		
		incl i
		jmp main_for
		
	main_for_end:
		movl y, %eax
		movl %eax, z
		
		pushl z
		pushl $formatPrintf
		call printf	
		addl $8, %esp

main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80

