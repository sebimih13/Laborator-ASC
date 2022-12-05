
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
    newLine: .asciz "\n"

    cerinta: .space 4
    n: .space 4

    legaturi: .space 500            ;/ 500/4 = 125 de noduri
    nrLegaturi: .space 4
    
    nod: .space 4
    nextNod: .space 4

    iterator: .space 4

    matrix: .space 62500           ;/ matrix[125][125]

.text

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
        je et_afiseaza_legaturi         ;/ TODO : DEBUG

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
        je et_citeste_noduri                      ;/ TODO : DEBUG -> mergi la urmatorul debug

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
        ;/ TODO : delete -> doar pt debug
            movl $4, %eax
            movl $1, %ebx
            movl $newLine, %ecx
            movl $2, %edx
            int $0x80

            movl $4, %eax
            movl $1, %ebx
            movl $newLine, %ecx
            movl $2, %edx
            int $0x80
        ;/ TODO : delete -> doar pt debug

    movl $0, nod
    et_for_noduri:
        movl nod, %ecx
        cmp n, %ecx
        je et_afiseaza_matrix                  ;/ TODO : mergi la urmatoarea eticheta

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

            lea matrix, %edi
            movl $1, (%edi, %eax, 4)

            incl iterator
            jmp et_for_legaturi_noduri

    cont_et_for_noduri:
        incl nod
        jmp et_for_noduri


et_afiseaza_matrix:
    movl $0, nod

    for_afiseaza_matrix_linii:
        movl nod, %ecx
        cmp %ecx, n
        je et_exit                              ;/ TODO : mergi la urmatoarea eticheta

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

            lea matrix, %edi
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

            
et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

