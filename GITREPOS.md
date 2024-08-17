# Other useful repos (will be useful when I remove wip_ramdisk for all branches)

- `https://github.com/ronubo/mini-linux-kernel-config` branch `2024/meetup17` - has the configs prepared here (so you can say it is a duplication). In master there will be no configs, so it is recommended to use that if you are interested
- `https://github.com/ronubo/psplash` branch `mini-linux-splash` - has the psplash implementation with my picture, text etc. (I forked from the Yocto Project, and added customization in FOSS North 2024). 
   **psplash** is expected (but nothing bad happens if it is not there) at `wip_ramdisk/usr/bin/psplash`, so if you want to build it from source you can (replace with your own git https:// etc.):
   ```
    git clone git@github.com:ronubo/psplash.git
    cd psplash
    autoreconf -fi
    LDFLAGS=-static ./configure
    make -j$(nproc)
    cp -a psplash $RAMDISK_WIP/usr/bin/psplash  
    # if you setenv, unless you changed the parameters, $RAMDISK_WIP would point to wip_ramdisk
   ```
- `https://github.com/ronpscg/meetup-17` - Has some root file systems to mount, e.g., with 9p, instead of having them in the ramdisk (e.g: for Busybox's fbsplash usage).
   (not sure which branch, probably master, as I did not upload to it yet, and it will probably just be a place for blobs, backup, some qemu running scripts, etc.)
   FYI: ronubo/ronpscg - I was working on something else with some gitkeys and got too lazy to add some things to ronubo... not critical
