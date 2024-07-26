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
#
# Will fail if you don't have KV --> if you didnt $ . envsetup.sh first
#
# This version now illustrates the use of config fragments, as well as what works well with the make/Kconfig and what doesn't work as well (but is not so important and one can definitely live without)
make -C ${KERNEL_SRC} O=${KERNEL_OUT} defconfig # Note: kvmconfig is deprecated in recent kernel, otherwise chain two targets in this line (e.g. make ... defconfig kvmconfig)

if [ ! -f $LABS/kernel-configs/our-tiny-config.config ] ; then
cd ${KERNEL_OUT}
${KERNEL_SRC}/scripts/kconfig/merge_config.sh .config ${LABS}/kernel-configs/kernel-debug-fragment.config
make -j${JOBS}
cd -

# NOTE: As per 5.3-rc3, merge_config.sh doesn't work as you would expect out of a kernel tree - so we change directory there. It's easy to see why in the script file itself. Care enough to fix and upstream?

else
# In this version we do not use fragments, but rather build each config for each commit, for simplicity
# In the master branch, the default is "as easy as it gets". We will add fragments towards the end of our minimal configuration process
mkdir $KERNEL_OUT
cp ${LABS}/kernel-configs/our-tiny-config.config ${KERNEL_OUT}/.config
make -C ${KERNEL_SRC} O=${KERNEL_OUT} -j${JOBS} olddefconfig
make -C ${KERNEL_SRC} O=${KERNEL_OUT} -j${JOBS}
fi
