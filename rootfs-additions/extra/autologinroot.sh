#!/bin/sh
# The objective of this file is to login automatically as a root-user when invoked by busybox's getty
# -p preserves the environment
/bin/login -f root -p