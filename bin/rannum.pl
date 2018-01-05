#!/usr/bin/perl
if ( $#ARGV == 0 ) {
  print rand($ARGV[0]),"\n";
} else {
  print rand(1.0),"\n";
}

