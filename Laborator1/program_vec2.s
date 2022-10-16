.data
    n: .long 5
    v: .long 10, 20, 30, 40, 50
.text
.globl main
main:
    lea v, %edi
    mov n, %ecx

etloop:                             ;// C++ : do { ... } while (--ecx != 0);
    mov n, %eax
    sub %ecx, %eax
    movl (%edi, %eax, 4), %edx
    loop etloop

etexit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

;// 3. Mai trebuie pus inca un break la etexit

