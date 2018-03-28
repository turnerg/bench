#/bin/bash 

headers='^HPL_Tflops=
^StarDGEMM_Gflops= 
^SingleDGEMM_Gflops= 
^PTRANS_GBs= 
^StarRandomAccess_LCG_GUPs= 
^SingleRandomAccess_LCG_GUPs= 
^StarRandomAccess_GUPs= 
^SingleRandomAccess_GUPs= 
^StarSTREAM_Copy= 
^StarSTREAM_Scale= 
^StarSTREAM_Add= 
^StarSTREAM_Triad= 
^SingleSTREAM_Copy= 
^SingleSTREAM_Scale= 
^SingleSTREAM_Add= 
^SingleSTREAM_Triad= 
^StarFFT_Gflops= 
^SingleFFT_Gflops= 
^MPIFFT_Gflops= 
^MinPingPongLatency_usec= 
^AvgPingPongLatency_usec= 
^MaxPingPongBandwidth_GBytes= 
^AvgPingPongBandwidth_GBytes='


for i in ${headers} ; do
  o=`grep ${i} hpccoutf.txt | awk -F= '{print$2}' -`
  echo -ne "${o},"
done
date "+%Y%m%d%H%M%S"

