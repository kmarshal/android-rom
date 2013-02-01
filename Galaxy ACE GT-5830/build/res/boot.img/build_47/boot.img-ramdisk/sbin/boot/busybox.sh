# magic busybox

# mount system r/w
/sbin/busybox mount -o remount,rw /system;

# make sure we have /system/xbin
/sbin/busybox mkdir -p /system/xbin

# if symlinked busybox in /system/bin or /system/xbin, remove them
LINK=$(/sbin/busybox find /system/bin/busybox -type l);
if /sbin/busybox [ $LINK = "/system/bin/busybox" ]; then
  /sbin/busybox rm -rf /system/bin/busybox;
fi;
LINK=$(/sbin/busybox find /system/xbin/busybox -type l);
if /sbin/busybox [ $LINK = "/system/xbin/busybox" ]; then
  /sbin/busybox rm -rf /system/xbin/busybox;
fi;

# if real busybox in /system/bin or /system/xbin, rename it
if /sbin/busybox [ -f /system/bin/busybox ]; then
  /sbin/busybox mv /system/bin/busybox /system/bin/busybox.backup
fi;
if /sbin/busybox [ -f /system/xbin/busybox ]; then
  /sbin/busybox mv /system/xbin/busybox /system/xbin/busybox.backup
fi;

# make busybox symlink in /system/xbin
/sbin/busybox ln -s /sbin/busybox /system/xbin/busybox

#install busybox in /system/xbin
/system/xbin/busybox --install -s /system/xbin

# openvpn hell
/sbin/busybox rm -rf /system/xbin/bb
/sbin/busybox ln -s /system/xbin /system/xbin/bb

# Create property directory (Factory Reset?)
/sbin/busybox mkdir -p /data/prop
/sbin/busybox chmod 777 /data/prop

# mount system r/o
/sbin/busybox mount -o remount,ro /system;
