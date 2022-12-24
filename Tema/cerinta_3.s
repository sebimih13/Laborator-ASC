
;/ 1. argumentele trebuie incarcate pe stiva pentru apel, conform standardului x86, de la dreapta la stanga

;/ 2. registrii %eax, %ecx si %edx sunt singurii care NU trebuie restaurati in urma apelului, 
;/    fiind si registrii de returnare; toti ceilalti registri trebuie restaurati!

;/ 3. in cadrul de apel utilizam registrul %ebp conform conventiei x86, prezentata la laborator si in suportul 0x01 de laborator

;/ 4. in cadrul de apel NU se utilizeaza variabile din sectiunea .data! 
;/    Toate variabilele au scop local, deci se vor afla pe stiva, si vor fi accesate prin intermediul lui %ebp!

;/ CONTINE CERINTELE 1 + 2

.data
    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld "     ;/ TODO : inca un printf fara spatiu ?
    newLine: .asciz "\n"

    cerinta: .space 4
    n: .space 4

    iterator: .space 4

.text
        
.global main
main:
    movl $3, n
    
    movl $0, iterator
et_incarcare:
    movl iterator, %ecx
    cmp %ecx, n
    je et_exit
    
    movl $192, %eax
    movl $0, %ebx
    movl $62500, %ecx   ;/ dimensiunea de alocat -> de schimbat in (n + 5)
    movl $3, %edx       ;/ prot   = PROT_READ | PROT_WRITE = 1 + 2 = 3
    movl $17, %esi      ;/ flags  = MAP_ANONYMOUS | MAP_SHARED = 16 + 1 = 17
    movl $-1, %edi      ;/ fd     = 0 sau -1 (require fd to be -1 if MAP_ANONYMOUS)
    movl $0, %ebp       ;/ offset = 0
    int $0x80

    incl iterator
    jmp et_incarcare


et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

