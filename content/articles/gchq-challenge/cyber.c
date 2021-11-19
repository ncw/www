/*
Run the cyber challenge code in a controlled environment so we can
dump the memory and stack afterwards.

Using the debugger probably would have been easier but this is the way
I did it and it has the advantage it would definitely work for self
modifying code.

Nick Craig-Wood <nick@craig-wood.com>
http://www.craig-wood.com/nick/
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#define BIN "cyber.bin.padded"

int call(void *code, void *stack)
{
        int result = 5;
	__asm__
	(
                "mov %%ebx, %%esp;"
		"call %%eax;"
		: "=a" (result)
		: "a" (code), "b" (stack)
	);
	return result;
}

int main(void)
{

    int fd = open(BIN, O_RDWR);
    if (fd < 0) {
        perror("Couldn't open " BIN);
        return 1;
    }
    
    void *block = mmap(NULL, 4096, PROT_EXEC|PROT_READ|PROT_WRITE, MAP_SHARED|MAP_32BIT, fd, 0);
    if (block == MAP_FAILED) {
        perror("mmap() failed");
        return 1;
    }
    printf("mmapped file at %p\n", block);

    //void (*f)(void) = (void(*)(void))block;
    printf("Running f\n");

    //f();
    //*(int *)(0xA0+(char *)block) = 0x42424242;
    //*(int *)(0xA4+(char *)block) = 16;
    call(block, ((char *)block)+1024);
    printf("Ran f\n");
    return 0;
}
