BASEDIR=$(pwd)
export MACHINE=qemu
export ARCH=arm64
export KV_SERIES=v6.x
export KV=linux-6.6
export LABS=${BASEDIR}
export KERNEL_SRC=${BASEDIR}/${KV}
export KERNEL_OUT=${BASEDIR}/${KV}-${MACHINE}-${ARCH}-out
export RAMDISK_WIP=${BASEDIR}/wip_ramdisk
export RAMDISK_PACKED=${BASEDIR}/initramfs.gz
export BUSYBOX_VERSION=busybox-1.36.0
export BUSYBOX_SRC=${BASEDIR}/${BUSYBOX_VERSION}
export JOBS=8

