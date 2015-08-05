STARTTIME=$(date +%s)

if [ -z $1 ]; then
	echo Error: please provide output file name
	exit 0
fi

MSMS=~/Project/Tools/msms/lib/msms.jar
OUTPUT=~/Project/Output
ANGSD=~/Project/Tools/ngsTools/angsd/
ANC=~/Project/data/reference/chimpHg19.fa
REALSFS=~/Project/Tools/ngsTools/angsd/misc/realSFS
POP1BAMS=~/Project/data/CEU_BAMs
POP2BAMS=~/Project/data/CHB_BAMs
POP3BAMS=~/Project/data/PEL_BAMs

if [ -d $OUTPUT/$1 ]; then
	echo Folder already exists\; please choose another name
	exit 0
fi

mkdir $OUTPUT/$1

OUTFOLDER=$OUTPUT/$1

ls $POP1BAMS/*.bam > $OUTFOLDER/CEU.filelist
ls $POP2BAMS/*.bam > $OUTFOLDER/CHB.filelist
ls $POP3BAMS/*.bam > $OUTFOLDER/PERU.filelist

## SAF

$ANGSD/angsd -b $OUTFOLDER/CEU.filelist -anc $ANC -out $OUTFOLDER/CEU -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/CHB.filelist -anc $ANC -out $OUTFOLDER/CHB -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3
$ANGSD/angsd -b $OUTFOLDER/PERU.filelist -anc $ANC -out $OUTFOLDER/PERU -doSaf 1 -GL 1 -doMajorMinor 1 -doMaf 3

## 2D SFS

$REALSFS $OUTFOLDER/CEU.saf.idx $OUTFOLDER/CHB.saf.idx -p 4 > $OUTFOLDER/CEU.CHB.ml
$REALSFS $OUTFOLDER/CEU.saf.idx $OUTFOLDER/PERU.saf.idx -p 4 > $OUTFOLDER/CEU.PERU.ml
$REALSFS $OUTFOLDER/CHB.saf.idx $OUTFOLDER/PERU.saf.idx -p 4 > $OUTFOLDER/CHB.PERU.ml

## Pairwise Fst

$REALSFS fst index $OUTFOLDER/CEU.saf.idx $OUTFOLDER/CHB.saf.idx -sfs $OUTFOLDER/CEU.CHB.ml -fstout $OUTFOLDER/CEU.CHB
$REALSFS fst index $OUTFOLDER/CEU.saf.idx $OUTFOLDER/PERU.saf.idx -sfs $OUTFOLDER/CEU.PERU.ml -fstout $OUTFOLDER/CEU.PERU
$REALSFS fst index $OUTFOLDER/CHB.saf.idx $OUTFOLDER/PERU.saf.idx -sfs $OUTFOLDER/CHB.PERU.ml -fstout $OUTFOLDER/CHB.PERU

$REALSFS fst stats2 $OUTFOLDER/CEU.CHB.fst.idx -win 50000 -step 10000 > $OUTFOLDER/CEU.CHB.fst.txt
$REALSFS fst stats2 $OUTFOLDER/CEU.PERU.fst.idx -win 50000 -step 10000 > $OUTFOLDER/CEU.PERU.fst.txt
$REALSFS fst stats2 $OUTFOLDER/CHB.PERU.fst.idx -win 50000 -step 10000 > $OUTFOLDER/CHB.PERU.fst.txt

cut -f 2- $OUTFOLDER/CEU.CHB.fst.txt | cut -c 2- > $OUTFOLDER/CEU.CHB.fst.slidwind.txt
cut -f 2- $OUTFOLDER/CEU.PERU.fst.txt | cut -c 2- > $OUTFOLDER/CEU.PERU.fst.slidwind.txt
cut -f 2- $OUTFOLDER/CHB.PERU.fst.txt | cut -c 2- > $OUTFOLDER/CHB.PERU.fst.slidwind.txt

ENDTIME=$(date +%s)


exit
