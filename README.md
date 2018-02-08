# GGMP-Regional variations

## Introduction
Analysis pipeline for GGMP-Regional variations

### Copyright
       Copyright:     Prof. Hong-Wei Zhou   
     Institution:     State Key Laboratory of Organ Failure Research, Division of Laboratory Medicine, Zhujiang Hospital, Southern Medical University, Guangzhou, China, 510282   
           Email:     biodegradation@gmail.com   

      
### Author
         Author:     Hui-Min Zheng, Pan Li, Xian Wang and Yan He    
    Last update:     2018-02-08   
          Email:     328093402@qq.com   
      
### Index
--------------------------------------------------------
1 Environment   
    1.1 System   
        1.1.1 System Platform   
        1.1.2 Hardware    
    1.2 Qiime   
        1.2.1 Qiime version   
        1.2.2 System information   
        1.2.3 QIIME default reference information   
        1.2.4 QIIME config values   
    1.3 BBMap   
    
2 Data   
    2.1 original sequences    
    
3 Scripts   
    3.1 Perl Scripts   
      
4 Direction for use    
    4.1 Configuring the system environment files and variables    
    4.2 Location of the files    
    4.3 Run pipeline

5 How to get the data?   
    6.1 How to get the original sequences?   
    

# 1 Environment
## 1.1 System
-------------------------------------------------------
### 1.1.1 System Platform
-------------------------------------------------------
    Platform:      Linux2 
     Version:      Linux version 2.6.32-573.8.1.el6.x86_64 (mockbuild@c6b8.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-16)(GCC))
          OS:      CentOS release 6.7 (Final)
--------------------------------------------------------
### 1.1.2 Hardware
--------------------------------------------------------
         Cpu(s):      >10
         thread:      >10
            RAM:      >10G
      Hard disk:      >2T
--------------------------------------------------------
## 1.2 Qiime
--------------------------------------------------------
### 1.2.1 Qiime version
--------------------------------------------------------
      Version:      qiime 1.9.1
--------------------------------------------------------
### 1.2.2 System information
--------------------------------------------------------
               Platform:      Linux2
         Python version:      2.7.10 (default, Dec  4 2015, 15:36:19)  [GCC 4.4.7 20120313 (Red Hat 4.4.7-16)]
      Python executable:      /usr/local/bin/python
--------------------------------------------------------
### 1.2.3 QIIME default reference information
--------------------------------------------------------
    For details on what files are used as QIIME's default references, see here:
    https://github.com/biocore/qiime-default-reference/releases/tag/0.1.3
--------------------------------------------------------
              QIIME library version:      1.9.1
               QIIME script version:      1.9.1
    qiime-default-reference version:      0.1.3
                      NumPy version:      1.11.0
                      SciPy version:      0.17.1
                     pandas version:      0.17.1
                 matplotlib version:      1.4.3
                biom-format version:      2.1.5
                       qcli version:      0.1.1
                       pyqi version:      0.3.2
                 scikit-bio version:      0.2.3
                     PyNAST version:      1.2.2
                    Emperor version:      0.9.51
                    burrito version:      0.9.1
           burrito-fillings version:      0.1.1
                  sortmerna version:      SortMeRNA version 2.0, 29/11/2014
                  sumaclust version:      SUMACLUST Version 1.0.00
                      swarm version:      Swarm 1.2.19 [Dec  5 2015 16:48:11]
                              gdata:      Installed.
--------------------------------------------------------
### 1.2.4 QIIME config values
--------------------------------------------------------
    For definitions of these settings and to learn how to configure QIIME, see here:
    http://qiime.org/install/qiime_config.html
    http://qiime.org/tutorials/parallel_qiime.html

    QIIME config values

    For definitions of these settings and to learn how to configure QIIME, see here:
    http://qiime.org/install/qiime_config.html
    http://qiime.org/tutorials/parallel_qiime.html

                          blastmat_dir:      None
           pick_otus_reference_seqs_fp:      /usr/local/lib/python2.7/sitepackages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta
                         python_exe_fp:      python
                              sc_queue:      all.q
           topiaryexplorer_project_dir:      None
          pynast_template_alignment_fp:      /usr/local/data/core_set_aligned.fasta.imputed
                       cluster_jobs_fp:      None
     pynast_template_alignment_blastdb:      None
     assign_taxonomy_reference_seqs_fp:      /usr/local/lib/python2.7/sitepackages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta
                          torque_queue:      friendlyq
                   qiime_test_data_dir:      None
        template_alignment_lanemask_fp:      /usr/local/data/lanemask_in_1s_and_0s.txt
                         jobs_to_start:      1
                            slurm_time:      None
                     cloud_environment:      False
                     qiime_scripts_dir:      /usr/local/bin
                 denoiser_min_per_core:      50
                           working_dir:      None
     assign_taxonomy_id_to_taxonomy_fp:      /usr/local/lib/python2.7/sitepackages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt
                              temp_dir:      /tmp/
                          slurm_memory:      None
                           slurm_queue:      None
                           blastall_fp:      blastall
                      seconds_to_sleep:      2
