#!/bin/bash
# Don't use qemu-system-x86_64 - wrong protocols with GDB on this case
qemu-system-i386  -kernel ${KERNEL_OUT}/arch/x86/boot/bzImage -initrd ${RAMDISK_PACKED} -append "console=ttyS0 earlycon=ttyS0 earlyprintk   ignore_loglevel nokaslr" -enable-kvm -serial stdio -S -s
