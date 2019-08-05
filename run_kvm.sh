#!/bin/bash
qemu-system-x86_64     -kernel ${KERNEL_OUT}/arch/x86/boot/bzImage -initrd ${RAMDISK_PACKED} -nographic -append "console=ttyS0 kgdboc.kgdboc=ttyS0 " -enable-kvm
