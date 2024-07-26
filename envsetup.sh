#
# envsetup.sh - environment setup for the PSCG-mini-linux-workshop. Given the increased interest in riscv64, and increased
# 		usage of Apple Silicon hosts, we have made the file a bit more complicated. Please read the comments carefully
#		if you want to do anything besides building for the same architecture of your current host.
#

#
# If you are interested in building for another target architecture, you have to cross compile. The following lines are
# a suggestion for you for the minimal customization option. You must of course set the right paths.
# Uncomment and modify them ONLY if you know what you are doing, or if the instructor instructed you to do so.
# 
# The following example is useful for cross building for riscv64, in the PSCG Embedded Linux courses that deal with riscv64
# you may uncomment and change accordingly to your target architecture and your cross toolchains
#
# export ARCH=riscv # uncomment and modify to select your own architecture, overriding the auto selection above
# export PATH=$PATH:$HOME/resources/aarch64/x-tools/riscv64-thepscg.com-linux-gnu/bin/
# export CROSS_COMPILE=riscv64-thepscg.com-linux-gnu-

if [ "$1" = "--force-local-architecture" ] ; then
	echo "Will unset ARCH and CROSS_COMPILE, in case you have set then elsewhere. Just FYI they were $CROSS_COMPILE / $ARCH respectively"
	unset ARCH
	unset CROSS_COMPILE
fi

#
# Autoset target architecture to the host one. Done by default for faster illustrations. This is absolutely not necessary
#
if [ -z "$ARCH" ] ; then
	case "$(arch)" in
		x86_64)
			export ARCH=x86_64	;;
		aarch64)
			export ARCH=arm64	;;
		riscv64)
			export ARCH=riscv	;;
		*)
			echo "Please export your own ARCH variable, as $(arch) hosts are not very common for our students"	;;
	esac
fi

BASEDIR=$(pwd)
export MACHINE=qemu
export KV_SERIES=v6.x
export KV=linux-6.10.1
export LABS=${BASEDIR}
export KERNEL_SRC=${BASEDIR}/${KV}
export KERNEL_OUT=${BASEDIR}/${KV}-${MACHINE}-${ARCH}-out
export RAMDISK_WIP=${BASEDIR}/wip_ramdisk
export RAMDISK_PACKED=${BASEDIR}/initramfs.gz
export BUSYBOX_VERSION=busybox-1.36.1
export BUSYBOX_SRC=${BASEDIR}/${BUSYBOX_VERSION}
export JOBS=$(nproc)

