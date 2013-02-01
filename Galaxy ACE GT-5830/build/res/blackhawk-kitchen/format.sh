#!/sbin/busybox sh

# Ketut Putu Kumajaya, Jan 2012
# taken from ext4 tools script, copyright Chainfire

OUTFD=$(ps | grep -v "grep" | grep -o -E "update_binary(.*)" | cut -d " " -f 3);

progress() {
  if [ $OUTFD != "" ]; then
    echo -e "progress ${1} ${2} " 1>&$OUTFD;  
  fi;
}

set_progress() {
  if [ $OUTFD != "" ]; then
    echo -e "set_progress ${1} " 1>&$OUTFD;  
  fi;
}

ui_print() {
  if [ $OUTFD != "" ]; then
    echo "ui_print ${1} " 1>&$OUTFD;
    echo "ui_print " 1>&$OUTFD;
  else
    echo "${1}";
  fi;
}

format_to_ext4() {
  MOUNTPOINT=${1};
  BLOCKDEV=${2};
  SIZE=${3};
  EXTRA=${4};

  cd /;
  umount $MOUNTPOINT;
  /tmp/mkfs.ext4 -T ext4 -b 4096 -m 0 -J size=$SIZE -O ^resize_inode,^ext_attr,^huge_file$EXTRA $BLOCKDEV;
  /sbin/tune2fs -c 100 -i 100d -m 0 $BLOCKDEV;
  sync;
}

progress 0.25 300;
ui_print "Formating /system";
format_to_ext4 "/system" "/dev/block/stl12" "4" ",^has_journal"
set_progress 0.50;
  
progress 0.25 300;
ui_print "Formating /data";
format_to_ext4 "/data" "/dev/block/stl13" "16" ",^has_journal"
set_progress 0.75;

progress 0.25 300;
ui_print "Formating /cache";
format_to_ext4 "/cache" "/dev/block/stl14" "4" ",^has_journal"
set_progress 1.00;

#progress 0.25 300;
#ui_print "Formating /sd-ext";
#format_to_ext4 "/sd-ext" "/dev/block/mmcblk0p2" "16" ""
#set_progress 1.00; 

ui_print "Formating done !";

# system --> data=journal, not supported
# cache --> data=writeback, not supported
