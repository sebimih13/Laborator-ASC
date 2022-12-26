#include <sys/mman.h>    /* Definition of MAP_* and PROT_* constants */
#include <sys/syscall.h> /* Definition of SYS_* constants */
#include <unistd.h>

#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("merge\n");

    char* addr;
    syscall(SYS_mmap, addr, 62500, PROT_READ & PROT_WRITE, MAP_ANONYMOUS & MAP_PRIVATE, -1, 0);

    if (addr == MAP_FAILED)
        printf("error addr");
    else
        printf("addr : %s", addr);
}

