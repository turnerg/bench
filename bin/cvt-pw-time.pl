#!/usr/bin/perl

if ( @ARGV[0] ne "" ) {
  $t1=(@ARGV[0]+1)*24*60*60+4*60*60;
  $t=localtime($t1);
  print "$t\n";
} else {
  while (<>) {
    $t1=($_+1)*24*60*60+4*60*60;
    $t=localtime($t1);
    print "$t\n";
  }
}

