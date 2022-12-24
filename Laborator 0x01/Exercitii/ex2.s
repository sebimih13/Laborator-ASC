.data
	s1: .asciz "abcdef"
	s2: .asciz "xyzw"
	
	formatPrintf: .asciz "%s\n"

.text

print:  ;/ print(x)
    push %ebp
    mov %esp, %ebp

    pushl 8(%ebp)
    pushl $formatPrintf
    call printf
    addl $8, %esp

    popl %ebp
    ret

assembly_memcpy:		;/ void *memcpy(void *dest, const void *src, size_t n)
	pushl %ebp
	movl %esp, %ebp
	
	subl $4, %esp
	
	;/ Parametrii
	;/ dest = 8(%ebp)
	;/ src  = 12(%ebp)
	;/ n    = 16(%ebp)
	
	;/ Variabile locale
	;/ index = -4(%ebp)

	movl $0, -4(%ebp)
	memcpy_for:
		movl -4(%ebp), %eax
		movl 16(%ebp), %ebx
			
		cmp %eax, %ebx
		je memcpy_exit
		
		movl 8(%ebp), %edi
		movl 12(%ebp), %esi
		movl -4(%ebp), %ecx
		
        movb (%esi, %ecx, 1), %al
		movb %al, (%edi, %ecx, 1)
		
		incl -4(%ebp)
		jmp memcpy_for
		
	memcpy_exit:
        ;/ returneaza dest
        movl 8(%ebp), %eax
		
        addl $4, %esp

		popl %ebp
		ret

.global main
main:
	pushl $s1
	call print
	addl $4, %esp
	
	pushl $s2
	call print
	addl $4, %esp

    pushl $2
    pushl $s2
    pushl $s1
    call assembly_memcpy
    addl $12, %esp

    pushl $s1
	call print
	addl $4, %esp
	
	pushl $s2
	call print
	addl $4, %esp

main_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
;/ TODO : de restaurat in procedura

