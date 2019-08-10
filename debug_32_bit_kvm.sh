#!/bin/bash
kvm  -kernel out_qemu_x86/arch/x86/boot/bzImage  -initrd busybox/bbinitramfs-x86.cpio.gz -nographic -append "console=ttyS0" -s -S

# now use hbreak  (breaks are fragiles!)
# e.g.:  
# $ gdb out_qemeu_x86/vmlinux 
# (gdb) target remote :1234
# (gdb) hbreak start_kernel
# (gdb) hbreak __schedule
# (gdb) hbreak _do_fork

# To exit the qemu window: ctrl-a x
