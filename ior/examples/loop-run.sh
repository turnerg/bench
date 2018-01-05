#!/bin/bash
#  -F    filePerProc -- file-per-process
#  -a S  api --  API for I/O [POSIX|MPIIO|HDF5|NCMPI]
#  -B    useO_DIRECT -- uses O_DIRECT for POSIX, bypassing I/O buffers
#  -b N  blockSize -- contiguous bytes to write per task  (e.g.: 8, 4k, 2m, 1g)
#  -o S  testFile -- full name for test
#  -t N  transferSize -- size of transfer in bytes (e.g.: 8, 4k, 2m, 1g)
#  -s N  segmentCount -- number of segments
#  -e    fsync -- perform fsync upon POSIX write close
#  -i N  repetitions -- number of repetitions of test
# 

#for i in `seq -w 35 5 125`; do
for i in `001 002 004 008 016 032 064 128`; do

  echo "  ${i}"
  /usr/lib64/openmpi/bin/mpirun -v -np ${i} -hostfile hostfile \
    --mca pml ob1 --mca btl self,tcp \
    /home/turnerg/bench/ior/2.10.3/src/C/IOR -F -a POSIX -B -b 1m \
    -o /data/wrangler/turnerg3/testFile \
    -t 1m -s 2048 -e -i 5  \
    > run-`date +%y%m%d-%H%M`-1-${i} 

done

echo all done

