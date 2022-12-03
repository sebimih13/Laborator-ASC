.data
    matrix: .space 1600
    
    n: .space 4
    nrMuchii: .space 4

    columnIndex: .space 4
    lineIndex: .space 4

    index: .space 4
    left: .space 4
    right: .space 4

    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld"
    newLine: .asciz "\n"

.text


.global main
main:
    ;/ citeste n
    pushl $n
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste nrMuchii
    pushl $nrMuchii
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx


    ;/ for (long index = 0; index < nrMuchii; index++)
    ;/ {
    ;/      scanf("%ld", %left);
    ;/      scanf("%ld", %right);
    ;/      matrix[left][right] = 1;
    ;/      matrix[right][left] = 1;
    ;/ }

    movl $0, index
et_for:
    movl index, %ecx
    cmp %ecx, nrMuchii
    je et_afis_matr
    
    ;/ citeste left
    pushl $left
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ citeste right
    pushl $right
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    ;/ matrix[left][right] = 1;
    ;/ index = left * n + right
    movl left, %eax
    movl $0, %edx
    mull n
    addl right, %eax

    lea matrix, %edi
    movl $1, (%edi, %eax, 4)

    ;/ matrix[right][left] = 1;
    ;/ index = right * n + left
    movl right, %eax
    movl $0, %edx
    mull n
    addl left, %eax

    lea matrix, %edi
    movl $1, (%edi, %eax, 4)

    incl index
    jmp et_for

et_afis_matr:
    movl $0, lineIndex

    for_lines:
        movl lineIndex, %ecx
        cmp %ecx, n
        je et_exit

        movl $0, columnIndex
        for_columns:
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont

            ;/ afisez matrix[lineIndex][columnIndex]
            ;/ index = lineIndex * n + columnIndex
            movl lineIndex, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax

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

            incl columnIndex
            jmp for_columns

        cont:
            movl $4, %eax
            movl $1, %ebx
            movl $newLine, %ecx
            movl $2, %edx
            int $0x80

            incl lineIndex
            jmp for_lines

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

