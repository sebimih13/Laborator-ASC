.data
    x: .long 2
    y: .long 1
    z: .long 3
    e: .space 4

.text
.global main

main:
    movl y, %eax
    addl z, %eax
    pushl %eax      
    ;/ %esp: (y + z)
    
    movl x, %eax
    addl z, %eax
    pushl %eax
    ;/ %esp: (x + z), (y + z)

    movl x, %eax
    subl y, %eax
    pushl %eax
    ;/ %esp: (x - y), (x + z), (y + z)

    movl x, %eax
    addl y, %eax
    pushl %eax
    ;/ %esp: (x + y), (x - y), (x + z), (y + z)

    popl %eax
    popl %ebx
    mull %ebx

    pushl %eax
    ;/ %esp: (x + y) * (x - y), (x + z), (y + z)

    popl %eax
    popl %ebx
    mull %ebx

    pushl %eax
    ;/ %esp: (x + y) * (x - y) * (x + z), (y + z)

    popl %eax
    popl %ebx
    divl %ebx

    pushl %eax
    ;/ %esp: ((x + y) * (x - y) * (x + z)) / (y + z)
    ;/ %esp: ((2 + 1) * (2 - 1) * (2 + 3)) / (1 + 3) = (3 * 1 * 5) / 4 = 15 / 4 = 3 

    popl e

exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80



