#!/usr/bin/perl
if ( $#ARGV == 0 ) {
  $s=rand($ARGV[0]);
} else {
  $s=rand(1.0);
}
sleep $s;
