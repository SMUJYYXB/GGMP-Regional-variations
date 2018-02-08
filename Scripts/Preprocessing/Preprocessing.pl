#!/usr/bin/perl 
#Author: Huimin Zheng
#Date: 2016.09.18
#Contact: 328093402@qq.com
#Copyright: Hong-Wei Zhou

use warnings;
use strict;

die "perl $0 <fq_dir> <metadata.list> <threads> <output_dir>\n" unless @ARGV==4;

mkdir $ARGV[3];

#Get the location of this script, since it has used other scripts, we need to get the location of all of them
use File::Spec;

my $path_script=File::Spec->rel2abs(__FILE__);
my @path_script=split(/\//,$path_script);
pop @path_script;
my $dir_script=join("/",@path_script);
#Get the location of this script finished

#As fastq files were divided into several parts, do preprocessing for each pairs and merge the bioms.
my @fq = `ls $ARGV[0]/*1.fq`;
foreach my $fq (@fq){
	chomp($fq);
	my @fq_dir = split(/\//,$fq);
	my $fq_name = pop @fq_dir;
	my $fq_dir = join("\/",@fq_dir);
	my @fq_name = split(/1\.fq/,$fq_name);
	`perl $dir_script/Illumina_pairend_preprocessing.pl $fq_dir/$fq_name[0]1.fq $fq_dir/$fq_name[0]2.fq $ARGV[1] $ARGV[2] $ARGV[3]/$fq_name[0]`;
}

#Merge biom for all splitted fastq
open M_LIST,$ARGV[1] or die "can't open $ARGV[1]\n";
while (<M_LIST>)
{
        chomp;
        my @line=split(/\//,$_);
        my @file=split(/\./,$line[-1]);
        my $suffix=pop @file;
        my $exp=join(".",@file);
        mkdir "$ARGV[3]/$exp";
        my @biom_list=`ls $ARGV[3]/*/$exp/$exp.biom`;
	chomp @biom_list;
	my $biom_list=join(",",@biom_list);
	`merge_otu_tables.py -i $biom_list -o $ARGV[3]/$exp/$exp.biom`;
        `biom summarize-table -i $ARGV[3]/$exp/$exp.biom -o $ARGV[3]/$exp/$exp.biom.summary`;
}
close M_LIST;
#Merge biom for all splitted fastq finished

