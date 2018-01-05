#!/bin/bash

# sync; echo 3 > /proc/sys/vm/drop_caches
sudo ~/bin/sync-fs.sh

HN=`hostname -s`
FN="/data/wrangler/turnerg/TEST-FILE-${HN}"

bs="1M"
cnt=1024

#for bs in 1M 2M 3M 4M 5M 6M 7M 8M; do
#  for cnt in 1024 2048 4096 8192 16384 32768 65536 131072 ; do

    echo -e "#-----------\nblocksz $bs count $cnt"

    rm -f $FN
    et=`/usr/bin/time dd if=/dev/zero of=$FN  bs=$bs count=$cnt oflag=direct 2>&1`
    et1=`echo $et | grep user | awk '{print $18}' - | sed 's/elapsed//'| awk -F : '{print $1*60+$2}' -`
    et2=`echo $et | grep MB | awk '{print $14,$15}' -`
    sz=`ls -l $FN | awk '{print $5}' -`
    sz1=`ls -lh $FN | awk '{print $5}' -`
    mBps=`echo $sz $et1 | awk '{print "scale=2; "$1/$2/1000000"/1.0"}' -  | bc`
    echo cnt=$cnt blk=$bs sz=$sz1 rate=$mBps mB/s

#  done
#done

exit
