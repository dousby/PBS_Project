#1000GP BAM Download
## A pipeline for downloading phase 3 BAM files from the 1000 Genomes Project

Note: This has been designed to work with phase 3 data from the 1000 Genomes Project, as of 14/08/2015.

These scripts will facilitate the download of multiple individual BAM files from phase 3 of the 1000 Genomes Project (1000GP) separated into their respective populations. These scripts require you to clone the 1000GP BAM Download folder onto your local machine.

As an example, we have designed these scripts to download three sets of BAM files for chromosome 1 for a group of 18 Peruvians (PEL), 20 Europeans (CEU), and 20 East Asians (CHB). However, these can easily be altered for any three lists of individuals and for any region.

##Additional Programs Needed
SAMtools - available from http://samtools.sourceforge.net


##Sample
The three files, CEU_list.txt, CHB_list.txt and PEL_list.txt contain the names of individuals from each of the three populations of interest from the 1000GP, one individual per line. These can be altered to download any list of individuals from the 1000GP. The file phase3_bamlist.txt contains filepaths for all the individuals within phase 3 of the 1000GP.

##Setup
In each of the three population folders (CEU_BAMs, CHB_BAMs, and PEL_BAMs) is a download script. These contain filepaths at the start of the script that need to be altered to reflect your local directories. The last command:

$SAMTOOLS view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/$i 1 > $FOLDER/CEU_BAMs/$NAME

contains the region you wish to download. This is found after the command ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/$i, and is currently set to 1 to download the whole of chromosome one. Specific regions can also be specified, for example 

$SAMTOOLS view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/$i 1:119549417-119577202 > $FOLDER/CEU_BAMs/$NAME

will download the region 119549417-119577202 on chromosome 1. 

## How it works

Upon running these scripts, it will create popname.txt (e.g. CEU.txt) by cross referencing the individuals in the popname_list.txt (e.g. CEU_list.txt) files with the phase3_bamlist.txt file. These will contain the actual filepaths to the online BAM files in the 1000GP that are then piped into SAMtools and downloaded.

## Running this script

I have also included a simple DL_Shell.sh that will run each of the population download scripts one after the other, just to make things a bit simpler.

If you are using these BAM files to calculate PBS, please note the folders containing BAM files can only contain the BAM files themselves, and any scripts must be moved from these folders.

Any questions please contact Dean.Ousby@googlemail.com.