#Evaluation for different methods for estimating 3D-SFS

These scripts were used to evaluate three different methods for estimating site frequency spectra from simulated data. These three methods are:
i) The probabilistic method used by ANGSD
ii) Called genotype method assuming a Hardy-Weinberg equilibrium prior
iii) Called genotype method assuming a uniform distribution prior

This was performed by simulating genotypes for three populations using the program msms to produce genotypes, which were converted into genotype likelihood data using the program msToGlf. ANGSD was then used to estimate the 3D-SFS using the probabilistic method. The raw genotypes from msms were also used to calculate the true 3D-SFS, as well as estimated 3D-SFS based on called genotype methods assuming i) a Hardy-Weinberg equilibrium prior and ii) a uniform distribution prior.

The script msms_3pop_sfs.sh contains the code used to calculate the true genotypes from msms, the estimated genotypes from the two called genotypes methods, and the estimated 3D-SFS using ANGSD. The R Script 3D-SFS_RMSE_Calculation.R contains all the individual scripts used to calculate the true 3D-SFS and the estimated 3D-SFS using the called genotype methods. This script also computes the root mean square deviation (RMSD, also referred to as RMSE) for each of the 3 methods compared to the true 3D-SFS. Although these scripts are meant to be a reference to the methods used to previously evaluate the three methods, a brief summary of how they work is below.

##Setup
msms commands are needed that produce genotypes for three populations. As an example, the current commands found in msms_3pop_sfs.sh are from the out of Africa model presented in Gutenkunst et al 2009.

##Programs needed:
msms - available from http://www.mabs.at/ewing/msms/index.shtml

ANGSD - available from http://popgen.dk/wiki/index.php/ANGSD

R - available from https://www.r-project.org

##Filepaths and Model
The filepaths at the top of the script msms_3pop_SFS.sh need to be altered to reflect your local directories. You can also change the model used to simulate data by altering the msms command line entry.

##Read depth and error rate
The read depth and error rate used to generate genotype likelihood data from the genotype output of msms. This is achieved by altering the i used in the loop below the msms command, and altering the MSTOGLF command parameter -err (currently 0.0075 comparable to the error rate found in the 1000 Genomes Project)

##Input

The input is:

sh msms_3pop_sfs.sh outputfilename pop1name pop2name pop3name

where you can specify your output folder name and the name of the 3 populations. For the Gutenkunst model, pop1 = YRI, pop2 = CEU, and pop3 = CHB. 

##Output

This will produce the probabilistic estimation of the 3D-SFS in your output folder, called $POP1.$POP2.$POP3.ml. It will also output the raw msms genotypes, called msoutput.txt, as well as the genotypes called by the two different genotype calling methods. These will be named $popname.geno.txt for the Hardy-Weinberg equilibrium prior, and $popname.geno.uni.txt for the uniform distribution prior. The script 3D-SFS_RMSE_Calculations.R contains all the R code to compute the 3D-SFS from these called genotypes, as well as calculate the RMSE (same as RMSD) for each method.

For interest only, there is also a script to calculate the Fst from 2D-SFS for 2 populations. However, this can also be pipelined directly using ANGSD, therefore this script is now defunct (Manual_Fst_Calculation.R)

Any further questions please contact Dean.Ousby@googlemail.com

