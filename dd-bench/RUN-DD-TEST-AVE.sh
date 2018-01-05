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

dt=`date "+%Y%m%d-%H:%M:%S"`
echo -ne "WRITE (min,ave,sd,max) $dt " 
str=`./dd-write-ave.sh | awk '{print $2}' - | ./avesd-minmax.pl`
mn=`echo $str | awk '{print $1}' -`
av=`echo $str | awk '{print "scale=2; "$2"/1.0"}' - | bc`
sd=`echo $str | awk '{print "scale=2; "$3"/1.0"}' - | bc`
mx=`echo $str | awk '{print $4}' -`
echo "$mn $av $sd $mx"

dt=`date "+%Y%m%d-%H:%M:%S"`
echo -ne "READ  (min,ave,sd,max) $dt "
str=`./dd-read-ave.sh  | awk '{print $2}' - | ./avesd-minmax.pl`
mn=`echo $str | awk '{print $1}' -`
av=`echo $str | awk '{print "scale=2; "$2"/1.0"}' - | bc`
sd=`echo $str | awk '{print "scale=2; "$3"/1.0"}' - | bc`
mx=`echo $str | awk '{print $4}' -`
echo "$mn $av $sd $mx"

exit
