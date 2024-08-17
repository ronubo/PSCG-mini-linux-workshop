#!/bin/bash

# Simple custom root file system using only busybox shell. This is meant mostly for cross compiling, but you can set it to build for your native target
# For cross compiling, you must provide the following environment variables: ARCH, CROSS_COMPILE
#
: ${BUSYBOX_VERSION=busybox-1.36.0}
: ${DEFCONFIG=defconfig}
: ${JOBS=$(nproc)}

# We will just warn
[ -z "$CROSS_COMPILE" ] && { echo "Building using native toolchains. If you didn't mean that, please specify your CROSS_COMPILE= variable" ; }
[ -z "$ARCH" ] && { echo "Building for your native architecture $(arch). If you didn't mean that, please specify your ARCH= variable" ; }

fetch=true
untar=true
config=true
build=true

for arg in $@ ; do
	case $arg in
		dontfetch)	fetch=false	;;
		dontuntar)	untar=false	;;
		dontconfig) 	config=false 	;;
		dontbuild) 	build=false 	;;
	esac
done

if [ $fetch = true ] ; then
	wget https://busybox.net/downloads/${BUSYBOX_VERSION}.tar.bz2
	tar xf ${BUSYBOX_VERSION}.tar.bz2
elif [ $untar = true ] ; then
	tar xf ${BUSYBOX_VERSION}.tar.bz2
fi

if [ $config = true ] ; then
	# Build for x86_64 target (or for whatever your host ARCH is)
	cd ${BUSYBOX_VERSION}/
	make $DEFCONFIG
	sed -i 's:# CONFIG_STATIC is not set:CONFIG_STATIC=y:' .config
	cd ..
fi

if [ $build = true ] ; then
	# Note that this requires multilib (which will force you remove other distro installed cross-compilers), and i386 packages. 
	# busybox 1.36.1 wants libcrypt which has no trivial i386 package in recent Ubuntu distros,
	# so this is not recommended. better install an i386/i586/i686/... cross toolchain.
	if [ "${ARCH}" = "i386" -a -z "$CROSS_COMPILE" -a "$(arch)" = "x86_64" ] ; then
		CPPFLAGS=-m32 LDFLAGS=-m32 make -C $BUSYBOX_VERSION -j16 CONFIG_PREFIX=$RAMDISK_WIP install
	else
		make -C $BUSYBOX_VERSION CONFIG_PREFIX=$RAMDISK_WIP install -j$JOBS
	fi
fi

# Create an initial directory structure 
mkdir -p $RAMDISK_WIP/{lib,proc,sys,dev,mnt,xbin,tmp}
chmod +t  $RAMDISK_WIP/tmp

# Populate init script
cat > $RAMDISK_WIP/init << "EOF"
#!/bin/sh

# If ramdisk doesn't come with premade empty proc sys dev folders - you can mkdir them here.

mount -t proc none /proc
mount -t sysfs none /sys
mount -t debugfs none /sys/kernel/debug

echo -e "\n\033[0;32m The PSCG mini-linux\033[0m booted in $(cut -d' ' -f1 /proc/uptime) seconds\n"

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

[ -c /dev/dri/card0 ] && echo -e "\x1b[32mIdentified DRM device\x1b[0m"
[ -c /dev/fb0 ] && echo -e "\x1b[32mIdentified Framebuffer device\x1b[0m"
# Deliberately print "QEMU" if qemu is identified.
if grep QEMU /sys/class/dmi/id/sys_vendor ; then
	mkdir /mnt/host
	# if it doesn't mount, no harm done. The purpose here is to be very brief, not accurate, and it is an addition made to explain some things in a talk
	# The output in this case would be something like:
	# 	9pnet_virtio: no channels available for device thepscg-mounts-you
	# 	mount: mounting thepscg-mounts-you on /mnt/host failed: No such file or directory
	mount -t 9p -o trans=virtio,version=9p2000.L  thepscg-mounts-you /mnt/host
fi


# You could communicate with psplash (which is either run from inittab or here, depending if /sbin/init is chosen, so we "start communicating" before we run it)
# by doing something like the next line. You can also choose to avoid it.
# The next line means the timeout 10 I put if you run psplash from here, will not be met becuase we give it less time
( for i in $(seq 10 5 100) ; do echo -e "PROGRESS $i\0" > /tmp/psplash_fifo ; sleep 0.1 ; done ; echo "QUIT" > /tmp/psplash_fifo) &


# Comment out if you do not wish to do the logic in inittab
# Since we show a splash screen in inittab, if you comment it out, we will "fallback" to showing the splash screen here
exec /sbin/init

# For our framebuffer example, show the splash screen. This is a userspace splash screen, and on the kernel graphics setup we cover the kernel boot logo. 
# If the call fails (e.g. no framebuffer, or no splash binary) - no harm done, as it is userspace.
# to avoid calling the splash screen, add "nosplash" to the kernel command line
grep -q nosplash /proc/cmdline || /usr/bin/psplash --timeout 10 &


# get rid of annoying job control message - it is not really necessary.
# also this is tailored for our exact scenario where we use the console as ttyS0 - be careful if you copy it to another platform, or in a graphical mode!
# For a more elegant solution, use cttyhack; https://git.busybox.net/busybox/plain/shell/cttyhack.c?id=dcaed97
exec setsid cttyhack sh # 'exec setsid sh </dev/ttyS0 >/dev/ttyS0 2>&1'

# Whatever is here will not run if you do not comment the previous line, because exec replaces the image.
# Extra notes for demonstration: Comment the above (setsid line) if you run qemu with graphical mode and without the cttyhack and you want to use the console. Otherwise, you will think the console gets stuck - while it doesn't.
#
exec /bin/sh
EOF

chmod +x $RAMDISK_WIP/init # Omit from full courses - explain briefly in short talks
# Repackage the ramdisk
exec ./repack_ramdisk.sh
