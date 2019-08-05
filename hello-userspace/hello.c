/*
 * Simple "hello world"  application for userspace illustration
 * the purpose is to illustrate dependencies of libraries, and what happens if we build with the wrong toolchains
 * assuming a 64bit x86 target (or 32bit one, built with -m32 (requires multilib on the host)) built STATICALLY - you are good to go
 * this is what we will illustrate in the San Diego conference as time is limited.
 *
 */

#include <stdio.h>
__attribute__((constructor))
void ihavenoideawhatimdoing ()
{
	printf("CATS: %s\n","\x1b[42mHOW ARE YOU GENTLEMEN !!\x1b[0m");
}

__attribute__((destructor))
void iamanevilgenious() 
{
	printf("CATS: %s\n","\x1b[41mALL YOUR BASE ARE BELONG TO US.\x1b[0m");
}

int main()
{
	printf("Hello World\n");
	return 0;
}
