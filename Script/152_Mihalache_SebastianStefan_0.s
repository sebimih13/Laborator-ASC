
;/ 1. argumentele trebuie incarcate pe stiva pentru apel, conform standardului x86, de la dreapta la stanga

;/ 2. registrii %eax, %ecx si %edx sunt singurii care NU trebuie restaurati in urma apelului, 
;/    fiind si registrii de returnare; toti ceilalti registri trebuie restaurati!

;/ 3. in cadrul de apel utilizam registrul %ebp conform conventiei x86, prezentata la laborator si in suportul 0x01 de laborator

;/ 4. in cadrul de apel NU se utilizeaza variabile din sectiunea .data! 
;/    Toate variabilele au scop local, deci se vor afla pe stiva, si vor fi accesate prin intermediul lui %ebp!

;/ CONTINE CERINTELE 1 + 2

.data
    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld "
    formatPrintf2: .asciz "%ld\n"
    newLine: .asciz "\n"

    cerinta: .space 4
    n: .space 4

    k: .space 4
    start: .space 4
    end: .space 4

    legaturi: .space 500            ;/ 500/4 = 125 de noduri
    nrLegaturi: .space 4
    
    nod: .space 4
    nextNod: .space 4

    iterator: .space 4

    m1: .space 62500            ;/ m1[125][125]
    m2: .space 62500            ;/ m2[125][125]
    mres: .space 62500          ;/ mres[125][125]

