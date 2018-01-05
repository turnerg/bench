#!/bin/bash

echo ping test started

for i in `awk '{print $1}' ~turnerg/bench/run/hostfile-166.1 | head -64` 
do 
  #echo ${i}
  ping -c 1 -t 1 -q ${i} > /dev/null 2>& 1
  if [ $? -ne 0 ]; then 
    echo ${i} no ping
  fi
done 

echo -e ping test completed "\007"
