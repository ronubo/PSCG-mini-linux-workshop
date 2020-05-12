#####################################################################################
# i386 QEMU kernel boot sector debugging script/scenario
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

#### add-symbol-file arch/x86/boot/setup.elf 0x10000 # Will not be good enough because most of the code is not in the .text segment. 

## That will show you the function names upon calling (when you x/20i $cs*16+$pc . That's good enough to see what is going on. GDB is really not handling the real mode thing that well, so you need to understand what you read. There might be mistakes with data - anyway GDB doesn't need them, it handled everything quite nicely


## take care of almost everything. The "0x0" here is actually a don't care. .text address is 0x01145d  but we don't care about it at all.
add-symbol-file arch/x86/boot/setup.elf 0x0 -s .bstext 0x7c00 -s .bsdata 0x7c2d -s .entrytext 0x10026c -s .inittext 0x1002e9 -s .text.startup 0x12ec6 -s .text32 0x13081

## Break at the very start. CS=0x0 , PC=0x7C00 (irregular, but that's how it is.)
## That line jumps and then adjusts the CS:PC
hb *0x07C00

## If you si  here -  you will now be after the jump to  0x7c0 : 0x5

## Note: if you leave some of the following breakpoint lines uncommented and you think QEMU is stuck - you may want to remove breakpoints. It's a known bug in QEMU/GDB


## break at each iteration of the msg_loop
hbreak *0x7c14   
## break before getting input from the user
hbreak *0x7c22

## You can use the following ways e.g. to debug the user message 
disp /c $al
disp $ds*16 + $si

##
## You can of course debug also the BIOS - if you single step into the interupts! (easy to observe if you "step too much" if you see the CS changes, will jump to your eyes with experience)
##


