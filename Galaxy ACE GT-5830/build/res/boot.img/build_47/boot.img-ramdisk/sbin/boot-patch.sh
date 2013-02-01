#!/sbin/busybox sh

echo 1 > /sys/class/leds/button-backlight/brightness
/sbin/busybox sh /sbin/boot/busybox.sh
/sbin/busybox sh /sbin/boot/sdext.sh
/sbin/busybox sh /sbin/boot/install.sh
/sbin/busybox sh /sbin/boot/properties.sh
#/sbin/busybox sh /sbin/boot/app2sd.sh
/sbin/busybox sh /sbin/boot/ext4speed.sh
/sbin/busybox sh /sbin/boot/tweaks.sh
/sbin/busybox sh /sbin/boot/scripts.sh
echo 0 > /sys/class/leds/button-backlight/brightness

read sync < /data/sync_fifo
rm /data/sync_fifo

setprop cfroot.ready 1
