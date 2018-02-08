#!/usr/bin/perl -w
use strict;
#Author: Hua-Fang Sheng
#Date: 2016.08.08
#Contact: shenghuafang@foxmail.com
#Copyright: Hong-Wei Zhou

if ($#ARGV ne 2)
{
 print "perl $0 <1.fq> <2.fq> <output prefix>\n";
 die;
}

open I,"$ARGV[0]" || die "can not open I:$!";
open II,"$ARGV[1]" || die "can note open II:$!";
my $out1 = "$ARGV[2].1.fq";
my $out2 = "$ARGV[2].2.fq";
open OUT1,">$out1" || die "can not open OUT1:$!";
open OUT2,">$out2" || die "can not open OUT2:$!";

while(<I>)
{
 chomp;
 my $na1 = "$_";
 my $seq1 = substr <I>,0,200;
 my $link1 = <I>;
 my $qul1 = substr <I>,0,200;

 
 my $na2 = <II>;
 chomp $na2;
 my $seq2 = substr <II>,0,200;
 my $link2 = <II>;
 my $qul2 = substr <II>,0,200;
 

 #print "$na1\n$seq1\n$na2\n$seq2\n";die;
 
 print OUT1 "$na1\n$seq1\n$link1$qul1\n";
 print OUT2 "$na2\n$seq2\n$link2$qul2\n";

}
