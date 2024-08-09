# Branches in this project

This file holds a description of the different branches in the project as I intend to clean it up and don't want to pollute the README.md file which is probably so outdated,
(and most likely not used?), and will only be updated on the `master` branch, if.


## 2024 Work (done for the Graphics talk at meetup #17)

#### main branch `2024/busybox-init-wip`
This is where the current work on the graphics talk is done. The name remains only to explain it is a direct continuation of the other branch, `busybox-init`.
Here, there are gradual additions of kernel configurations, as well as some changes in the ramdisk files (for demonstration), and network is added here as well.
**Some of the documentation about the steps, is in a presentation. Some are in the commits of this branch, and some reasoning is in the `wip_ramdisk` init script.**

Do note that as per the time of writing, `fetch_busybox_and_create_initial_ramdisk` is deliberately not updated. I use the folder itself in the demonstration.
The real reason for this is that I will likely want the file more easily compared to `master`, but I don't want some of the concepts there (In particular: for our non graphic courses, we prefer less graphics, as it beats the purpose of not being hardware specific)


#### WIP branch `2024/tiny-config-wip` ( I wanted to merge a bit with master, but did not have time for that - and then moved on - look at it later, if)
`2024/tiny-config-wip`  took tiny-config and added to it the relevant files from master, including a little merge between the configs. 
- The only thing different between `2024/tiny-config-wip` and `master` at this point are the *extra configs*  and the *vscode* files. 
- Is almost identical to `tiny-config-wip, with the exception of still keeping the `wip_ramdisk` in the latter.
**Note that `master` also got a bit from both, and I think I will just keep the branches as they are at this point

# Some more information about the branches
Terminology: _ff_ (merged with fast forward, if not deleting wip_ramdisk)

## Until 2020 (except for cleanup, left as is, as there are Videos in youtube that match those branches)

### Building and explaining important concepts
Below are the dependencies for the branches, where `busybox-init` was the latest in line. Each branch was used for concept explanations. There could be tagging,
but that's how it is left, to match the recorded videos. In the later branches, most of the changes would be changing the kernel config that is being used.
I think the configs there were done on the v5.7 series of the Linux kernel, and I think they were all either done on x86_64 (most probable) or i386
- `OSS_Aug-2019-SanDiego` - First public publishing for a workshop at OSS San Diego 2019
- `banner-and-alias` - `OSS_Aug-2019-SanDiego` plus some additions
- `foss2020` - Foss North demonstration from 2020. 2024: Removed wip_ramdisk for ease of comparison to other branches
- `vt-explanation` - `foss2020^` + a couple of commits of scripts and explanations on virtual terminals, done inside wip_ramdisk so this commit stays.
- `busybox-init` - `vt-explanation` + a couple of commits demonstrating a busybox init framework such as root autologin et. al

`OSS_Aug-2019-SanDiego` --(ff)--> `banner-and-alias` --(ff)--> `foss2020^` --(ff)--> `vt-explanation` --(ff)--> `busybox-init` --> `2024/busybox-init-wip`


**I Tested busybox-init with the rcent kernel, just modified envsetup.sh (kernel version and busybox version), and ran some of the things from scripts/README.md
  The scripts/README.md file was added (and not changed since) one commit after foss2020**

#### How I tested the graphics (in the busybox-init, which was the latest, other than master)
The scripts weren't exactly accurate so instead:
```
qemu-system-x86_64 -kernel $KERNEL_OUT/arch/x86/boot/bzImage -enable-kvm -initrd ${RAMDISK_PACKED}   -append "fbcon=nodefer vga=0x312  nokaslr rdinit=/init console=ttyS0"  -serial mon:stdio
```

Note that the kernel configuration there does not have networking.


### tiny-config - A branch where `our-tiny-config.config -> tiny_ramdisk_elf_procfs_sysfs_serialconsole.config`
tiny-config is a branch that had a couple of extra commits **and was used in the youtube recording of the kernel debuggers, and debugging with vscode**, after the basic *nographic* only code, although it does also provide a VGA console.
It is not trivially mergable, so I kept it as is. I **did not** reproduce the VSCode work (see [youtube video](https://www.youtube.com/watch?v=dXhm3Kdnnbg&list=PLBaH8x4hthVysdRTOlg2_8hL6CWCnN5l-&index=27]), and I think, in general, that it might 
- `83ffc3e` (origin/tiny-config, tiny-config) Added Microsoft Visual Studio Code examples *This is likely a good merge candidate for the other branches*
- `e10d819` Setup for Embedded Israel presentations and youtube videos
    This has gdb and our tiny config (symlink file) is  tiny_ramdisk_elf_procfs_sysfs_serialconsole.config
- `e74a78e` Using olddefconfig for the tiny-branch.
    changed: build_kernel.sh  (changed `make` command for the build phase --> `make olddefconfig`)
- `43ed7be` Added another minimal config framgment, for 32bit x86 architecture.
    added: kernel-configs/tiny_ramdisk_elf_procfs_sysfs_serialconsole.config

------- the commit below is in foss2020. Those above are already additions to that
- `99e80ae` Minimal kernel (VGA console + Keyboard + Ramdisk + ELF) + supporting minimal rootfs

For the sake of completion, this is the `git show branch` output, for comparing both of them. (**remember that the graphics talks are *ff* of `the `foss2020` branch):
```
$ git show-branch  tiny-config foss2020 
! [tiny-config] Added Microsoft Visual Studio Code examples
 ! [foss2020] Removed wip_ramdisk from source control. It was added for very specific illustration purposes, and now it mostly annoys the students (as well as the instructors) when the do git log
--
 + [foss2020] Removed wip_ramdisk from source control. It was added for very specific illustration purposes, and now it mostly annoys the students (as well as the instructors) when the do git log
 + [foss2020^] Added timeout to splash screen, added command pipe interface shell script.
 + [foss2020~2] Added /usr/bin/psplash - a hacky psplash customization
 + [foss2020~3] Configs for live example at FOSS North 2020
 + [foss2020~4^2] Added rootfs-extras. From now on, this is what will be maintained. Also added inittab example.
 + [foss2020~4^2^] Added ronenv autostart script, and a banner. Also added a copying to rootfs script (add_rootfs_extras)
 + [foss2020~4^2~2] Updated busybox binary and modified init to focus on working on console
+  [tiny-config] Added Microsoft Visual Studio Code examples
+  [tiny-config^] Setup for Embedded Israel presentations and youtube videos
+  [tiny-config~2] Using olddefconfig for the tiny-branch.
+  [tiny-config~3] Added another minimal config framgment, for 32bit x86 architecture.
++ [foss2020~5] Minimal kernel (VGA console + Keyboard + Ramdisk + ELF) + supporting minimal rootfs

```


### Quick detour to show a trivial concept
`userspace-dependency-hacking-exercise-solution`- `OSS_Aug-2019-SanDiego` plus a solution to/explanation of one of the exercises in the first day of the PSCG's Embedded Linux course

OSS_Aug-2019-SanDiego --(ff)--> userspace-dependency-hacking-exercise-solution



### Some more obsolete branches
`more-kvm-run-exmaples-backup` - OSS_Aug-2019-SanDiego plus some older kvm running scripts
`OSS_Aug-2019-SanDiego` --(ff)-->  `more-kvm-run-exmaples-backup`


# `master` - out of the scope of the meetups
The `master` branch is simple, aims to use defconfigs, and get people working on without explanations. 
It is not covered in the meetups, and is updated for our training use usually.
