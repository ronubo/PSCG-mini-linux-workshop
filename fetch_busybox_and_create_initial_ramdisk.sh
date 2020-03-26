#!/bin/bash

if [ ! "$1" == "dontbuild" ] ; then
wget https://busybox.net/downloads/${BUSYBOX_VERSION}.tar.bz2
tar xf ${BUSYBOX_VERSION}.tar.bz2

# Build for x86_64 target (or for whatever your host ARCH is)
cd ${BUSYBOX_VERSION}/
make defconfig
sed -i 's:# CONFIG_STATIC is not set:CONFIG_STATIC=y:' .config
if [ "${ARCH}" == "i386" ] ; then
CPPFLAGS=-m32 LDFLAGS=-m32 make -j16 CONFIG_PREFIX=../wip_ramdisk install
else
make -j16 CONFIG_PREFIX=../wip_ramdisk install
fi
cd ..


else # Just populate the ramdisk, don't fetch/unpack/build
make -C $BUSYBOX_VERSION CONFIG_PREFIX=../wip_ramdisk install
fi


# Create an initial directory structure 
mkdir -p wip_ramdisk/{lib,proc,sys,dev,mnt,xbin}

# Populate init script
cat > wip_ramdisk/init << EOF
#!/bin/sh

# If ramdisk doesn't come with premade empty proc sys dev folders - you can mkdir them here.

mount -t proc none /proc
mount -t sysfs none /sys
mount -t debugfs none /sys/kernel/debug

echo -e "\n\033[0;32m The PSCG mini-linux\033[0m booted in \$(cut -d' ' -f1 /proc/uptime) seconds\n"

# Enable sysfs / dev initial enumeration
mdev -s
# Enable hotplugging - without this, the kernel would expect /sbin/hotplug. For this you need CONFIG_UEVENT_HELPER=y in the kernel, and you can live without it if CONFIG_DEVTMPFS=y and CONFIG_DEVTMPFS_MOUNT=y (and of course, CONFIG_SYSFS=y)
# This line is used for other ramdisk generations with differnet illustration purposes, so don't worry if /proc/sys/kernel/hotplug doesn't exist, but /dev/mdev gets populated.
echo /sbin/mdev >/proc/sys/kernel/hotplug

# allow doing "bashrc" style stuff like aliases etc.
# This can also be done by populating /etc/profile , however I am doing it in the following way for the sake of the example: 
# ronenv will be a file to be populated externally (if, nothing bad will happen if it's empty). 
# You can also just populate it yourself from your running shell e.g. # ' echo "alias ll='ls -l' > ronenv , then execute 'sh' and you will see that you will the alias in the other shell
export ENV=ronenv 

# get rid of annoying job control message - it is not really necessary.
# also this is tailored for our exact scenario where we use the console as ttyS0 - be careful if you copy it to another platform, or in a graphical mode!
# For a more elegant solution, use cttyhack; https://git.busybox.net/busybox/plain/shell/cttyhack.c?id=dcaed97
exec setsid sh -c 'exec sh </dev/ttyS0 >/dev/ttyS0 2>&1'

# Whatever is here will not run if you do not comment the previous line, because exec replaces the image.
# Extra notes for demonstration: Comment the above (setsid line) if you run qemu with graphical mode and you want to use the console. Otherwise, you will think the console gets stuck - while it doesn't.

exec /bin/sh
EOF

chmod +x wip_ramdisk/init # Omit from full courses - explain briefly in short talks
# Repackage the ramdisk
exec ./repack_ramdisk.sh