.text
    matrix_mult:        ;/ matrix_mult(m1, m2, mres, n)
        pushl %ebp
        movl %esp, %ebp

        ;/ Argumentele procedurii
        ;/ 8(%ebp)      -> m1
        ;/ 12(%ebp)     -> m2
        ;/ 16(%ebp)     -> mres
        ;/ 20(%ebp)     -> n

        ;/ salveaza registrii callee-saved folositi in procedura
        pushl %ebx
        pushl %esi
        pushl %edi

        ;/ spatiu auxiliar pt variabilele locale:
        subl $24, %esp
        movl $0, -16(%ebp)      ;/ i
        movl $0, -20(%ebp)      ;/ j
        movl $0, -24(%ebp)      ;/ k
        movl $0, -28(%ebp)      ;/ m1
        movl $0, -32(%ebp)      ;/ m2
        movl $0, -36(%ebp)      ;/ inmultire

        movl $0, -16(%ebp)								;/ i = 0
        et_for_i:
            movl 20(%ebp), %ebx							;/ ebx = n
            movl -16(%ebp), %ecx					    ;/ ecx = i
            cmp %ebx, %ecx
            je et_exit_matrix_mult						;/ if (i == n) -> exit

            movl $0, -20(%ebp)							;/ j = 0
            et_for_j:
                movl 20(%ebp), %ebx						;/ ebx = n
                movl -20(%ebp), %ecx					;/ ecx = j
                cmp %ebx, %ecx			
                je et_cont_i							;/ if (j == n) -> back to et_for_i

                ;/ mres[i][j] = 0
                movl -16(%ebp), %eax                    ;/ eax = i
                movl $0, %edx
                mull 20(%ebp)                           ;/ eax = i * n
                addl -20(%ebp), %eax                    ;/ eax = i * n + j

                movl 16(%ebp), %edi                     ;/ mres
                movl $0, (%edi, %eax, 4)                ;/ mres[i][j] = 0

                movl $0, -24(%ebp)						;/ k = 0
                et_for_k:
                    movl 20(%ebp), %ebx					;/ ebx = n
                    movl -24(%ebp), %ecx				;/ ecx = k
                    cmp %ebx, %ecx
                    je et_cont_j						;/ if (k == n) -> back to et_for_j
                        
                    ;/ mat[i][j] += mat[i][k] * mat[k][j]
                    
                    ;/ m1 = m1[i][k]
                    movl -16(%ebp), %eax         		;/ eax = i
                    movl $0, %edx               
                    mull 20(%ebp)               		;/ eax = i * n
                    addl -24(%ebp), %eax        		;/ eax = i * n + k

                    movl 8(%ebp), %esi          		;/ m1[][]
                    movl (%esi, %eax, 4), %ebx          ;/ ebx = m1[i][k]
                    movl %ebx, -28(%ebp)  	            ;/ m1 = m1[i][k] 

                    ;/ m2 = m2[k][j]
                    movl -24(%ebp), %eax        		;/ eax = k
                    movl $0, %edx
                    mull 20(%ebp)               		;/ eax = k * n
                    addl -20(%ebp), %eax         		;/ eax = k * n + j

                    movl 12(%ebp), %esi         		;/ m2[][]
                    movl (%esi, %eax, 4), %ebx          ;/ ebx = m2[k][j]
                    movl %ebx, -32(%ebp)  	            ;/ m2 = m2[k][j]

                    ;/ eax = m1 * m2
                    movl -28(%ebp), %eax                ;/ eax = m1
                    movl $0, %edx
                    mull -32(%ebp)                      ;/ eax = m1 * m2
                    movl %eax, -36(%ebp)                ;/ inmultire = m1 * m2

                    ;/ mres[i][j] += inmultire
                    movl -16(%ebp), %eax                ;/ eax = i
                    movl $0, %edx
                    mull 20(%ebp)                       ;/ eax = i * n
                    addl -20(%ebp), %eax                ;/ eax = i * n + j

                    movl 16(%ebp), %edi                 ;/ mres[]][]
                    movl -36(%ebp), %ebx                ;/ ebx = inmultire
                    addl %ebx, (%edi, %eax, 4)

                et_cont_k:
                    incl -24(%ebp)
                    jmp et_for_k

            et_cont_j:
                incl -20(%ebp)
                jmp et_for_j

        et_cont_i:
            incl -16(%ebp)
            jmp et_for_i


        et_exit_matrix_mult:
            ;/ dezalocarea spatiului local
            addl $24, %esp

            ;/ salveaza registrii callee-saved folositi in procedura
            popl %edi
            popl %esi
            popl %ebx

            popl %ebp
            ret
  
  
  matrix_copy:        	;/ matrix_copy(sourceMatrix, destinationMatrix, n)
        pushl %ebp
        movl %esp, %ebp

        ;/ Argumentele procedurii
        ;/ 8(%ebp)      -> sourceMatrix
        ;/ 12(%ebp)     -> destinationMatrix
        ;/ 16(%ebp)     -> n

        ;/ salveaza registrii callee-saved folositi in procedura
        pushl %ebx
        pushl %esi
        pushl %edi

        ;/ spatiu auxiliar pt variabilele locale
        subl $8, %esp
        movl $0, -16(%ebp)       ;/ i = 0
        movl $0, -20(%ebp)       ;/ j = 0

        movl $0, -16(%ebp)								;/ i = 0
        et_for_i_matrix_copy:
            movl 16(%ebp), %ebx							;/ ebx = n
            movl -16(%ebp), %ecx						;/ ecx = i
            cmp %ebx, %ecx
            je et_exit_matrix_copy						;/ if (i == n) -> exit

            movl $0, -20(%ebp)							;/ j = 0
            et_for_j_matrix_copy:
                movl 16(%ebp), %ebx						;/ ebx = n
                movl -20(%ebp), %ecx					;/ ecx = j
                cmp %ebx, %ecx			
                je et_cont_i_matrix_copy				;/ if (j == n) -> back to et_for_i_matrix_copy

                ;/ destinationMatrix[i][j] = sourceMatrix[i][j]				
                movl -16(%ebp), %eax                    ;/ eax = i
                movl $0, %edx
                mull 16(%ebp)                           ;/ eax = i * n
                addl -20(%ebp), %eax                    ;/ eax = i * n + j
				
                movl 8(%ebp), %esi                     	;/ esi = sourceMatrix
				movl 12(%ebp), %edi                     ;/ edi = destinationMatrix
                
				movl (%esi, %eax, 4), %ebx				;/ ebx = sourceMatrix[i][j]
				movl %ebx, (%edi, %eax, 4)              ;/ destinationMatrix[i][j] = sourceMatrix[i][j]
                
                incl -20(%ebp)                          ;/ j++
                jmp et_for_j_matrix_copy

        et_cont_i_matrix_copy:
            incl -16(%ebp)                               ;/ i++
            jmp et_for_i_matrix_copy


        et_exit_matrix_copy:
            ;/ dezalocarea spatiului local
            addl $8, %esp

            ;/ salveaza registrii callee-saved folositi in procedura
            popl %edi
            popl %esi
            popl %ebx

            popl %ebp
            ret


.global main
main:
    ;/ citeste: cerinta
    pushl $cerinta
    pushl $formatScanf
    call scanf
    addl $8, %esp

    ;/ citeste: n
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp

    ;/ citeste legaturi[nod]
    movl $0, nod
    et_for_legaturi:
        movl nod, %ecx
        cmp n, %ecx
        je et_citeste_noduri         ;/ mergi la urmatoarea eticheta

        pushl $nrLegaturi
        pushl $formatScanf
        call scanf
        addl $8, %esp

        ;/ legaturi[nod] = nrLegaturi
        lea legaturi, %edi
        movl nrLegaturi, %ebx
        movl nod, %ecx
        movl %ebx, (%edi, %ecx, 4)

        incl nod
        jmp et_for_legaturi


