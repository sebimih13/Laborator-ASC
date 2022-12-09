
;/ 1. argumentele trebuie incarcate pe stiva pentru apel, conform standardului x86, de la dreapta la stanga

;/ 2. registrii %eax, %ecx si %edx sunt singurii care NU trebuie restaurati in urma apelului, 
;/    fiind si registrii de returnare; toti ceilalti registri trebuie restaurati!

;/ 3. in cadrul de apel utilizam registrul %ebp conform conventiei x86, prezentata la laborator si in suportul 0x01 de laborator

;/ 4. in cadrul de apel NU se utilizeaza variabile din sectiunea .data! 
;/    Toate variabilele au scop local, deci se vor afla pe stiva, si vor fi accesate prin intermediul lui %ebp!

;/ CONTINE CERINTELE 1 + 2

.data
    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld "     ;/ TODO : inca un printf fara spatiu
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
    ;/ TODO : DELETE
    print_nr:               ;/ print_nr(nr)
        pushl %ebp
        movl %esp, %ebp

        pushl 8(%ebp)
        pushl $formatPrintf
        call printf
        popl %ebx
        popl %ebx

        pushl $0
        call fflush
        popl %ebx

        popl %ebp
        ret

    
    ;/ TODO : DELETE
    print_newLine:      ;/ print_newLine()
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80

        ret


    matrix_mult:        ;/ matrix_mult(m1, m2, mres, n)
        pushl %ebp
        movl %esp, %ebp

        ;/ 8(%ebp)      -> m1
        ;/ 12(%ebp)     -> m2
        ;/ 16(%ebp)     -> mres
        ;/ 20(%ebp)     -> n

        ;/ spatiu auxiliar pt variabilele locale:
        subl $24, %esp
        movl $0, -4(%ebp)       ;/ i
        movl $0, -8(%ebp)       ;/ j
        movl $0, -12(%ebp)      ;/ k
        movl $0, -16(%ebp)      ;/ m1
        movl $0, -20(%ebp)      ;/ m2
        movl $0, -24(%ebp)      ;/ inmultire

        movl $0, -4(%ebp)								;/ i = 0
        et_for_i:
            movl 20(%ebp), %ebx							;/ ebx = n
            movl -4(%ebp), %ecx							;/ ecx = i
            cmp %ebx, %ecx
            je et_exit_matrix_mult						;/ if (i == n) -> exit

            movl $0, -8(%ebp)							;/ j = 0
            et_for_j:
                movl 20(%ebp), %ebx						;/ ebx = n
                movl -8(%ebp), %ecx						;/ ecx = j
                cmp %ebx, %ecx			
                je et_cont_i							;/ if (j == n) -> back to et_for_i

                ;/ mres[i][j] = 0
                movl -4(%ebp), %eax                     ;/ eax = i
                movl $0, %edx
                mull 20(%ebp)                           ;/ eax = i * n
                addl -8(%ebp), %eax                     ;/ eax = i * n + j

                movl 16(%ebp), %edi                     ;/ mres
                movl $0, (%edi, %eax, 4)                ;/ mres[i][j] = 0

                movl $0, -12(%ebp)						;/ k = 0
                et_for_k:
                    movl 20(%ebp), %ebx					;/ ebx = n
                    movl -12(%ebp), %ecx				;/ ecx = k
                    cmp %ebx, %ecx
                    je et_cont_j						;/ if (k == n) -> back to et_for_j
                        
                    ;/ mat[i][j] += mat[i][k] * mat[k][j]
                    
                    ;/ m1 = m1[i][k]
                    movl -4(%ebp), %eax         		;/ eax = i
                    movl $0, %edx               
                    mull 20(%ebp)               		;/ eax = i * n
                    addl -12(%ebp), %eax        		;/ eax = i * n + k

                    movl 8(%ebp), %esi          		;/ m1[][]
                    movl (%esi, %eax, 4), %ebx          ;/ ebx = m1[i][k]
                    movl %ebx, -16(%ebp)  	            ;/ m1 = m1[i][k] 

                    ;/ m2 = m2[k][j]
                    movl -12(%ebp), %eax        		;/ eax = k
                    movl $0, %edx
                    mull 20(%ebp)               		;/ eax = k * n
                    addl -8(%ebp), %eax         		;/ eax = k * n + j

                    movl 12(%ebp), %esi         		;/ m2[][]
                    movl (%esi, %eax, 4), %ebx          ;/ ebx = m2[k][j]
                    movl %ebx, -20(%ebp)  	            ;/ m2 = m2[k][j]

                    ;/ eax = m1 * m2
                    movl -16(%ebp), %eax                ;/ eax = m1
                    movl $0, %edx
                    mull -20(%ebp)                      ;/ eax = m1 * m2
                    movl %eax, -24(%ebp)                ;/ inmultire = m1 * m2

                    ;/ mres[i][j] += inmultire
                    movl -4(%ebp), %eax                 ;/ eax = i
                    movl $0, %edx
                    mull 20(%ebp)                       ;/ eax = i * n
                    addl -8(%ebp), %eax                 ;/ eax = i * n + j

                    movl 16(%ebp), %edi                 ;/ mres[]][]
                    movl -24(%ebp), %ebx                ;/ ebx = inmultire
                    addl %ebx, (%edi, %eax, 4)

                et_cont_k:
                    incl -12(%ebp)
                    jmp et_for_k

            et_cont_j:
                incl -8(%ebp)
                jmp et_for_j

        et_cont_i:
            incl -4(%ebp)
            jmp et_for_i


        et_exit_matrix_mult:
            ;/ dezalocarea spatiului local
            addl $24, %esp

            popl %ebp
            ret

    
      
  
  
  matrix_copy:        	;/ matrix_copy(sourceMatrix, destinationMatrix, n)
        pushl %ebp
        movl %esp, %ebp

        ;/ 8(%ebp)      -> sourceMatrix
        ;/ 12(%ebp)     -> destinationMatrix
        ;/ 16(%ebp)     -> n

        ;/ spatiu auxiliar pt variabilele locale
        subl $8, %esp
        movl $0, -4(%ebp)       ;/ i = 0
        movl $0, -8(%ebp)       ;/ j = 0

        movl $0, -4(%ebp)								;/ i = 0
        et_for_i_matrix_copy:
            movl 16(%ebp), %ebx							;/ ebx = n
            movl -4(%ebp), %ecx							;/ ecx = i
            cmp %ebx, %ecx
            je et_exit_matrix_copy						;/ if (i == n) -> exit

            movl $0, -8(%ebp)							;/ j = 0
            et_for_j_matrix_copy:
                movl 16(%ebp), %ebx						;/ ebx = n
                movl -8(%ebp), %ecx						;/ ecx = j
                cmp %ebx, %ecx			
                je et_cont_i_matrix_copy				;/ if (j == n) -> back to et_for_i_matrix_copy

                ;/ destinationMatrix[i][j] = sourceMatrix[i][j]				
                movl -4(%ebp), %eax                     ;/ eax = i
                movl $0, %edx
                mull 16(%ebp)                           ;/ eax = i * n
                addl -8(%ebp), %eax                     ;/ eax = i * n + j
				
                movl 8(%ebp), %esi                     	;/ esi = sourceMatrix
				movl 12(%ebp), %edi                     ;/ edi = destinationMatrix
                
				movl (%esi, %eax, 4), %ebx				;/ ebx = sourceMatrix[i][j]
				movl %ebx, (%edi, %eax, 4)              ;/ destinationMatrix[i][j] = sourceMatrix[i][j]
                
                incl -8(%ebp)                           ;/ j++
                jmp et_for_j_matrix_copy

        et_cont_i_matrix_copy:
            incl -4(%ebp)                               ;/ i++
            jmp et_for_i_matrix_copy


        et_exit_matrix_copy:
            ;/ dezalocarea spatiului local
            addl $8, %esp

            popl %ebp
            ret


    matrix_afisare:     ;/ matrix_afisare(mat)
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %edi      ;/ adresa de memorie pt mat

        et_afiseaza_matrix:
            movl $0, nod

            for_afiseaza_matrix_linii:
                movl nod, %ecx
                cmp %ecx, n
                je et_exit_afiseaza_matrix                              ;/ TODO : mergi la urmatoarea eticheta

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

                    movl (%edi, %eax, 4), %ebx

                    pushl %ebx
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx

                    incl nextNod
                    jmp for_afiseaza_matrix_coloane

            et_cont_for_afiseaza_matrix_linii:
                movl $4, %eax
                movl $1, %ebx
                movl $newLine, %ecx
                movl $2, %edx
                int $0x80

                incl nod
                jmp for_afiseaza_matrix_linii

        et_exit_afiseaza_matrix:
            popl %ebp
            ret


