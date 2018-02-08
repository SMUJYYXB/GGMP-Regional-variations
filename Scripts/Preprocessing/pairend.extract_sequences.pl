#!/usr/bin/perl -w
use strict;
#Author: Yan He
#Date: 2016.08.08
#Contact: 197053351@qq.com or bioyanhe@gmail.com
#Copyright: Hong-Wei Zhou

die "perl $0 <fasta> <metadata.list> <output_dir>\n" unless @ARGV==3;

mkdir $ARGV[2];

#Read in metadata and document barcodes in %barcode;
open IN,$ARGV[1] or die "can't open $ARGV[1]\n";
my %barcode;

#We used GTGTGYCAGCMGCCGCGGTAA for 16S rRNA gene V4 forward primers, Y stands for [C|T], M stands for [A|C]
my $v4_forward_primer="GTGTG[C|T]CAGC[A|C]GCCGCGGTAA";
#We used CCGGACTACNVGGGTWTCTAAT for 16S rRNA gene V4 reverse primers, N stands for [A|T|G|C], V stands for [A|G|C], W stands for [A|T]
my $v4_reverse_primer="CCGGACTAC[A|T|G|C][A|G|C]GGGT[A|T]TCTAAT";

#Reverse/complement reverse primer
my $v4_reverse_primer2=reverse $v4_reverse_primer;
$v4_reverse_primer2=~tr/ATGC[]/TACG][/;

#Document barcode information from metadata in %barcode, remember that <IN> is the path of all metadata, not one metadata
while (<IN>)
{
	chomp;

	#Get the name of this experiment, store it in $exp_name
	my @line=split(/\./);
	my $suffix=pop @line;
	my $exp_name=join(".",@line);
	
	#Read the content of the metadata of this experiment, through <MAP>
	open MAP,$_;
	my $map_first=<MAP>;
	chomp $map_first;
	my @map_first=split(/\t/,$map_first);
	
	#Figure out in which column the barcode is documented
	my $forward_barcode_index=-1;
	my $reverse_barcode_index=-1;

	foreach my $i(0..$#map_first)
	{
		$forward_barcode_index=$i if $map_first[$i] eq "Forward_Barcode";
		$reverse_barcode_index=$i if $map_first[$i] eq "Reverse_Barcode";
	}

	if ($forward_barcode_index == -1)
        {
                print "Forward_Barcode not found in $_\n";
                exit(1);
        }

	if ($reverse_barcode_index == -1)
        {
                print "Reverse_Barcode not found in $_\n";
                exit(1);
        }
	
	#For each sample, we document its barcode information in %barcode
	while (my $map_line=<MAP>)
	{
		chomp $map_line;
		my @map_line=split(/\t/,$map_line);
		
		my $forward_barcode=$map_line[$forward_barcode_index];
		my $reverse_barcode=$map_line[$reverse_barcode_index];
		
		my $reverse_barcode2=reverse $reverse_barcode;
		$reverse_barcode2=~tr/ATGC/TACG/;
		
		$barcode{"$forward_barcode$reverse_barcode2"}=$map_line[0];
	}
	close MAP;
}
close IN;
#Document barcode information from metadata in %barcode, finished

#extract sequences of each sample according to barcodes;
open IN,$ARGV[0] or die "can't open $ARGV[0]\n";#Read in the raw fasta file;
open OUT,">$ARGV[2]/split_libraries.fa";#Output

my %sequences_num;#How many sequences were extracted from each sample? document this information in %sequences_num

I:while (my $fq_name=<IN>)
{
	my $fq_seq=<IN>;
	chomp $fq_seq;
	
	#We use regular expression to locate primers in each sequence
	if ($fq_seq=~/(.*)$v4_forward_primer(.*)$v4_reverse_primer2(.*)/)#The three (.*) is used to capture forward barcode, target sequence and reverse barcode respectively
	{
		my $barcode=$1.$3;
		my $sequence=$2;	
		if (exists $barcode{$barcode} and length($sequence) >= 200)#If this capture barcode do exist in our documented barcode from metadata, name it to that sample
		{
			$sequences_num{$barcode{$barcode}}++;#We got one more sequence for this sample, good!
			print OUT ">",$barcode{$barcode},"_",$sequences_num{$barcode{$barcode}},"\n$sequence\n";#Output this sequence
		}
	}else{
		#Maybe this sequence is not in the right direction, reverse/complement it and try again!
		my $fq_seq_reverse=reverse $fq_seq;
		$fq_seq_reverse=~tr/ATGC/TACG/;
		if ($fq_seq_reverse=~/(.*)$v4_forward_primer(.*)$v4_reverse_primer2(.*)/)
        	{
                	my $barcode=$1.$3;
                	my $sequence=$2;

                	if (exists $barcode{$barcode} and length($sequence) >= 200)
                	{
			$sequences_num{$barcode{$barcode}}++;
                        print OUT ">",$barcode{$barcode},"_",$sequences_num{$barcode{$barcode}},"\n$sequence\n";
			}
        	}
	}
}

close IN;
close OUT;
