#PBS_Project

This repository contains the scripts used in the project 'Evaluation and application of improved site frequency spectrum estimation from low coverage sequencing data'

Scripts are divided into 3 folders based on their functions:

PBS_Calculation - the computation of PBS along a sliding window for BAM files from 3 populations

Evaluation of 3D-SFS Estimation - the evaluation of site frequency spectra (SFS) estimation from simulated data using three methods: the probabilistic method used by ANGSD, and called genotypes assuming i) a Hardy-Weinberg equilibrium prior and ii) a uniform distribution prior

1000GP BAM Download - a pipeline for download phase 3 BAM files from the 1000 Genomes Project

A tutorial for how to use each of these pipelines can be found in their respective folders. The main application of these scripts is to identify regions under selection using elevated PBS as a proxy (folder: PBS_Calculation). I have added the 1000GP BAM Download to facilitate retrieving NGS data for analysis. The evaluation of 3D-SFS estimation serves mainly as a reference to the previous analysis that has been performed on these methods.
