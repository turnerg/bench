#!/bin/bash

which time > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\n    time command not found; please install\n"
  exit 1
fi
which bc > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\n    bc command not found; please install\n"
  exit 1
fi

while (/bin/true) ; do 

  dt=`date "+%Y%m%d-%H:%M:%S"`
  echo -ne "WRITE $dt " 
  ./dd-write.sh

  dt=`date "+%Y%m%d-%H:%M:%S"`
  echo -ne "READ  $dt "
  ./dd-read.sh

done

exit

