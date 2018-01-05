#  Program to analyze the output of test_all_pairs
#  Farid Parpia
#                     Last revised 21 October 2005

/Hosts/ {
  host_a = $2
  split ($4, arr, ":")
  host_b = arr[1]

  count[host_a]++
  count[host_b]++
    ppl[host_a,count[host_a]] = $7
    ppl[host_b,count[host_b]] = $7
   ppbw[host_a,count[host_a]] = $12
   ppbw[host_b,count[host_b]] = $12
    xbw[host_a,count[host_a]] = $17
    xbw[host_b,count[host_b]] = $17
}

END {
  for (host in count) {
     pplsum = 0.;
    ppbwsum = 0.;
     xbwsum = 0.;
    for (i = 1; i <= count[host]; i++) {
       pplsum +=  ppl[host,i]
      ppbwsum += ppbw[host,i]
       xbwsum +=  xbw[host,i]
    }
     pplmean[host] =  pplsum / count[host]
    ppbwmean[host] = ppbwsum / count[host]
     xbwmean[host] =  xbwsum / count[host]
  }

  for (host in count) {
     pplsqdev = 0.;
    ppbwsqdev = 0.;
     xbwsqdev = 0.;
    for (i = 1; i <= count[host]; i++) {
        ppldev =  ppl[host,i] -  pplmean[host]
       ppbwdev = ppbw[host,i] - ppbwmean[host]
        xbwdev =  xbw[host,i] -  xbwmean[host]
       pplsqdev +=  ppldev *  ppldev;
      ppbwsqdev += ppbwdev * ppbwdev;
       xbwsqdev +=  xbwdev *  xbwdev;
    }
     pplstdev[host] = sqrt ( pplsqdev/count[host])
    ppbwstdev[host] = sqrt (ppbwsqdev/count[host])
     xbwstdev[host] = sqrt ( xbwsqdev/count[host])
  }

#  All occurrences of the sort statement (i.e., even those
#  in the close statements) should be identical; chnge the
#  "-k 2" to "-k 3" to sort on the standard deviation

  print "\nPoint-to-point latency,sd:"
  for (host in count)
    printf (" %s %3.2f %3.2f\n", host, pplmean[host], pplstdev[host]) | "sort -n -k 2"
  close("sort -n -k 2")

  print "\nPoint-to-point bandwidth,sd:"
  for (host in count)
    printf (" %s %8.2e %.0f\n", host, ppbwmean[host], ppbwstdev[host]) | "sort -n -k 2"
  close("sort -n -k 2")

  print "\nExchange bandwidth,sd:"
  for (host in count)
    printf (" %s %8.2e %.0f\n", host, xbwmean[host], xbwstdev[host]) | "sort -n -k 2"
  close("sort -n -k 2")
}
