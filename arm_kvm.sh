#!/bin/bash
kvm  -kernel qemu-arm/arch/arm/boot/zImage  -initrd initramfs-busybox.cpio.gz  -nographic -append "console=ttyS0"

