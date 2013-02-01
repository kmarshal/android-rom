# Mount microSD's second partition for app2sd, try ext4 first
if [ "$(cat /proc/partitions | grep mmcblk0p2)" != "" ]; then
    busybox mount -t ext4 /dev/block/mmcblk0p2 /system/sd
    busybox mount -t ext3 /dev/block/mmcblk0p2 /system/sd
    busybox mount -t ext2 /dev/block/mmcblk0p2 /system/sd
fi;

# Make Dark Tremor's app2sd happy
if [ "$(busybox mount | grep /system/sd)" != "" ]; then
    propset a2sd.mountpoint "/dev/block/mmcblk0p2"
fi;
