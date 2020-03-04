BASEDIR=~/kertlv/demo
export MACHINE=qemu
export ARCH=x86_64
export KV=linux-5.6-rc2
export LABS=${BASEDIR}
export KERNEL_SRC=${BASEDIR}/${KV}
export KERNEL_OUT=${BASEDIR}/${KV}-${MACHINE}-${ARCH}-out
export RAMDISK_WIP=${BASEDIR}/wip_ramdisk
export RAMDISK_PACKED=${BASEDIR}/initramfs.gz
export BUSYBOX_SRC=${BASEDIR}/busybox-1.30.1
export JOBS=4

