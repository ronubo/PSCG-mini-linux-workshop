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
COMPRESSION=tar.xz  # Use either tar.gz or tar.xz
export REMOTE_TARBALL=https://cdn.kernel.org/pub/linux/kernel/v5.x/${KV}.${COMPRESSION}
wget ${REMOTE_TARBALL}
tar xf ${KV}.${COMPRESSION}