--------------------------------------------------------
## 1.3 BBMap
-------------------------------------------------------
    BBTools bioinformatics tools, including BBMap.
    Author: Brian Bushnell, Jon Rood
    Language: Java
    Version 36.32
--------------------------------------------------------

# 2 Data
--------------------------------------------------------
## 2.1 original sequences
--------------------------------------------------------
     format of sequences :      fastq
       Number of fq files:      36
             fq_filenames:      1.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_1.fq
                                1.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_2.fq
                                1.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_1.fq
                                1.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_2.fq
                                1.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_1.fq
                                1.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_2.fq
                                1.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_1.fq
                                1.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_2.fq
                                2.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_1.fq
                                2.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_2.fq
                                2.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_1.fq
                                2.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_2.fq
                                2.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_1.fq
                                2.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_2.fq
                                2.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_1.fq
                                2.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_2.fq
                                3.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_1.fq
                                3.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_2.fq
                                3.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_1.fq
                                3.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_2.fq
                                3.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_1.fq
                                3.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_2.fq
                                3.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_1.fq
                                3.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_2.fq
                                4.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_1.fq
                                4.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_2.fq
                                4.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_1.fq
                                4.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_2.fq
                                4.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_1.fq
                                4.Clean_FCHVTWCBCXX_L1_wHAXPI034526-108_2.fq
                                4.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_1.fq
                                4.Clean_FCHVTWCBCXX_L2_wHAXPI034526-108_2.fq
                                5.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_1.fq
                                5.Clean_FCHVJVMBCXX_L1_wHAXPI034525-109_2.fq
                                5.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_1.fq
                                5.Clean_FCHVJVMBCXX_L2_wHAXPI034525-109_2.fq
--------------------------------------------------------

# 3 Scripts
--------------------------------------------------------
## 3.1 Perl Scripts
--------------------------------------------------------
### 3.1.1 Preprocessing.pl
--------------------------------------------------------
         Function:      Pipline of preprocessing, this script performs all processing steps through building the OTU table with several pair of fastq file.
      Last updata:      2016-09-18
           Author:      Huimin Zheng
--------------------------------------------------------
### 3.1.2 Illumina_pairend_preprocessing.pl
--------------------------------------------------------
         Function:      This script performs all processing steps through building the OTU table with one pair of fastq file.
         Location:      Called by the pipeline--Preprocessing.pl
      Last updata:      2016-08-08
           Author:      Yan He
--------------------------------------------------------
### 3.1.3 trim_200bp.pl
--------------------------------------------------------
         Function:      Trim the fastq file to 200bp, this can reduce the computational burden while using enough information to do overlapping
         Location:      Called by the script--Illumina_pairend_preprocessing.pl
      Last updata:      2016-08-08
           Author:      Hua-Fang Sheng
--------------------------------------------------------
### 3.1.4 pairend.extract_sequences.pl
--------------------------------------------------------
         Function:      Do library splitting, as barcodes on both ends is not quite supported by QIIME at the moment (QIIME 1.9.1)
         Location:      Called by the script--Illumina_pairend_preprocessing.pl
      Last updata:      2016-08-08
           Author:      Yan He
--------------------------------------------------------

# 4 Direction for use
--------------------------------------------------------
## 4.1 Configuring the system environment files and variables
--------------------------------------------------------
       Configuring the system environment files and variables based on the (1) Environment
--------------------------------------------------------
## 4.2 Location of the files
--------------------------------------------------------
      put the scripts, bbmap folder and supplementary files in the same path
      put all fastq files in the same path
--------------------------------------------------------
## 4.3 Run pipeline
--------------------------------------------------------
### 4.3.1 Preprocessing: From raw sequences to BIOM
-------------------------------------------------------- 
     perl Preprocessing.pl <fq_dir> <metadata.list> <threads> <output_dir> 
     <fq_dir>: Path to the folder containing all fastq files.
     <metadata.list>: Path to file listing path to metadata file.
     <threads>: Specify number of threads.
     <output_dir>: The output directory.
     # nohup perl Preprocessing.pl <fq_dir> <metadata.list> <threads> <output_dir> > Preprocessing.log 2>&1 &
--------------------------------------------------------


# 5 How to get the data?   
--------------------------------------------------------
## 5.1 How to get the original sequences?   
--------------------------------------------------------
     The 16S gene sequencing reads of GGMP have been deposited in EBI under accession PRJEB18535.   
--------------------------------------------------------

