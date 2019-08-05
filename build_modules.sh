#!/bin/bash
# Helper script for the workshop given at  
# Open Source Summit/Embedded Linux Conference 2019 San Diego 
# "Understanding, Building and Researching Minimal (and not so minimal) Linux Systems
# Ron Munitz <ron@thepscg.com>
# PSCG Holdings LTD / The PSCG
#
# The tasks are deliberately divided into very simple scripts, so that 
# the student will easily "know what does what" by the script name, without 
# needing any special documentation, and without having to really look at the presentations

# Will fail if you don't have KV --> if you didnt $ . envsetup.sh first

# Install in-tree modules. Note how "-C" can be used directly with the build directory - so you don't need to also set O=
echo "Installing in-tree modules"
make  -C ${KERNEL_OUT} INSTALL_MOD_PATH=${RAMDISK_WIP} modules_install
echo "Building and installing out of tree modules for our demo arch"
make -C hello-module/ TARGET=qemu modules
make -C hello-module/ TARGET=qemu modules_install
echo -e "\nDo not forget to rebuild (repackage) the ramdisk before re-running the kernel!"