.global main
main:
    ;/ citeste: cerinta
    pushl $cerinta
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste: n
    pushl $n
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste legaturi[nod]
    movl $0, nod
    et_for_legaturi:
        movl nod, %ecx
        cmp n, %ecx
        je et_afiseaza_legaturi         ;/ TODO : mergi la urmatoarea eticheta

        pushl $nrLegaturi
        pushl $formatScanf
        call scanf
        popl %ebx
        popl %ebx

        ;/ legaturi[nod] = nrLegaturi
        lea legaturi, %edi
        movl nrLegaturi, %ebx
        movl nod, %ecx
        movl %ebx, (%edi, %ecx, 4)

        incl nod
        jmp et_for_legaturi


et_afiseaza_legaturi:
    movl $0, nod

    et_for_afiseaza_legaturi:
        movl nod, %ecx
        cmp n, %ecx
        je et_citeste_noduri                      ;/ TODO : TODO : mergi la urmatoarea eticheta

        ;/ afiseaza legaturi[nod]
        lea legaturi, %edi
        movl nod, %ecx
        movl (%edi, %ecx, 4), %ebx

        pushl %ebx
        pushl $formatPrintf
        call printf
        popl %ebx
        popl %ebx

        pushl $0
        call fflush
        popl %ebx

        incl nod
        jmp et_for_afiseaza_legaturi


