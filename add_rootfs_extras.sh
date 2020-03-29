#!/bin/bash
#
#
# Add some extras to the ramdisk. This could of course be done from the initial ramdisk creation script.
# 
cp -a rootfs-additions/* wip_ramdisk || exit 1

# Repackage the ramdisk
echo "Will now repack the ramdisk"
exec ./repack_ramdisk.sh
