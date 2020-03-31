# Some scripts and examples

I am not going to bother to parse arguments as the Android Emulator or runqemu in the Yocto Project do.
This folder may become bloated with scripts, for the sake of not running too much, not writing too much and not making up shell function names and forgetting about them. To prevent this annoying scenaario, For now, contents are going to be pasted here, along with some explanations. Sometimes, I will add running commands to the commit messages, to explain what we demonstrate in that commit.

Ignore markdown, this is a textual file, and I'm really not going to bother to make things pretty
Maybe if I make it rst it will look nicer in github.
There are really annoying things with both, and the way, e.g. vi shows the text files, and each one of them is annoying on its own way, so if you are seeing this file in github/bitbucket/etc. - ignore the formating.


# Examples

*Important* if you specify multiple console=<ttyWHATEVER> parameters - the last one will be the console for vt0, so this will be 
            your only default input console, unless you open more vts. 
            if you don't specify multiple console=<ttyWHATEVER> parameters - console prints will only go to the console you specified.
So pay close attention to:
1. Order of the console=<> params (last will be the default input console)
2. To where you allow or not allow consoles
3. Of course, to the serial interfaces you provide.

Note about  init=  /  rdinit=/  - don't just copy paste - make sure you understand which init you run - as I will not explain it here. You are expected to understand the difference and the flow by now.

Note about logins etc: We don't bother to take care of them now, as we did not bother to config the kernel with CONFIG_MULTIUSER=y (added at Kernel 4.1. This can be quite confusing, as it is a "relatively new feature" which breaks almost every known behavior if disabled. However, for minimal systems which just run a root user, it is perfectly fine)
So when we show ttys - we will only slightly show busybox mechanisms, to give the explanation of how some of these things go.
We will avoid using login / su and the likes, on the minimal linux branches. If you build with more CONFIG_s enabled, you can get closer to the behavior of a real distro.


# 
#cp rootfs-additions/extra/progress_splash.sh wip_ramdisk/extra/ && cp rootfs-additions/etc/inittab 
#wip_ramdisk/etc/ && ./repack_ramdisk.sh &&

# 640x480x24  two serials - console goes to both qemu window and the first serial second serial is a local file
qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=ttyS0 console=tty0 "  -serial mon:stdio -serial file:ThisIsMySerial

# 640x480x24  two serials - console goes to both qemu window, the serial, and the file
qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=tty0 console=ttyS0 console=ttyS1"  -serial mon:stdio -serial file:kernel-console-output


# 640x480x24  on serial  - console goes to both qemu window and  the serial (ctrl+c does not terminate, use ctrl+a+x instead
qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=tty0 console=ttyS0"  -serial mon:stdio


# 640x480x24  on serial  - console goes to both qemu window and  the serial (ctrl+c does terminate)
qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=tty0 console=ttyS0"  -serial stdio


# Several serial interfaces
 qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=tty0 console=ttyS0"  -serial mon:stdio -serial /dev/pts/41 -serial pipe:/tmp/hello 


# On the splash screen commits, before tty handling, if we don't specify console=tty0 - we will no longer see the kernel conole log there.

qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/sbin/init console=ttyS0 "  -serial mon:stdio
