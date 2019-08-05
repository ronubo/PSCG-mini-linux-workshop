# Makefile for quick and easy handling of kernel modules (and respective userspace programs if needed) 
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
	KROOT ?= ${KERNEL_OUT}
	RAMDISK ?= ${RAMDISK_WIP}
	KERNEL_VERSION ?= ${KV}

else ifeq ($(TARGET),arm)
	KROOT ?= /home/ron/kernel/arm-out
	RAMDISK ?= /home/ron/labs/mini_linux/arm_ramdisk/
	KERNEL_VERSION ?= 5.2.6
else ifeq ($(TARGET),local)
  KROOT ?= /lib/modules/$(shell uname -r)/build

else
  $(error TARGET must be either 'local', 'qemu' or 'arm')
endif



# list of kernel modules to build, separeted by spaces
obj-m +=  hello.o





default: modules
modules:
	$(info You are building modules for TARGET=$(TARGET) )
	@$(MAKE) -C $(KROOT) M=$(shell pwd) modules
modules_install:
	$(info You are installing modules for TARGET=$(TARGET) )
ifeq ($(TARGET),qemu)
	@$(MAKE) -C $(KROOT) M=$(shell pwd) INSTALL_MOD_PATH=$(RAMDISK) modules_install 
else ifeq ($(TARGET),arm)
	@$(MAKE) -C $(KROOT) M=$(shell pwd) INSTALL_MOD_PATH=$(RAMDISK) modules_install 
else	
	@$(MAKE) -C $(KROOT) M=$(shell pwd) modules_install 
endif 
kernel_clean:
	$(info You are cleaning up modules for TARGET=$(TARGET) )
	@$(MAKE) -C $(KROOT) M=$(shell pwd) clean

.PHONY: clean
clean: kernel_clean
	rm -rf Module.symvers modules.order

	

# You will clean up whatever is "installed" yourself. We aim for education and simplicity
