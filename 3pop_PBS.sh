## Input: sh 3pop_PBS Foldername

STARTTIME=$(date +%s)

if [ -z $1 ]; then
	echo Error: please provide output file name
	exit 0
fi

## Filepaths

MSMS=~/Project/Tools/msms/lib/msms.jar
OUTPUT=~/Project/Output
ANGSD=~/Project/Tools/ngsTools/angsd/
ANC=~/Project/data/reference/chimpHg19.fa
REALSFS=~/Project/Tools/ngsTools/angsd/misc/realSFS
POP1BAMS=~/Project/data/Pop1_BAMs
POP2BAMS=~/Project/data/Pop2_BAMs
POP3BAMS=~/Project/data/Pop3_BAMs
PBSPLOT=~/Project/Scripts/PBS_Sliding_Window_Plot.R

## Parameters
WINSIZE=50000
STEPSIZE=10000

if [ -d $OUTPUT/$1 ]; then
	echo Folder already exists\; please choose another name
	exit 0
fi

mkdir $OUTPUT/$1

OUTFOLDER=$OUTPUT/$1

ls $POP1BAMS/*.bam > $OUTFOLDER/Pop1.filelist
ls $POP2BAMS/*.bam > $OUTFOLDER/Pop2.filelist
ls $POP3BAMS/*.bam > $OUTFOLDER/Pop3.filelist

## SAF

$ANGSD/angsd -b $OUTFOLDER/Pop1.filelist -anc $ANC -out $OUTFOLDER/Pop1 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/Pop2.filelist -anc $ANC -out $OUTFOLDER/Pop2 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/Pop3.filelist -anc $ANC -out $OUTFOLDER/Pop3 -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3

## 2D SFS

$REALSFS $OUTFOLDER/Pop1.saf.idx $OUTFOLDER/Pop1.saf.idx -p 4 > $OUTFOLDER/Pop1.Pop2.ml
$REALSFS $OUTFOLDER/Pop2.saf.idx $OUTFOLDER/Pop2.saf.idx -p 4 > $OUTFOLDER/Pop1.Pop3.ml
$REALSFS $OUTFOLDER/Pop3.saf.idx $OUTFOLDER/Pop3.saf.idx -p 4 > $OUTFOLDER/Pop2.Pop3.ml

## Pairwise Fst

$REALSFS fst index $OUTFOLDER/Pop1.saf.idx $OUTFOLDER/Pop2.saf.idx -sfs $OUTFOLDER/Pop1.Pop2.ml -fstout $OUTFOLDER/Pop1.Pop2
$REALSFS fst index $OUTFOLDER/Pop1.saf.idx $OUTFOLDER/Pop3.saf.idx -sfs $OUTFOLDER/Pop1.Pop3.ml -fstout $OUTFOLDER/Pop1.Pop3
$REALSFS fst index $OUTFOLDER/Pop2.saf.idx $OUTFOLDER/Pop3.saf.idx -sfs $OUTFOLDER/Pop2.Pop3.ml -fstout $OUTFOLDER/Pop2.Pop3

$REALSFS fst stats2 $OUTFOLDER/Pop1.Pop2.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/Pop1.Pop2.fst.txt
$REALSFS fst stats2 $OUTFOLDER/Pop1.Pop3.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/Pop1.Pop3.fst.txt
$REALSFS fst stats2 $OUTFOLDER/Pop2.Pop3.fst.idx -win $WINSIZE -step $STEPSIZE > $OUTFOLDER/Pop2.Pop3.fst.txt

cut -f 2- $OUTFOLDER/Pop1.Pop2.fst.txt | cut -c 2- > $OUTFOLDER/Pop1.Pop2.fst.slidwind.txt
cut -f 2- $OUTFOLDER/Pop1.Pop3.fst.txt | cut -c 2- > $OUTFOLDER/Pop1.Pop3.fst.slidwind.txt
cut -f 2- $OUTFOLDER/Pop2.Pop3.fst.txt | cut -c 2- > $OUTFOLDER/Pop2.Pop3.fst.slidwind.txt

ENDTIME=$(date +%s)

Rscript $PBSPLOT $OUTFOLDER/Pop1.Pop2.fst.slidwind.txt $OUTFOLDER/Pop1.Pop3.fst.slidwind.txt $OUTFOLDER/Pop2.Pop3.fst.slidwind.txt $OUTFOLDER/

exit
