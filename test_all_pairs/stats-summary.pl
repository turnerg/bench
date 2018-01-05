#!/usr/bin/perl -w
use Carp;
use strict;
use lib "$ENV{HOME}/perl/lib/perl5/site_perl/5.8.8";
use Statistics::Descriptive;

my ($ha,  $hb,  $lat,  $bw,  $ebw);  # hosta, hostb, latency, bandwidth, exchange_bandwidth
my (@haa, @hba, @lata, @bwa, @ebwa);
my $co=2.5;  # cutoff for error testing

#'Hosts p85 and p86: latency = 45.4273 micro s; bandwidth =  123.64 MB/s; exchange bandwidth =  123.70 MB/s.';

my $latstat = Statistics::Descriptive::Full->new();
my $bwstat  = Statistics::Descriptive::Full->new();
my $ebwstat = Statistics::Descriptive::Full->new();

while (<>) {
  next if ! /exchange bandwidth/;
  chomp($_);
  my @str=split(" ",$_);
  push @haa, $str[1];
  $str[3]=~s/://;
  push @hba, $str[3];
  push @lata,$str[6]; 
  push @bwa, $str[11];
  push @ebwa,$str[16];
  #print "$haa[$#haa] $hba[$#hba] $lata[$#lata] $bwa[$#bwa] $ebwa[$#ebwa]\n";
}
$latstat->add_data(@lata);
$bwstat->add_data(@bwa);
$ebwstat->add_data(@ebwa);

my $total=$#haa+1;
print "total entries = $total\n";
# skew     : zero is no skew, negative is a left skewed tail, positive is a right skewed tail
# kurtosis : positive is peaked, negative is flattened
 
my $latcnt=$latstat->count(); 
my $latmean=$latstat->mean();
my $latsd=$latstat->standard_deviation();
my $latskew=$latstat->skewness();
my $latkurt=$latstat->kurtosis();
my $latmode=$latstat->mode();
my $latmedian=$latstat->median();
print "\nLatency units = uSec\n";
printf "lat count    = %8d\n",$latcnt;
printf "lat mean, sd = %8.2f %8.2f %8.2f %8.2f\n",$latmean,$latsd,$latskew,$latkurt;
printf "lat median   = %8.2f\n",$latmedian;
#printf "lat mode     = %8.2f\n",$latmode;
my $latamin=$latstat->min();
my $latamax=$latstat->max();
print "Latency min, max = $latamin $latamax\n";
my $latco=$latsd*$co;
print "Latency cutoff is $co * $latsd = $latco\n";
my $latcomin=$latmean-$latco;
my $latcomax=$latmean+$latco;
print "$latcomin   $latmean   $latcomax\n";
for ( my $i = 0 ; $i <= $#lata ; $i++) {
  if (abs($latmean-$lata[$i]) > $latco ) { print "$haa[$i]\t$hba[$i]\t$lata[$i]\n" }
}

my $bwcnt=$bwstat->count(); 
my $bwmean=$bwstat->mean();
my $bwsd=$bwstat->standard_deviation();
my $bwskew=$bwstat->skewness();
my $bwkurt=$bwstat->kurtosis();
my $bwmode=$bwstat->mode();
my $bwmedian=$bwstat->median();
print "\nBandwidth units = MB/s\n";
printf "bw count     = %8d\n",$bwcnt;
printf "bw mean, sd  = %8.2f %8.2f %8.2f %8.2f\n",$bwmean,$bwsd,$bwskew,$bwkurt;
printf "bw median    = %8.2f\n",$bwmedian;
#printf "bw mode      = %8.2f\n",$bwmode;
my $bwamin=$bwstat->min();
my $bwamax=$bwstat->max();
print "Bandwidth min, max = $bwamin $bwamax\n";
my $bwco=$bwsd*$co;
print "Bandwidth cutoff is $co * $bwsd = $bwco\n";
my $bwcomin=$bwmean-$bwco;
my $bwcomax=$bwmean+$bwco;
print "$bwcomin   $bwmean   $bwcomax\n";
for ( my $i = 0 ; $i <= $#bwa ; $i++) {
  if (abs($bwmean-$bwa[$i]) > $bwco ) { print "$haa[$i]\t$hba[$i]\t$bwa[$i]\n" }
}

my $ebwcnt=$ebwstat->count(); 
my $ebwmean=$ebwstat->mean();
my $ebwsd=$ebwstat->standard_deviation();
my $ebwskew=$ebwstat->skewness();
my $ebwkurt=$ebwstat->kurtosis();
my $ebwmode=$ebwstat->mode();
my $ebwmedian=$ebwstat->median();
print "\nExchange bandwidth units = MB/s\n";
printf "ebw count    = %8d\n",$ebwcnt;
printf "ebw mean, sd = %8.2f %8.2f %8.2f %8.2f\n",$ebwmean,$ebwsd,$ebwskew,$ebwkurt;
printf "ebw median   = %8.2f\n",$ebwmedian;
#printf "ebw mode     = %8.2f\n",$ebwmode;
my $ebwamin=$ebwstat->min();
my $ebwamax=$ebwstat->max();
print "Exchange bandwidth min, max = $ebwamin $ebwamax\n";
my $ebwco=$ebwsd*$co;
print "Exchange bandwidth cutoff is $co * $ebwsd = $ebwco\n";
my $ebwcomin=$ebwmean-$ebwco;
my $ebwcomax=$ebwmean+$ebwco;
print "$ebwcomin   $ebwmean   $ebwcomax\n";
for ( my $i = 0 ; $i <= $#ebwa ; $i++) {
  if (abs($ebwmean-$ebwa[$i]) > $ebwco ) { print "$haa[$i]\t$hba[$i]\t$ebwa[$i]\n" }
}



exit;

