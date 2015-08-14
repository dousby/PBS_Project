# PBS sliding window calculation for a set of BAM files from 3 populations

##Setup
This analysis assumes you already have a set of BAM files for each of the 3 populations which are separated into three folders by population. I have provided a pipeline to facilitate BAM file download from the 1000 Genomes Project (found in PBS_Project/1000GP BAM Download). As an example, we performed previous analysis on Peruvians, using Europeans and East Asians as reference sequences. Please contact dean.ousby@googlemail.com for further details.

##Programs needed:
Analysis of Next Generation Sequencing Data (ANGSD) v0.902 or above - available at http://popgen.dk/wiki/index.php/ANGSD
R: The R Project for Statistical Computing - available at https://www.r-project.org

##Scripts needed from this repository:
3pop_PBS.sh
PBS_Sliding_Window_Plot.R

You will also need an ancestral reference sequence. A Hg19 ancestral sequence is available here: http://dna.ku.dk/~thorfinn/hg19ancNoChr.fa.gz

##Initial setup:
After downloading and installing the programs/scripts stated above, the script 3pop_PBS.sh needs to be edited to reflect your local directories. A list of filepaths can be found near the top of the script which need to be completed. You are also able to specify the window size and the step size used to scan sequences with, under the parameters WINSIZE and STEPSIZE respectively

##Running PBS Calculaton

Once these are completed, the script 3pop_PBS.sh can be run with the input:

sh 3pop_PBS.sh outputfolder pop1name pop2name pop3name

where outputfolder is the name you want to assign to your results, and pop1name, pop2name, and pop3name are the names of your 3 populations.

Depending on the number of BAM files and the length of the sequences, this may take a few minutes to a number of days. For reference, a set of 18, 20, and 20 BAM files in pops 1, 2, and 3, for a whole chromosome 11 scan took roughly 24 hours. This will output a PBS plot of the sequence in your output folder.

The computationally demanding part of the analysis is the SFS estimation. Once this has been performed, the latter half of this script (after Pairwise Fst) can be adjusted and rerun for different window and step sizes.

Please contact Dean.Ousby@googlemail.com for further details.
