Helper scripts and source files for the workshop given at  Open Source Summit/Embedded Linux Conference 2019 San Diego 
 "Understanding, Building and Researching Minimal (and not so minimal) Linux Systems" by Ron Munitz <ron@thepscg.com> (PSCG Holdings LTD / The PSCG)

The tasks are deliberately divided into very simple scripts, so that 
the student will easily "know what does what" by the script name, without 
needing any special documentation, and without having to really look at the presentations

Before doing anything (in each terminal)
$ . envsetup.sh first



Important notes about building busybox:
1. Default architecture is x86_64
2. It is possible to build busybox dynamically, and install the relevant libraries. It makes things more complex, so we build it statically.
3. Building for other architectures: there is a well known conflict between the packages 'gcc-multilib' and the Ubuntu/Debian repository arm cross-tools. 
   They DO NOT coesist, so you either have 'gcc-multilib' XOR one or all of  'gcc-7-aarch64-linux-gnu' 'gcc-7-arm-linux-gnueabi' 'gcc-aarch64-linux-gnu' 'gcc-arm-linux-gnueabi'
4. To build for ARM: setup your variables as if it were before a kernel build. It works the same.
5. For 32bit intel - ARCH doesn't matter. To build you must install 'gcc-multilib' (or your build will very fast fail for missing headers) and set LDFLAGS=-m32 CPPFLAGS=-m32 
   So for example change the corresponding lines on the build to:
   $ CPPFLAGS=-m32 LDFLAGS=-m32 make -j16 CONFIG_PREFIX=../wip_ramdisk install


