#!/usr/bin/perl
use List::Util qw(min max);
my @nums =  ();
my $sum = 0;

while (<>) {
  chomp();
  #print "$_\n";
  $sum += $_;
  push @nums, $_ ;
}
my $npts=$#nums + 1;
my $ave = $sum / $npts;
#print "$npts @nums $sum\n";

my $var=0;
my $ep=0;
for (my $i=0; $i < $npts ; $i++ ) {
  $s = $nums[$i];
  #print "$i $s\n";
  $ep += $s ;
  $var += $s*$s;
}
$var = ($var - $ep*$ep/$npts)/($npts-1);
my $sd=sqrt($var);
my $min=min(@nums);
my $max=max(@nums);


print "$min $ave $sd $max\n";

exit;

