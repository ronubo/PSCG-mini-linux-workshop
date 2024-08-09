BASEDIR=$(pwd)
export MACHINE=qemu
export ARCH=x86_64
export KV=linux-6.11-rc2
export LABS=${BASEDIR}
export KERNEL_SRC=${BASEDIR}/${KV}
export KERNEL_OUT=${BASEDIR}/${KV}-${MACHINE}-${ARCH}-out
export RAMDISK_WIP=${BASEDIR}/wip_ramdisk
export RAMDISK_PACKED=${BASEDIR}/initramfs.gz
export BUSYBOX_VERSION=busybox-1.36.1
export BUSYBOX_SRC=${BASEDIR}/${BUSYBOX_VERSION}
export JOBS=$(nproc)

