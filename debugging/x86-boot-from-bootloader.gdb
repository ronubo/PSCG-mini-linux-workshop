#####################################################################################
# i386 QEMU kernel bootloader debugging script/scenario (qemu jumps to header.S at 0x200)
#
# Taken from The PSCG security/porting/debugging courses
# Ron Munitz <ron@thepscg.com>
#####################################################################################

target remote :1234

#=============================
# First phase - setup
#=============================

# 
# real mode debugging
#-----------------------------

set architecture i8086
#### set disassemble-next-line on  # bad idea for realmode - will not take into account the code segment, so never do that!


display /x $cs
display /x $pc
display /20i $cs*16+$pc
display /x $ds

## GDB will not necessarily show the information for .header even if you show it properly, - so breaking on 0x200 will not necessarily show the label _start. Not the end of the world.
add-symbol-file arch/x86/boot/setup.elf 0x01045d -s .bstext 0x7c00 -s .bsdata 0x7c2d -s .header 0x101ef -s .entrytext 0x1026c -s .inittext 0x102e9 -s .text.startup 0x12ec6 -s .text32 0x13081

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

## Break at the first instruction the boot loader is expected to jump to.
# hb *0x10200


# Break at start_of_setup ( stops on other things unfortunately in QEMU so nevermind)
# This is tricky because the address is correct, but the Segment/PC are off
# CS is 0x1020  (see the note about CS is DS + 20 at entry at header.S
# So the address is:  cs=0x1020 pc=$6c - and not (0x26c + 0x10000) as we would expect - but it is the same address at the end!
# hb *(0x26c + 0x10000) 

# Break at signature check in header.S
# hbreak *(0x2a3 + 0x10000)


# break at puts (it is an important stop - and some of the calls to it (e.g. in main() ) are wrongly disassembled by GDB.
# hbreak *(0x3d2 + 0x10000)

## Break at intcall
# hbreak *(0x2e9 + 0x10000)

## break at main() - GDB may miss the .text.startup section, so there is a good chance you won't see the function names there. you could alternatively reload symbols / aaddresses.
##      to work around that, You could then 
##      (gdb) symbol-file  
##      (gdb) #  add again your displays, it won't work otherwise
##      (gdb) add-symbol-file arch/x86/boot/setup.elf 0x0 -s .text.startup 0x12ec6

## break at main()
#hbreak *(0x2ec6 + 0x10000)


# go to protected mode/ protected mode jump

## Break on go_to_protected_mode
#hbreak *(0x0000120d +0x10*0x1000)
## Break on protected_mode_jump
hbreak *(0x00001291 +0x10*0x1000)

#
# Protected mode tranistion
#--------------------------------------

## We want to break before the jump:     12b3:       66 ea 81 30 00 00 10    ljmpl  $0x10,$0x3081
## At the end of this function - we want to adjust our display - as we will be in protected mode
## Break exactly before the jump to protected mode (CR0 bit is already set)
hbreak *(0x112b3)

## After the transition you will want to inspect $pc and not ($cs*16+$pc)
## This would be a good time to undisplay everything, and then inspect things as if there was never realmode
## (if you are booting other CPUs, then they will be again in real mode, etc.)

undisplay
display /20i $pc

## Break on jumping to 0x100000 (boot_params.hdr.code32_start + ds << 4)
hbreak *0x1309d


#===========================================
# Second phase - extraction and relocation
#===========================================

# --- Done in x86-protected-mode-compressed-startup_32.gdb  ---