et_citeste_noduri:
    movl $0, nod
    et_for_noduri:
        movl nod, %ecx
        cmp n, %ecx
        je et_citeste_drum                  ;/ TODO : mergi la urmatoarea eticheta

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
            popl %ebx
            popl %ebx

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


et_citeste_drum:
    ;/ citeste: k
    pushl $k
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste: start
    pushl $start
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste: end
    pushl $end
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx


et_imultire_matrix:
    ;/ m2[][] = m1[]
    pushl n
    pushl $m2
    pushl $m1
    call matrix_copy                ;/ matrix_copy($sourceMatrix, $destinationMatrix, n)
    popl %ebx
    popl %ebx
    popl %ebx


    movl $1, iterator
    et_for_imultire_matrix:
        movl iterator, %ecx
        cmp k, %ecx
        je et_afisare_cerinta2      ;/ TODO : mergi la urmatoarea eticheta

        ;/ mres[][] = m1[][] * m2[][]
        pushl n
        pushl $mres
        pushl $m2
        pushl $m1
        call matrix_mult            ;/ matrix_mult($m1, $m2, $mres, n)
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx

        ;/ m2[][] = mres[][]
        pushl n
        pushl $m2
        pushl $mres
        call matrix_copy            ;/ matrix_copy($sourceMatrix, $destinationMatrix, n)
        popl %ebx
        popl %ebx
        popl %ebx

        incl iterator
        jmp et_for_imultire_matrix
            

et_afisare_cerinta2:

    ;/ TODO : DELETE
    call print_newLine
    call print_newLine

    ;/ afiseaza m2[i][j]
    movl start, %eax              ;/ eax = start
    movl $0, %edx
    mull n                        ;/ eax = start * n
    addl end, %eax                ;/ eax = start * n + end

    lea m2, %esi                  ;/ m2[][]
    movl (%esi, %eax, 4), %ebx    ;/ ebx = m2[i][j]

    pushl %ebx
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    pushl $0
    call fflush
    popl %ebx
    

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

