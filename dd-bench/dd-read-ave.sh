#!/bin/bash

# sync; echo 3 > /proc/sys/vm/drop_caches
sudo ~/bin/sync-fs.sh

HN=`hostname -s`
FN="/data/wrangler/turnerg/TEST-FILE-${HN}"

ntrials=5
bs="1M"


for cnt in 1024 ; do
#for cnt in 2048 ; do
#for cnt in 1024 2048 4096 8192 16384 32768 65536 131072 ; do
  rm -f $FN
  et=`dd if=/dev/zero of=$FN  bs=$bs count=$cnt oflag=direct 2>&1`
  sudo ~/bin/sync-fs.sh

  for trials in `seq 1 $ntrials` ; do

    #rm -f $FN
    sudo ~/bin/sync-fs.sh
    et=`/usr/bin/time dd if=$FN of=/dev/null  bs=$bs iflag=direct 2>&1`
    et1=`echo $et | grep user | awk '{print $18}' - | sed 's/elapsed//'| awk -F : '{print $1*60+$2}' -`
    mBps2=`echo $et | grep MB | awk '{print $14,$15}' -`
    sz=`ls -l $FN | awk '{print $5}' -`
    mBps=`echo $sz $et1 | awk '{print $1/$2/1000000}' -`  # mega-Bytes/second
    echo $cnt $mBps mB/s

  done
done

exit
