## Input: sh 3pop_PBS Foldername

STARTTIME=$(date +%s)

if [ -z $1 ]; then
	echo Error: please provide output file name
	exit 0
fi

## Filepaths

OUTPUT=   ## Output folder
ANGSD=   ## ANGSD Folder
ANC=  ## The ancestral reference genome
REALSFS=   ## Filepath to RealSFS, found in ANGSD/misc/
POP1BAMS=  ## Filepath to the folder containing the BAM files for population 1
POP2BAMS=  ## Filepath to the folder containing the BAM files for population 2
POP3BAMS=  ## Filepath to the folder containing the BAM files for population 3
PBSPLOT=   ## Filepath to the R script PBS_Sliding_Window_Plot.R

## Parameters
WINSIZE=50000
STEPSIZE=10000

POP1=$2
POP2=$3
POP3=$4

if [ -d $OUTPUT/$1 ]; then
	echo Folder already exists\; please choose another name
	exit 0
fi

mkdir $OUTPUT/$1

OUTFOLDER=$OUTPUT/$1

ls $POP1BAMS/*.bam > $OUTFOLDER/$POP1.filelist
ls $POP2BAMS/*.bam > $OUTFOLDER/$POP2.filelist
ls $POP3BAMS/*.bam > $OUTFOLDER/$POP3.filelist

## SAF

$ANGSD/angsd -b $OUTFOLDER/$POP1.filelist -anc $ANC -out $OUTFOLDER/$POP1 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/$POP2.filelist -anc $ANC -out $OUTFOLDER/$POP2 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/$POP3.filelist -anc $ANC -out $OUTFOLDER/$POP3 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3

## 2D SFS

$REALSFS $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx -p 4 > $OUTFOLDER/$POP1.$POP2.ml
$REALSFS $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP3.saf.idx -p 4 > $OUTFOLDER/$POP1.$POP3.ml
$REALSFS $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -p 4 > $OUTFOLDER/$POP2.$POP3.ml

## Pairwise Fst

$REALSFS fst index $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx -sfs $OUTFOLDER/$POP1.$POP2.ml -fstout $OUTFOLDER/$POP1.$POP2
$REALSFS fst index $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP3.saf.idx -sfs $OUTFOLDER/$POP1.$POP3.ml -fstout $OUTFOLDER/$POP1.$POP3
$REALSFS fst index $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -sfs $OUTFOLDER/$POP2.$POP3.ml -fstout $OUTFOLDER/$POP2.$POP3

$REALSFS fst stats2 $OUTFOLDER/$POP1.$POP2.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/$POP1.$POP2.fst.txt
$REALSFS fst stats2 $OUTFOLDER/$POP1.$POP3.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/$POP1.$POP3.fst.txt
$REALSFS fst stats2 $OUTFOLDER/$POP2.$POP3.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/$POP2.$POP3.fst.txt

cut -f 2- $OUTFOLDER/$POP1.$POP2.fst.txt | cut -c 2- > $OUTFOLDER/$POP1.$POP2.fst.slidwind.txt
cut -f 2- $OUTFOLDER/$POP1.$POP3.fst.txt | cut -c 2- > $OUTFOLDER/$POP1.$POP3.fst.slidwind.txt
cut -f 2- $OUTFOLDER/$POP2.$POP3.fst.txt | cut -c 2- > $OUTFOLDER/$POP2.$POP3.fst.slidwind.txt

ENDTIME=$(date +%s)

Rscript $PBSPLOT $OUTFOLDER/$POP1.$POP2.fst.slidwind.txt $OUTFOLDER/$POP1.$POP3.fst.slidwind.txt $OUTFOLDER/$POP2.$POP3.fst.slidwind.txt $OUTFOLDER/

exit
