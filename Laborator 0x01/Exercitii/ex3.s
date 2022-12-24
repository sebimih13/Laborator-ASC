.data
    s: .asciz "1235321"
	
	formatPrintf: .asciz "%ld \n"

.text
assembly_atoi:	;/ atoi(const char *s)
	pushl %ebp
	movl %esp, %ebp
	
	subl $12, %esp

	;/ Parametrii
	;/ s = 8(%ebp)
	
	movl 8(%ebp), %esi
	
	;/ Variabile locale
	;/ index = -4(%ebp)
	;/ numar = -8(%ebp)
	;/ cifra = -12(%ebp)
	
	movl $0, -4(%ebp)
	movl $0, -8(%ebp)
	movl $0, -12(%ebp)
	
	atoi_for:
		movl -4(%ebp), %ecx
		movb (%esi, %ecx, 1), %al
		movb %al, -12(%ebp)
		
		;/ verifica daca am terminat
		cmp $0, %al
		je atoi_exit_1
		
		;/ if %al < '0' - return 0
		cmp $'0', %al
		jl atoi_exit_0
		
		;/ if %al > '9' - return 0
		cmp $'9', %al
		jg atoi_exit_0
		
        ;/ cifra = ...
        subb $'0', -12(%ebp)

		;/ numar = numar * 10 + al
		movl -8(%ebp), %eax
		movl $10, %ebx
		mul %ebx
		
		addl -12(%ebp), %eax
		movl %eax, -8(%ebp)
		
		incl -4(%ebp)
		jmp atoi_for
	
	atoi_exit_1:
		movl -8(%ebp), %eax
		jmp atoi_exit
	
	atoi_exit_0:
		movl $0, %eax
		
	atoi_exit:
		addl $12, %esp
	
		popl %ebp
		ret

.global main
main:
	pushl $s
    call assembly_atoi
    addl $4, %esp

	pushl %eax
	pushl $formatPrintf
	call printf	
	addl $8, %esp

main_exit:	
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
;/ TODO : de restaurat in procedura

