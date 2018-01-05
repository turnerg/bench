#!/usr/bin/perl
my $sum = 0;

while (<>) {
  chomp();
  #print "$_\n";
  $sum += $_;
}
print "$sum\n";
exit;

