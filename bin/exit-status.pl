#!/usr/bin/perl

my $syscmd = "@ARGV";
#print qq($syscmd\n);
#exit;

system($syscmd);
$retstat  = $?;
$sysstat  = $retstat >> 8;
$syssig   = $retstat & 0x7f;
$syscored = $retstat & 0x80;
if ( $sysstat != 0 ) {
  print "\n";
  print "Error on command: $syscmd\n";
  print "Error Return=$retstat Status=$sysstat Signal=$syssig CoreDumped=$syscored\n";
  print "\n";
  exit $retstat;
  #die "Stopped";
}

