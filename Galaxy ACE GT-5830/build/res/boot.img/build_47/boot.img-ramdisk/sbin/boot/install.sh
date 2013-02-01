if /sbin/busybox [ ! -f /system/cfroot/release-84-S5830- ]; 
then

    # marshal
    # mkdir for dalvik-cache, cache, app on SD-EXT
    /sbin/busybox mkdir -p /mnt/sd-ext/dalvik-cache
    /sbin/busybox chown 1000.1000 /mnt/sd-ext/dalvik-cache
    /sbin/busybox chmod 771 /mnt/sd-ext/dalvik-cache

    /sbin/busybox mkdir -p /mnt/sd-ext/cache
    /sbin/busybox chown 1000.1000 /mnt/sd-ext/cache
    /sbin/busybox chmod 771 /mnt/sd-ext/cache

    /sbin/busybox mkdir -p /mnt/sd-ext/app
    /sbin/busybox chown 1000.1000 /mnt/sd-ext/app
    /sbin/busybox chmod 771 /mnt/sd-ext/app

# Remount system RW
    /sbin/busybox mount -o remount,rw /system

# Remove startup sounds
    if /sbin/busybox [ -f /system/etc/poweron.ogg ]; then
        /sbin/busybox mv /system/etc/poweron.ogg /system/etc/poweron.ogg.backup
    fi;

# marshal /data/app -> /mnt/sd-ext/app
# -------------------------------------
# MOVING APPS TO SD TO SAVE SOME SPACE
# -------------------------------------

    # Superuser
    #/sbin/busybox rm /data/app/Superuser.apk
    /sbin/busybox cp -f /res/misc/Superuser.apk /data/app/Superuser.apk
    /sbin/busybox chown 0.0 /data/app/Superuser.apk
    /sbin/busybox chmod 644 /data/app/Superuser.apk

    # Tweaks script returned back to /sbin/boot
    /sbin/busybox rm /system/etc/init.d/00tweaks

    # CWM & Tweak Manager
    /sbin/busybox rm /data/dalvik-cache/*CWMManager.apk*
    /sbin/busybox rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk

    /sbin/busybox rm /data/dalvik-cache/*TweakManager.apk*
    /sbin/busybox rm /data/app/eu.chainfire.cfroot.tweakmanager*.apk

    /sbin/busybox cp -f /res/misc/CWMManager.apk /data/app/CWMManager.apk
    /sbin/busybox chown 0.0 /data/app/CWMManager.apk
    /sbin/busybox chmod 644 /data/app/CWMManager.apk

    /sbin/busybox cp -f /res/misc/TweakManager.apk /data/app/TweakManager.apk
    /sbin/busybox chown 0.0 /data/app/TweakManager.apk
    /sbin/busybox chmod 644 /data/app/TweakManager.apk

    # Moving apps from /system/app
    # Dlna
    /sbin/busybox mv -f /system/app/Dlna.apk /data/app/Dlna.apk
    /sbin/busybox mv -f /system/app/Dlna.odex /data/app/Dlna.odex
    /sbin/busybox chown 1000.1000 /data/app/Dlna.apk /data/app/Dlna.odex
    /sbin/busybox chmod 644 /data/app/Dlna.apk /data/app/Dlna.odex
    # Email
	/sbin/busybox mv -f /system/app/Email.apk /data/app/Email.apk
    /sbin/busybox chown 1000.1000 /data/app/Email.apk
    /sbin/busybox chmod 644 /data/app/Email.apk
    # Gmail
	/sbin/busybox mv -f /system/app/Gmail.apk /data/app/Gmail.apk
    /sbin/busybox chown 1000.1000 /data/app/Gmail.apk
    /sbin/busybox chmod 644 /data/app/Gmail.apk
    # Maps
    /sbin/busybox mv -f /system/app/Maps.apk /data/app/Maps.apk
    /sbin/busybox chown 1000.1000 /data/app/Maps.apk
    /sbin/busybox chmod 644 /data/app/Maps.apk
    # Youtube
    /sbin/busybox mv -f /system/app/YouTube.apk /data/app/YouTube.apk
    /sbin/busybox chown 1000.1000 /data/app/YouTube.apk
    /sbin/busybox chmod 644 /data/app/YouTube.apk

# ensure /system/xbin exists
    /sbin/busybox mkdir -p /system/xbin
    /sbin/busybox chmod 755 /system/xbin

# ensure /system/etc/init.d exists
    /sbin/busybox mkdir -p /system/etc/init.d
    /sbin/busybox chmod 755 /system/etc/init.d

# su
    /sbin/busybox rm /system/bin/su
    /sbin/busybox cp -f /res/misc/su /system/xbin/su
    /sbin/busybox chown 0.0 /system/xbin/su
    /sbin/busybox chmod 6755 /system/xbin/su

# MSM7K BLN lights library
    if /sbin/busybox test $(/sbin/busybox strings /system/lib/hw/lights.msm7k.so | /sbin/busybox grep -c backlightnotification) -eq 0; then
        if /sbin/busybox test ! -f /system/lib/hw/lights.msm7k.so.backup; then
            /sbin/busybox cp /system/lib/hw/lights.msm7k.so /system/lib/hw/lights.msm7k.so.backup
        fi
        /sbin/busybox cp /res/misc/lights.msm7k.so /system/lib/hw/
        chmod 644 /system/lib/hw/lights.msm7k.so
    fi

# marshal copy driver to system dir by hand, no need to redo
# MSM7K wifi module
#    if /sbin/busybox test $(/sbin/busybox strings /system/wifi/ar6000.ko | /sbin/busybox grep -c 2.6.35.7-perf-CL807529) -eq 0; then
#        if /sbin/busybox test ! -f /system/wifi/ar6000.ko.backup; then
#            /sbin/busybox cp /system/wifi/ar6000.ko /system/wifi/ar6000.ko.backup
#        fi
#        /sbin/busybox cp /res/misc/ar6000.ko /system/wifi/
#        chmod 644 /system/wifi/ar6000.ko
#    fi

# CSC tool, propset, and propget
    /sbin/busybox cp -f /res/misc/sec_csc /system/xbin/sec_csc
    /sbin/busybox chown 0.2000 /system/xbin/sec_csc
    /sbin/busybox chmod 755 /system/xbin/sec_csc

    /sbin/busybox cp -f /res/misc/propset /system/xbin/propset
    /sbin/busybox chown 0.2000 /system/xbin/propset
    /sbin/busybox chmod 755 /system/xbin/propset

    /sbin/busybox cp -f /res/misc/propget /system/xbin/propget
    /sbin/busybox chown 0.2000 /system/xbin/propget
    /sbin/busybox chmod 755 /system/xbin/propget

# CPU Governer
    /sbin/busybox cp -f /res/misc/init.cfroot.post_boot.sh /system/etc/init.cfroot.post_boot.sh
    /sbin/busybox chown 0.0 /system/etc/init.cfroot.post_boot.sh
    /sbin/busybox chmod 644 /system/etc/init.cfroot.post_boot.sh

# Once be enough
    /sbin/busybox mkdir -p /system/cfroot
    /sbin/busybox chmod 755 /system/cfroot
    /sbin/busybox rm /system/cfroot/*
    echo 1 > /system/cfroot/release-84-S5830-

# ensure /system/sd exists for app2sd
	# marshal
    #/sbin/busybox mkdir -p /system/sd

# Remount system RO
    /sbin/busybox mount -o remount,ro /system
fi;
    
