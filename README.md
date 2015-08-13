PBS_Project

This repository contains all the scripts used in the project 'Evaluation and application of improved site frequency spectrum estimation from low coverage sequencing data'

These scripts allows a) the computation of PBS along a sliding window for BAM files from 3 populations
and b) the production of site frequency spectra (SFS) from simulated data using 3 methods: the probabilistic method used by ANGSD, and called genotypes assuming i) a Hardy-Weinberg equilibrium prior and ii) a uniform distribution prior. The main application of these scripts is to identify regions under selection using elevated PBS as a proxy. Therefore the main focus of this tutorial will be the application to real data; computing the PBS from a set of BAM files from 3 populations. The scripts used to evaluate 3D-SFS estimation using the probabilistic method found in ANGSD are also found in this repository. However since they have little real world application they serve as an example of the previous investigation that has been done to assess this probabilistic method.

# PBS sliding window calculation for a set of BAM files from 3 populations

##Setup
This analysis assumes you already a set of BAM files for each of the 3 populations. These need to be separated into their populations in different folders. BAM files can be downloaded from the 1000 Genomes Project (http://www.1000genomes.org), facilitated by SAMtools (www.http://samtools.sourceforge.net). As an example, we performed previous analysis on Peruvians, using Europeans and East Asians as an example (Please contact dean.ousby@googlemail.com for further details).

Analysis of Next Generation Sequencing Data (ANGSD) - available at http://popgen.dk/wiki/index.php/ANGSD
##Programs needed:
R: The R Project for Statistical Computing - available at https://www.r-project.org

##Scripts needed from this repository:
3pop_PBS.sh
PBS_Sliding_Window_Plot.R

You will also need an ancestral reference sequence. A Hg19 ancestral sequence is available here: http://dna.ku.dk/~thorfinn/hg19ancNoChr.fa.gz

##Initial setup:
You are required to download and install the programs and scripts listed above. At the start of the script 3pop_PBS.sh there are a list of filepaths that need to be filled in. You are also able to specify the window size and the step size used to scan the sequences with, under Parameters WINSIZE and STEPWISE respectively.

Once these are completed, the script 3pop_PBS.sh can be run with the input:

sh 3pop_PBS.sh outputfolder

where you can specific the name of your output folder. Depending on the number of BAM files and the length of the sequences, this may take a few minutes to a number of days. For reference, a set of 18, 20, and 20 BAM files in pops 1, 2, and 3, for a whole chromosome 11 scan took roughly 24 hours. This will output a PBS plot of the sequence.

The computationally demanding part of the analysis is the SFS estimation. Once this has been performed, the latter half of this script (after Pairwise Fst) can be adjusted and rerun for different window and step sizes.

Please contact dean.ousby@googlemail.com for further details.


# Evaluation of the probabilistic method for 3D-SFS estimation

Also present in this repository are examples of the scripts used to evaluation the probabilistic method for estimating 3D-SFS used by ANGSD. This was performed by simulating genotypes for 3 populations using the program msms. These genotypes were converted into genotype likelihood data using the program msToGlf. ANGSD was then used to estimate the 3D-SFS. The raw genotypes from msms were also used to calculate the true 3D-SFS, as well as estimated 3D-SFS based on called genotype methods assuming i) a Hardy-Weinberg equilibrium prior and ii) a uniform distribution prior.

The script msms_3pop_sfs.sh contains the code used to calculate the true genotypes from msms, the estimated genotypes from the two called genotypes methods, and the estimated 3D-SFS using ANGSD. The R Script ASIGJASIGN was then used to calculate the true 3D-SFS and the estimated 3D-SFS using the called genotype methods. RMSE was used to evaluate these methods, by comparing the estimated 3D-SFS using the three different methods to the true 3D-SFS calculated from the raw msms output. Although these scripts are meant to be a reference to what was previously used to evaluate the probabilistic method used above, a brief summary of how they work is below.

##Setup
msms commands are needed that produce genotypes for 3 populations. As an example, the current commands found in msms_3pop_sfs.sh are from the out of Africa model presented in Gutenkunst et al 2009.

##Programs needed:
msms - available from http://www.mabs.at/ewing/msms/index.shtml
ANGSD - available from http://popgen.dk/wiki/index.php/ANGSD
R - available from https://www.r-project.org

##Filepaths
The script msms_3pop_sfs.sh needs to be altered. At the top of this script is a list of filepaths that need to be inputted to represent your local directories. You can also change the model used to simulate data by altering the msms command line entry.

The input is:

sh msms_3pop_sfs.sh outputfilename pop1name pop2name pop3name

where you can specify your output folder name and the name of the 3 populations. For the Gutenkunst model, pop1 = YRI, pop2 = CEU, and pop3 = CHB. 

This will produce the probabilistic estimation of the 3D-SFS in your output folder, called $POP1.$POP2.$POP3.ml. It will also output the raw msms genotypes, called msoutput.txt, as well as the genotypes called by the two different genotype calling methods. These will be named Popname.geno.txt for the Hardy-Weinberg equilibrium prior, and Popname.geno.uni.txt for the uniform distribution prior. These can then be used to calculate the true, and estimated 3D-SFS using the R script BABIANAOM.

Any further questions please contact Dean.ousby@googlemail.com

