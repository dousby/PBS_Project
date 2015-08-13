PBS_Project

This contains all the scripts used in the project 'Evaluation and application of improved site frequency spectrum estimation from low coverage sequencing data'

The script 3pop_PBS.sh will take the BAM files for a set of 3 populations separated into population folders, and plot the PBS positions. This will use the R script PBS_Sliding_Window_Plot.R.

The script msms_3pop_fst.sh will simulate genotypes for 3 populations based on a demographic model (as an examplethis script currently contains the model described in Gutenkunst et al 2009). It will then produce genotype likelihood files for these 3 population, and calculate the 3D-SFS using 3 methods: the probablistic method used by ANGSD, and called genotype methods assuming i) a Hardy-Weinberg equilibrium prior or ii) a uniform distribution prior

 These scripts require the programs ANGSD, msms and R.
