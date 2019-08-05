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
export REMOTE_TARBALL=https://git.kernel.org/torvalds/t/${KV}.tar.gz
wget ${REMOTE_TARBALL}
tar xf ${KV}.tar.gz
