#!/bin/bash
kvm  -kernel out_qemu_x86-64/arch/x86_64/boot/bzImage -initrd busybox/bbinitramfs-x86_64.cpio.gz  -nographic -append "console=ttyS0"
