#/bin/bash 

while (/bin/true) ; do
  mpirun -n 24 -ppn 24 ./hpcc
  ./parse-hpccoutf.sh  >> hpcc-run.log
  mv hpccoutf.txt ./old/hpccoutf.`date "+%Y%m%d%H%M%S"`
done
