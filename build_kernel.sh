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
# In this version we do not use fragments, but rather build each config for each commit, for simplicity
# In the master branch, the default is "as easy as it gets". We will add fragments towards the end of our minimal configuration process
mkdir $KERNEL_OUT
cp ${LABS}/kernel-configs/our-tiny-config.config ${KERNEL_OUT}/.config
make -C ${KERNEL_SRC} O=${KERNEL_OUT} -j${JOBS}