et_citeste_noduri:
    movl $0, nod
    et_for_noduri:
        movl nod, %ecx
        cmp n, %ecx
        je et_alege_cerinta              ;/ mergi la urmatoarea eticheta

        movl $0, iterator
        et_for_legaturi_noduri:
            lea legaturi, %edi
            movl nod, %ecx
            movl (%edi, %ecx, 4), %ebx
            
            movl iterator, %ecx
            cmp %ebx, %ecx
            je cont_et_for_noduri

            ;/ citeste nextNod
            pushl $nextNod
            pushl $formatScanf
            call scanf
            addl $8, %esp

            ;/ matrix[nod][nextNod] = 1
            movl nod, %eax
            movl $0, %edx
            mull n
            addl nextNod, %eax

            lea m1, %edi
            movl $1, (%edi, %eax, 4)

            incl iterator
            jmp et_for_legaturi_noduri

    cont_et_for_noduri:
        incl nod
        jmp et_for_noduri


et_alege_cerinta:
    movl $1, %eax
    cmp cerinta, %eax
    je et_cerinta1          ;/ mergi la cerinta 1
    jmp et_cerinta2         ;/ mergi la cerinta 2


et_cerinta1:            ;/ afiseaza raspuns pentru cerinta 1
    movl $0, nod
    for_afiseaza_matrix_linii:
        movl nod, %ecx
        cmp %ecx, n
        je et_exit                              ;/ mergi la urmatoarea eticheta

        movl $0, nextNod
        for_afiseaza_matrix_coloane:
            movl nextNod, %ecx
            cmp %ecx, n
            je et_cont_for_afiseaza_matrix_linii

            ;/ afisez matrix[nod][nextNod]
            ;/ index = nod * n + nextNod
            movl nod, %eax
            movl $0, %edx
            mull n
            addl nextNod, %eax

            lea m1, %esi
            movl (%esi, %eax, 4), %ebx

            pushl %ebx
            pushl $formatPrintf
            call printf
            addl $8, %esp

            incl nextNod
            jmp for_afiseaza_matrix_coloane

    et_cont_for_afiseaza_matrix_linii:
        pushl $newLine
        call printf
        addl $4, %esp

        pushl $0
        call fflush
        addl $4, %esp

        incl nod
        jmp for_afiseaza_matrix_linii


et_cerinta2:        ;/ citeste drumul cautat
    ;/ citeste: k
    pushl $k
    pushl $formatScanf
    call scanf
    addl $8, %esp

    ;/ citeste: start
    pushl $start
    pushl $formatScanf
    call scanf
    addl $8, %esp

    ;/ citeste: end
    pushl $end
    pushl $formatScanf
    call scanf
    addl $8, %esp

    ;/ m2[][] = IDENTITATE
    movl $0, iterator
    et_for_identitate:
        movl iterator, %ecx
        cmp n, %ecx
        je et_inmultire_matrix

        movl iterator, %eax                 ;/ eax = iterator
        movl $0, %edx
        mull n                              ;/ eax = i * n
        addl iterator, %eax                 ;/ eax = i * n + i
        
        lea m2, %edi
        movl $1, (%edi, %eax, 4)            ;/ m2[i][i] = 1

        incl iterator
        jmp et_for_identitate 


et_inmultire_matrix:
    movl $0, iterator 
    et_for_imultire_matrix:
        movl iterator, %ecx
        cmp k, %ecx
        je et_afisare_cerinta2      ;/ mergi la urmatoarea eticheta

        ;/ mres[][] = m1[][] * m2[][]
        pushl n
        pushl $mres
        pushl $m2
        pushl $m1
        call matrix_mult            ;/ matrix_mult($m1, $m2, $mres, n)
        addl $16, %esp

        ;/ m2[][] = mres[][]
        pushl n
        pushl $m2
        pushl $mres
        call matrix_copy            ;/ matrix_copy($sourceMatrix, $destinationMatrix, n)
        addl $12, %esp

        incl iterator
        jmp et_for_imultire_matrix
            

et_afisare_cerinta2:
    ;/ afiseaza m2[i][j]
    movl start, %eax              ;/ eax = start
    movl $0, %edx
    mull n                        ;/ eax = start * n
    addl end, %eax                ;/ eax = start * n + end

    lea m2, %esi                  ;/ m2[][]
    movl (%esi, %eax, 4), %ebx    ;/ ebx = m2[i][j]

    pushl %ebx
    pushl $formatPrintf2
    call printf
    addl $8, %esp

    pushl $0
    call fflush
    addl $4, %esp
    

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

