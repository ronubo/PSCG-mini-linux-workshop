# Makefile for quick and easy handling of userspace programs if needed
# for The PSCG's training. The objectives are to make it easy for you to follow even if you do not understand
# GNU makefile syntax very well. It is not perfect - but it is perfect for what you need.
#
# The following environment variables are critical, and not setting them will trigger an error
#        TARGET=qemu will build for a *PREDEFINED* (in makefile) ramdisk 
#        TARGET=arm will build for a  *PREDEFINED* (in makefile) ramdisk 
#        TARGET=local will build for your own 
#
# If you have other things that require the "TARGET" name - modify the Makefile (as I said earlier - the objective is to be simple)
#
# Ron Munitz 2019
# chopped and modified for Open Source Summit/Embedded Linux Conference 2019 San Diego



# Important note for Makefile newcomers - conditional directives can potentially come after SPACE not TABS 
# (while in make targets commands must be tabs and not space)
# we don't need any spaces really, we added them just for clarity
ifeq ($(TARGET),)
  $(error You must provide a TARGET variable (and set it to either 'local' or 'qemu', or 'arm'))

else ifeq ($(TARGET),qemu)
	RAMDISK ?= ${RAMDISK_WIP}
else ifeq ($(TARGET),arm)
	RAMDISK ?= /home/ron/labs/mini_linux/arm_ramdisk/
else ifeq ($(TARGET),local)
else
  $(error TARGET must be either 'local', 'qemu' or 'arm')
endif


default: userspace_install
userspace_install: hello.c
	gcc -g hello.c -o hello
	cp hello ${RAMDISK_WIP}/xbin
userspace_static_install: hello.c
	gcc -g hello.c -o hello_static -static
	cp hello_static ${RAMDISK_WIP}/xbin
userspace_all: userspace_install userspace_static_install
	
# You will clean up whatever is "installed" yourself. We aim for education and simplicity
