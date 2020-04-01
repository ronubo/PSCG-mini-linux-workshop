#!/bin/sh
# The objective of this file is to login automatically as a root-user when invoked by busybox's getty
# we will not bother with the terminal details
# In PC distros you'd expect "linux" in yocto "vt102"
/sbin/getty -l /extra/autologinroot.sh  38400 $1 linux
