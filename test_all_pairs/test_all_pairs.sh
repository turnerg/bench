#!/bin/bash
# redhat yum install openmpi openmpi-devel

echo -ne "start "
date

np=`wc -l ~/bench/run/hostfile-all.1 | awk '{print $1}' -`

/usr/lib64/openmpi/bin/mpirun -v -np  ${np} -hostfile ~/bench/run/hostfile-all.1  -mca mpi_preconnect_mpi 1 \
     /home/turnerg/bench/net_health/test_all_pairs


echo -ne "done  "
date

