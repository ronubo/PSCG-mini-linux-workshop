#!/bin/bash
kvm  -kernel out_qemu_x86/arch/x86/boot/bzImage  -initrd busybox/bbinitramfs-x86.cpio.gz -nographic -append "console=ttyS0"

