#####################################################################################
# i386 QEMU kernel bootloader debugging script/scenario (qemu jumps to header.S at 0x200)
# Kernel extraction and relocation ( boot/compressed/vmlinux )
#
# Taken from The PSCG security/porting/debugging courses
# Ron Munitz <ron@thepscg.com>
#####################################################################################

target remote :1234

set architecture i386 
## Now it's OK to disassemble the next line.
set disassemble-next-line on

display /20i $pc

## Just a reminder of the previous debugging, no need for this line
## add-symbol-file arch/x86/boot/setup.elf 0x01045d -s .bstext 0x7c00 -s .bsdata 0x7c2d -s .header 0x101ef -s .entrytext 0x1026c -s .inittext 0x102e9 -s .text.startup 0x12ec6 -s .text32 0x13081

## Be VERY VERY VERY CAREFUL not to use the load command - it will overwrite your memory! You could (potentially) do it (loading the proper files!) after QEMU bootloader supposedly booted 
## your kernel, and placed it in memory in the exected location. It is a great exercise, for a later phase (many confusions, and of course we don't even execute an ELF at the setup phase, so being lazy 
## and trying to "load symbols here" - is simply wrong!
#### load arch/x86/boot/setup.elf 0x10000                                                                                                                                                                   


####
# You cannot have more than 4 hardware breakpoints, otherwise you will get this when you "cont" (and cont will not continue until you get rid of the breakpoints)
#Warning:
#Cannot insert hardware breakpoint 5.
#Could not insert hardware breakpoints:
#You may have requested too many hardware breakpoints/watchpoints.
#
#
# So we comment out some of the breakpoints that are interesting. 
# Another insight about breakpoints - use hbreak for at least the first breakpoint - and good chances that you could use break for the next ones 
# All are QEMU/GDB bugs, that may or may not appear in some versions/combinations. Save yourself the effort by understanding it - or you will
# lose your hair debugging it!
#
#
# Another reason to comment out breakpoints is that there is a bug that does not let you step or continue sometimes. 
# For software breakpoints you will sometimes see the kind message:
#Cannot remove breakpoints because program is no longer writable.
#Further execution is probably impossible.
# For hardware breakpoints you are unlikely to see anything.
# clear  (deleting all breakpoints) will get you through (and then you will need to add breakpoints again yourself. Copy/Pasting from this file is a good idea, assuming addresses don't change.)
# in this case - you will once again HAVE to set your first (next) breakpoint as a hardware breakpoint.
#
####


## Break on jumping to 0x100000 (boot_params.hdr.code32_start + ds << 4)
#hbreak *0x1309d

#===========================================
# Second phase - extraction and relocation
#===========================================
## Load the symbol file
add-symbol-file arch/x86/boot/compressed/vmlinux 0x11cea0 -s .head.text 0x100000




# 
# protected mode debugging
#-----------------------------



## break on startup_32 before relocation 
#hbreak *0x00100000   


## Break (one time) on  0x10005d:	rep movsl %ds:(%esi),%es:(%edi)
#thbreak *0x10005d 
##### Set upon reaching this breakpoint the following commands, but do it later
### skip the string copying (if there are remainders, there may be need to do something like this for the rest (i.e. strings are divided to 4, see instructions before it)
### the problem with this breakpoint, is that doing so many si take a lot of time (eci is huge, e.g.  0x48720	296736). So it's better to demonstrate once, and then set breakpoint and jump to it.
### ignoring the breakpoint for $ecx times would also take a lot of time. 
# si $ecx 
### A nicer alternative (but you will need to disable the breakpoint) is to remove the breakpoint once we reach it, and then break on the next line
#hbreak *0x10005f


#===========================================
# Third phase - after relocation. Kernel Extraction
#===========================================
## Break on .Lrelocated  ,  _text
#hbreak *0x147dea0

## Set the .text section to fit the address the information after relocation
#add-symbol-file arch/x86/boot/compressed/vmlinux 0x0147dea0 

## break on extract_kernel
hbreak *0x147f9d0



#===========================================
# Fourth phase - page enabling
#==========================================
## Add the symbol file - we could also use vmlinux here. .text section doesn't matter. In vmlinux, there is no .head.text, same code goes to .text in 0xc1000000
# add-symbol-file arch/x86/kernel/head_32.o 0x0 -s .head.text 0x1000000
## break on startup_32 after relocation (from kernel/head_32.S)
#hbreak *0x01000000

## break after paging is enabled and before the jump to the first paged address (see .Lenable_paging ) 
#hbreak *0x1000118

#===========================================
# Fifth phase - paging is enabled
#==========================================

# 
# Paging enabled
#-----------------------------


## work with vmlinux now
 file vmlinux 

## This is another startup_32, from kernel/head_32 - so not this! hb *0xc1000000

## setup_once
# hbreak *0xc12bf000

## Break at i386_start_kernel  from kernel/head32  (that is different than head_32 - and is made by head32.c )
hbreak *0xc12bf1b5

## Break at init/main.c's start_kernel()
# could do   hbreak *0xc12bf829    - but let's use names now :-) 
hbreak *start_kernel  


