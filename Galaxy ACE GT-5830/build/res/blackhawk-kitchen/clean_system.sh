#!/bin/bash

# Ketut P. Kumajaya, Jan 2012

rm system/bin/cat
rm system/bin/chmod
rm system/bin/chown
rm system/bin/cmp
rm system/bin/date
rm system/bin/dd
rm system/bin/df
rm system/bin/dmesg
rm system/bin/getevent
rm system/bin/getprop
rm system/bin/hd
rm system/bin/id
rm system/bin/ifconfig
rm system/bin/iftop
rm system/bin/insmod
rm system/bin/ioctl
rm system/bin/ionice
rm system/bin/kill
rm system/bin/ln
rm system/bin/log
rm system/bin/ls
rm system/bin/lsmod
rm system/bin/lsof
rm system/bin/mkdir
rm system/bin/mount
rm system/bin/mv
rm system/bin/nandread
rm system/bin/netstat
rm system/bin/newfs_msdos
rm system/bin/notify
rm system/bin/printenv
rm system/bin/ps
rm system/bin/reboot
rm system/bin/renice
rm system/bin/rm
rm system/bin/rmdir
rm system/bin/rmmod
rm system/bin/route
rm system/bin/schedtop
rm system/bin/sendevent
rm system/bin/setconsole
rm system/bin/setprop
rm system/bin/sleep
rm system/bin/smd
rm system/bin/start
rm system/bin/stop
rm system/bin/sync
rm system/bin/top
rm system/bin/umount
rm system/bin/uptime
rm system/bin/vmstat
rm system/bin/watchprops
rm system/bin/wipe
rm system/bin/dumpmesg

find system/csc -type f -name "*.apk" | xargs rm
