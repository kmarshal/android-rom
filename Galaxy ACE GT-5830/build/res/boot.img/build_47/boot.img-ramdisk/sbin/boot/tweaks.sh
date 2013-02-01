TWEAK_BASE="persist.tweak";

TWEAK_IO="$TWEAK_BASE.ioscheduler";
TWEAK_NOATIME="$TWEAK_BASE.noatime";
TWEAK_VM_SWAPPINESS="$TWEAK_BASE.vm.swappiness";
TWEAK_VM_DIRTY="$TWEAK_BASE.vm.dirty";
TWEAK_SCHEDULER="$TWEAK_BASE.scheduler";
TWEAK_MINFREE="$TWEAK_BASE.minfree";
TWEAK_SDCARD="$TWEAK_BASE.sdcard";

TWEAK_STAGEFRIGHT="$TWEAK_BASE.stagefright";
TWEAK_GOVERNOR_CONSERVATIVE="$TWEAK_BASE.gov_conservative";
TWEAK_SCHEDULER_DEADLINE="$TWEAK_BASE.sched_deadline";
TWEAK_DTA2SD="$TWEAK_BASE.dta2sd";

for i in $TWEAK_IO $TWEAK_NOATIME $TWEAK_VM_DIRTY $TWEAK_MINFREE $TWEAK_SDCARD; do
  if [ "$(propget $i)" = "" ]; then
    propset $i enabled;
  fi;
done;

for i in $TWEAK_STAGEFRIGHT $TWEAK_GOVERNOR_CONSERVATIVE $TWEAK_SCHEDULER_DEADLINE $TWEAK_DTA2SD $TWEAK_VM_SWAPPINESS; do
  if [ "$(propget $i)" = "" ]; then
    propset $i disabled;
  fi;
done;

# Not working on Samsung Galaxy Ace
propset $TWEAK_SCHEDULER disabled

# Disable DT a2sd on boot for now 
#propset $TWEAK_DTA2SD disabled

if [ $(propget $TWEAK_IO) = "enabled" ]; then
  # Tweak cfq io scheduler
  for i in $(ls -1 /sys/block/stl*) $(ls -1 /sys/block/mmc*)
  do 
    echo "0" > $i/queue/rotational
 #   echo "1" > $i/queue/iosched/low_latency
 #   echo "1" > $i/queue/iosched/back_seek_penalty
 #   echo "1000000000" > $i/queue/iosched/back_seek_max
 #   echo "2" > $i/queue/iosched/slice_idle
  done
fi;

if [ $(propget $TWEAK_SCHEDULER_DEADLINE) = "enabled" ]; then
  # use deadline scheduler
  echo deadline > /sys/class/block/mmcblk0/queue/scheduler
  echo deadline > /sys/class/block/stl14/queue/scheduler
  echo deadline > /sys/class/block/stl13/queue/scheduler
  echo deadline > /sys/class/block/stl12/queue/scheduler
  echo 8 > /sys/class/block/mmcblk0/queue/iosched/fifo_batch
  echo 8 > /sys/class/block/stl14/queue/iosched/fifo_batch
  echo 8 > /sys/class/block/stl13/queue/iosched/fifo_batch
  echo 8 > /sys/class/block/stl12/queue/iosched/fifo_batch
  echo 400 > /sys/class/block/mmcblk0/queue/iosched/read_expire
  echo 400 > /sys/class/block/stl14/queue/iosched/read_expire
  echo 400 > /sys/class/block/stl13/queue/iosched/read_expire
  echo 400 > /sys/class/block/stl12/queue/iosched/read_expire
  echo 4 > /sys/class/block/mmcblk0/queue/iosched/writes_starved
  echo 4 > /sys/class/block/stl14/queue/iosched/writes_starved
  echo 4 > /sys/class/block/stl13/queue/iosched/writes_starved
  echo 4 > /sys/class/block/stl12/queue/iosched/writes_starved
fi;

if [ $(propget $TWEAK_NOATIME) = "enabled" ]; then
  # Remount all partitions with noatime, nodiratime
  for k in $(busybox mount | grep relatime | cut -d " " -f3)
  do
    sync;
    busybox mount -o remount,noatime,nodiratime $k;
  done
fi;

if [ $(propget $TWEAK_SDCARD) = "enabled" ]; then
  # SDcard speed tweak
  for i in $(ls -1 /sys/devices/platform/msm_sdcc.*/mmc_host/mmc*/mmc*/block/*/queue/read_ahead_kb); do 
    echo 3072 > $i; 
  done;
fi;

if [ $(propget $TWEAK_VM_SWAPPINESS) = "enabled" ]; then
  # Tweak kernel VM management
  echo "0" > /proc/sys/vm/swappiness
fi;

if [ $(propget $TWEAK_VM_DIRTY) = "enabled" ]; then
  # Miscellaneous tweaks
  echo "2000" > /proc/sys/vm/dirty_writeback_centisecs
  echo "1000" > /proc/sys/vm/dirty_expire_centisecs
  echo "90" > /proc/sys/vm/dirty_ratio
  echo "5" > /proc/sys/vm/dirty_background_ratio
  echo "1" > /proc/sys/vm/vfs_cache_pressure
fi;

# Not working on Samsung Galaxy Ace
#if [ $(propget $TWEAK_SCHEDULER) = "enabled" ]; then
  # Tweak kernel scheduler
  #echo "18000000" > /proc/sys/kernel/sched_latency_ns
  #echo "3000000" > /proc/sys/kernel/sched_wakeup_granularity_ns
  #echo "1500000" > /proc/sys/kernel/sched_min_granularity_ns
#fi;

if [ $(propget $TWEAK_MINFREE) = "enabled" ]; then
  if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
    echo "2560,4096,6144,17408,19456,23552" > /sys/module/lowmemorykiller/parameters/minfree
  fi;
fi;

if [ $(propget $TWEAK_STAGEFRIGHT) = "enabled" ]; then
  setprop media.stagefright.enable-player true;
fi;

