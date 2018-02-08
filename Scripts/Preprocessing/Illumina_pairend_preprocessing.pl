#!/usr/bin/perl 
#Author: Yan He
#Date: 2016.08.08
#Contact: 197053351@qq.com or bioyanhe@gmail.com
#Copyright: Hong-Wei Zhou

use warnings;
use strict;

die "perl $0 <1.fq> <2.fq> <metadata.list> <threads> <output_dir>\n" unless @ARGV==5;

mkdir $ARGV[4];

#Get the location of this script, since it has used other scripts, we need to get the location of all of them
use File::Spec;

my $path_script=File::Spec->rel2abs(__FILE__);
my @path_script=split(/\//,$path_script);
pop @path_script;
my $dir_script=join("/",@path_script);
#Get the location of this script finished

#Prepare the parameters file for clustering
#Note that a precalculated database for SortMeRNA is required, if you don't have one, do:
#cd where_you_put_this_script 
#indexdb_rna --ref /usr/local/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta,./97_otus.idx -v
#mkdir sortmerna_db/
#mv 97_otus.idx* sortmerna_db
mkdir "$ARGV[4]/tmp";
open OUT,">$ARGV[4]/tmp/params.closedref.txt";
print OUT "
pick_otus:otu_picking_method\tusearch61_ref
pick_otus:similarity\t0.97
pick_otus:db_filepath\t/usr/local/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta
";
#pick_otus:sortmerna_db\t$dir_script/sortmerna_db/97_otus.idx
#";

close OUT;
#Prepare the parameters file for clustering, finished

#Split files into mutiple 
mkdir "$ARGV[4]/tmp/split";
my $file_lines=`wc -l $ARGV[0]`;#How many lines in this fastq file?
$file_lines=~s/ .*//g;

my $split_lines=int($file_lines/$ARGV[3])+1;#So each file shall contain approximately $split_lines lines

#Nevertheless, since we are splitting fastq file, we don't want the information of one sequence (four lines) to be splitted into different files
while (1)
{
	last if $split_lines/4 == int($split_lines/4);
	$split_lines++;
}

`split -l $split_lines $ARGV[0] $ARGV[4]/tmp/split/tmp.1.`;#Split the fastq into multiple fastq file with $split_lines sequences per sample
`split -l $split_lines $ARGV[1] $ARGV[4]/tmp/split/tmp.2.`;#So is the paired one

my @list=`ls $ARGV[4]/tmp/split/tmp.1.*`;
#Split files into mutiple finished

#Start processing each pair of fastq
use threads;
use threads::shared;

mkdir "$ARGV[4]/tmp/join_quality_control";
my $thread_num = 0;

#open TMP_DIR,">$ARGV[4]/tmp_dir.list";
foreach my $file1(@list)
{
	chomp $file1;
	my @file1=split(/\./,$file1);
	$file1[-2]=2;
	my $file2=join(".",@file1);

	if ($thread_num >= $ARGV[3]) #control the threads of parallel running                                                             
        {       
                for my $t (threads->list(threads::joinable))                                                                        
                {       
                        $t->join();
                        $thread_num--;                                                                                              
                }
        	redo;
	} 
	#We have created a subroute "merge_control" to process each pair of fastq file, from raw fastq to biom
	threads->create(\&merge_control,"$file1","$file2","$ARGV[4]/tmp/join_quality_control/tmp.$file1[-1]"); 
	$thread_num++;
}

#join rest threads                                                                                                                  
for my $t (threads->list())                                                                                                         
{                                                                                                                                   
    $t->join();                                                                                                                     
}
#Processing each pair of fastq, finished

#Merge biom for all splitted fastq
mkdir "$ARGV[4]/tmp/biom";
my @biom_list=`ls $ARGV[4]/tmp/join_quality_control/tmp.*/split_libraries/otus/otu_table.biom`;
chomp @biom_list;
my $biom_list=join(",",@biom_list);
`merge_otu_tables.py -i $biom_list -o $ARGV[4]/tmp/biom/total.biom`;
#Merge biom for all splitted fastq finished

#If we have multiple experiments (multiple metadata in metadata.list), split them into different biom
open IN,$ARGV[2] or die "can't open $ARGV[2]\n";
while (<IN>)
{
	chomp;
	my @line=split(/\//,$_);
	my @file=split(/\./,$line[-1]);
	my $suffix=pop @file;
	my $exp=join(".",@file);
	mkdir "$ARGV[4]/$exp";
	`filter_samples_from_otu_table.py -i $ARGV[4]/tmp/biom/total.biom -o $ARGV[4]/$exp/$exp.biom -m $_ --sample_id_fp $_ --output_mapping_fp $ARGV[4]/$exp/$exp.metadata.txt`;
	`biom summarize-table -i $ARGV[4]/$exp/$exp.biom -o $ARGV[4]/$exp/$exp.biom.summary`
}
close IN;
#Split experiments finished

#Delete intermediate files, but if you want to retain them, annotate this command
#`rm -r $ARGV[4]/tmp/`;
#Delete intermediate files finished

#This is what we have done for each pair of fastq
sub merge_control{
	my @file=split(/\//,$_[2]);
	#Trim the fastq file to 200bp, this can reduce the computational burden while using enough information to do overlapping
	`perl $dir_script/trim_200bp.pl $_[0] $_[1] $ARGV[4]/tmp/split/$file[-1]`;
	`rm $_[0] $_[1]`;
	#Overlap paired fastq file
	`sh $dir_script/bbmap/reformat.sh in=$ARGV[4]/tmp/split/$file[-1].1.fq out=$ARGV[4]/tmp/split/$file[-1].1.33.fq qin=64 qout=33`;
	`sh $dir_script/bbmap/reformat.sh in=$ARGV[4]/tmp/split/$file[-1].2.fq out=$ARGV[4]/tmp/split/$file[-1].2.33.fq qin=64 qout=33`;
	`join_paired_ends.py -f $ARGV[4]/tmp/split/$file[-1].1.33.fq -r $ARGV[4]/tmp/split/$file[-1].2.33.fq -o $_[2] -m SeqPrep`;
#	`gunzip $_[2]/seqprep_assembled.fastq.gz`;
	`mv $_[2]/seqprep_assembled.fastq.gz $_[2]/$file[-1].fq.gz`;
	#Quality control using QIIME. Since we don't want QIIME to do library splitting, add --barcode_type 'not-barcoded'
	`split_libraries_fastq.py -i $_[2]/$file[-1].fq.gz -o $_[2]/ --sample_ids $file[-1] -q 19 --barcode_type 'not-barcoded' --phred_offset 33`;
	#We wrote a script to do library splitting, as we have barcodes on both ends which is not quite supported by QIIME at the moment (QIIME 1.9.1)
	`perl $dir_script/pairend.extract_sequences.pl $_[2]/seqs.fna $ARGV[2] $_[2]/split_libraries`;
	#Use sortmerna to do closed-reference OTU clustering, and a biom is finally generated, note that chimera checking is also embedded in this workflow script
	`pick_closed_reference_otus.py -i $_[2]/split_libraries/split_libraries.fa -o $_[2]/split_libraries/otus -p $ARGV[4]/tmp/params.closedref.txt`;
}

