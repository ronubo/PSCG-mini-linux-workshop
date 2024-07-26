#!/bin/bash
#
# Some explanations: We prefer to support amd64 (x86_64) and aarch64/arm64.
# Darwin (MacOS) calls the architecture "arm64", and so does the kernel tree (folder name wise).
# However, most Linux toolchains, and the Linux kernel itself call the architecture "aaarch64". 
# So as far as you are concerned, they are synonymous.
#
# The serial interfaces for the the x86_64 and aarch64 are different. We expect most people that run an aarch64 vm for this demo,
# to be running on a VM on a MacOS - and so we will not enable KVM for that. This might hold as well for x86_64 users who
# run a VM either on a non Linux host, or on an hypervisor that does not support nested virtualization
#

: ${KVM_ENABLE_FLAG="--enable-kvm"}
if [ "$ARCH" = "x86_64" ] ; then
	qemu-system-x86_64     -kernel ${KERNEL_OUT}/arch/x86/boot/bzImage -initrd ${RAMDISK_PACKED} -nographic -append "console=ttyS0 kgdboc.kgdboc=ttyS0 " $KVM_ENABLE_FLAG
elif [ "$ARCH" = "arm64" -o "$ARCH" = "aarch64" ] ; then
	: ${IMAGE_TYPE=Image} # for non x86 architectures, you may want to experiment with more image types
	qemu-system-aarch64     -kernel ${KERNEL_OUT}/arch/arm64/boot/${IMAGE_TYPE} -M virt -cpu cortex-a72 -initrd ${RAMDISK_PACKED} -nographic -append "console=ttyAMA0 kgdboc.kgdboc=ttyAMA0"
elif [ "$ARCH" = "riscv64" -o "$ARCH" = "riscv" ] ; then
	: ${IMAGE_TYPE=Image} # for non x86 architectures, you may want to experiment with more image types
	# At this time, just not specifying a cpu is fine, but you can experiment with those as well
	qemu-system-riscv64     -kernel ${KERNEL_OUT}/arch/riscv/boot/${IMAGE_TYPE} -M virt -cpu sifive-u54 -initrd ${RAMDISK_PACKED} -nographic -append "console=ttyS0 kgdboc.kgdboc=ttyS0"
fi
