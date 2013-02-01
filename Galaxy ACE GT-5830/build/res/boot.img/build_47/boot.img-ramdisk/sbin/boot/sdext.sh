# marshal
# Mount microSD's second partition try ext4 first
if [ "$(cat /proc/partitions | grep mmcblk0p2)" != "" ]; then
    busybox mount -t ext4 /dev/block/mmcblk0p2 /mnt/sd-ext
    busybox mount -t ext3 /dev/block/mmcblk0p2 /mnt/sd-ext
    busybox mount -t ext2 /dev/block/mmcblk0p2 /mnt/sd-ext
fi;
