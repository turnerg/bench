#!/usr/bin/perl

if ( @ARGV[0] ne "" ) {
  $t=localtime(@ARGV[0]);
  print "$t\n";
} else {
  while (<>) {
    $t=localtime($_);
    print "$t\n";
  }
}

