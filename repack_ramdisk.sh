#!/bin/sh
cd wip_ramdisk
find . | cpio -H newc -o > ../initramfs.cpio
cd ..
cat initramfs.cpio | gzip > initramfs.gz
cd ..

