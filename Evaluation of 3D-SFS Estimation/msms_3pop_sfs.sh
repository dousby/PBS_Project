# INPUT - OUTPUTFILENAME 

STARTTIME=$(date +%s)

if [ -z $1 ]; then
	echo Error: please provide output file name
	exit 0
fi

# POPNAMES

POP1=YRI
POP2=CEU
POP3=CHB

# FILEPATHS

MSMS=~/Project/Tools/msms/lib/msms.jar
OUTPUT=~/Project/Output
ANGSD=~/Project/Tools/ngsTools/angsd/angsd
FAI=~/Project/Tools/input/Scripttest/chimpHg19.fa.fai
MSTOGLF=~/Project/Tools/ngsTools/angsd/misc/msToGlf
SPLITGL=~/Project/Tools/ngsTools/angsd/misc/splitgl
REALSFS=~/Project/Tools/ngsTools/angsd/misc/realSFS
SFSCALC=~/Project/realSFScalctest.R
READMS=~/Project/Tools/readms.output.R
PBS=~/Project/PBS_Calculation.R

# PARAMETERS
# ADD TO THIS

NSAMPLE=120
POP1SIZE=40
POP2SIZE=40
POP3SIZE=40
NREPS=1
MININD=10

if [ -d $OUTPUT/$1 ]; then
	echo Folder already exists\; please choose another name
	exit 0
fi

mkdir $OUTPUT/$1

OUTFOLDER=$OUTPUT/$1

# MSMS COMMAND

java -jar $MSMS -ms $NSAMPLE $NREPS -t 600 -r 219 1000000 -I 3 $POP1SIZE $POP2SIZE $POP3SIZE -n 1 1.682020 -n 2 3.736830 -n 3 7.292050 -eg 0 2 116.010723 -eg 0 3 160.246047 -ma x 0.881098 0.561966 0.881098 x 2.797460 0.561966 2.797460 x -ej 0.028985 3 2 -en 0.028985 2 0.287184 -ema 0.028985 3 x 7.293140 x 7.293140 x x x x x -ej 0.197963 2 1 -en 0.303501 1 1 > $OUTFOLDER/msoutput.txt


for i in 5; ## i equals the read depth used (this can be looped for multiple read depths)
do

OUTFOLDER=$OUTPUT/$1

mkdir $OUTFOLDER/$i

# MSTOGLF

$MSTOGLF -in $OUTFOLDER/msoutput.txt -out $OUTFOLDER/$i/GLF$1 -regLen 1000000 -singleOut 1 -depth $i -err 0.0075

OUTFOLDER=$OUTFOLDER/$i

rm $OUTFOLDER/*.argg $OUTFOLDER/*.pgEstH $OUTFOLDER/*.vPos

echo \"1 250000000\" > $OUTFOLDER/fai.fai

# SPILTGLF

$SPLITGL $OUTFOLDER/GLF$1.glf.gz $(($NSAMPLE / 2)) 1 $(($POP1SIZE / 2)) > $OUTFOLDER/$POP1.glf.gz
$SPLITGL $OUTFOLDER/GLF$1.glf.gz $(($NSAMPLE / 2)) $(($POP1SIZE / 2 + 1)) $(($POP1SIZE / 2 + $POP2SIZE / 2)) > $OUTFOLDER/$POP2.glf.gz
$SPLITGL $OUTFOLDER/GLF$1.glf.gz $(($NSAMPLE / 2)) $(($POP1SIZE / 2 + $POP2SIZE / 2 + 1)) $(($NSAMPLE / 2)) > $OUTFOLDER/$POP3.glf.gz

# SAF CREATION

$ANGSD -glf $OUTFOLDER/$POP1.glf.gz -nInd $(($POP1SIZE / 2)) -doSaf 1 -out $OUTFOLDER/$POP1 -fai $OUTFOLDER/fai.fai -isSim 1 -minInd $MININD
$ANGSD -glf $OUTFOLDER/$POP2.glf.gz -nInd $(($POP2SIZE / 2)) -doSaf 1 -out $OUTFOLDER/$POP2 -fai $OUTFOLDER/fai.fai -isSim 1 -minInd $MININD
$ANGSD -glf $OUTFOLDER/$POP3.glf.gz -nInd $(($POP3SIZE / 2)) -doSaf 1 -out $OUTFOLDER/$POP3 -fai $OUTFOLDER/fai.fai -isSim 1 -minInd $MININD

# SFS CREATION

$REALSFS $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx -p 20 > $OUTFOLDER/$POP1.$POP2.ml
$REALSFS $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP3.saf.idx -p 20 > $OUTFOLDER/$POP1.$POP3.ml
$REALSFS $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -p 20 > $OUTFOLDER/$POP2.$POP3.ml

## Extra 3D-SFS

$REALSFS $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -p 20 > $OUTFOLDER/$POP1.$POP2.$POP3.ml

# FST CREATION

$REALSFS fst index $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx -sfs $OUTFOLDER/$POP1.$POP2.ml -fstout $OUTFOLDER/fst.$POP1.$POP2
$REALSFS fst index $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP3.saf.idx -sfs $OUTFOLDER/$POP1.$POP3.ml -fstout $OUTFOLDER/fst.$POP1.$POP3
$REALSFS fst index $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -sfs $OUTFOLDER/$POP2.$POP3.ml -fstout $OUTFOLDER/fst.$POP2.$POP3

$REALSFS fst index $OUTFOLDER/$POP1.saf.idx $OUTFOLDER/$POP2.saf.idx $OUTFOLDER/$POP3.saf.idx -fstout $OUTFOLDER/fst.$POP1.$POP2.$POP3 -sfs $OUTFOLDER/$POP1.$POP2.ml -sfs $OUTFOLDER/$POP1.$POP3.ml -sfs $OUTFOLDER/$POP2.$POP3.ml 

$REALSFS fst stats $OUTFOLDER/fst.$POP1.$POP2.fst.idx > $OUTFOLDER/$POP1.$POP2.fst.txt
$REALSFS fst stats $OUTFOLDER/fst.$POP1.$POP3.fst.idx > $OUTFOLDER/$POP1.$POP3.fst.txt
$REALSFS fst stats $OUTFOLDER/fst.$POP2.$POP3.fst.idx > $OUTFOLDER/$POP2.$POP3.fst.txt

$REALSFS fst stats $OUTFOLDER/fst.$POP1.$POP2.$POP3.fst.idx > $OUTFOLDER/$POP1.$POP2.$POP3.fst.txt


echo $POP1 and $POP2 Weighted Fst:
cat $OUTFOLDER/$POP1.$POP2.fst.txt | rev | cut -b-8 |rev

echo $POP1 and $POP2 Weighted Fst:
cat $OUTFOLDER/$POP1.$POP3.fst.txt | rev | cut -b-8 |rev

echo $POP2 and $POP3 Weighted Fst:
cat $OUTFOLDER/$POP2.$POP3.fst.txt | rev | cut -b-8 |rev

echo $POP1, $POP2 and $POP3 Pairwise Weighted Fst:
rev $OUTFOLDER/$POP1.$POP2.$POP3.fst.txt | cut -b-8 |rev > $OUTFOLDER/Sim.Fst.txt
cat $OUTFOLDER/Sim.Fst.txt

Rscript $SFSCALC $POP1SIZE $POP2SIZE $POP3SIZE $NREPS $READMS $OUTPUT/$1/msoutput.txt $OUTFOLDER/real.Fst.txt

Rscript $PBS $OUTFOLDER/Sim.Fst.txt $OUTFOLDER/Sim.PBS.txt

Rscript $PBS $OUTFOLDER/real.Fst.txt $OUTFOLDER/Real.PBS.txt


echo Simulated PBS
cat $OUTFOLDER/Sim.PBS.txt
echo
echo Real PBS
cat $OUTFOLDER/Real.PBS.txt
echo
echo Simulated Fst
cat $OUTFOLDER/Sim.Fst.txt
echo
echo Real Fst
cat $OUTFOLDER/real.Fst.txt

mkdir $OUTFOLDER/Summary_Stats

mv $OUTFOLDER/*.txt $OUTFOLDER/Summary_Stats

## Calculating it all via called genotypes

$ANGSD -glf $OUTFOLDER/$POP1.glf.gz -nInd $(($POP1SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP1.Geno -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 1 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD
$ANGSD -glf $OUTFOLDER/$POP2.glf.gz -nInd $(($POP2SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP2.Geno -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 1 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD
$ANGSD -glf $OUTFOLDER/$POP3.glf.gz -nInd $(($POP3SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP3.Geno -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 1 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD

gunzip $OUTFOLDER/$POP1.Geno.geno.gz
gunzip $OUTFOLDER/$POP2.Geno.geno.gz
gunzip $OUTFOLDER/$POP3.Geno.geno.gz

awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP1.Geno.geno > $OUTFOLDER/$POP1.geno.txt
awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP2.Geno.geno > $OUTFOLDER/$POP2.geno.txt
awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP3.Geno.geno > $OUTFOLDER/$POP3.geno.txt

$ANGSD -glf $OUTFOLDER/$POP1.glf.gz -nInd $(($POP1SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP1.Geno.uni -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 2 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD

$ANGSD -glf $OUTFOLDER/$POP2.glf.gz -nInd $(($POP2SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP2.Geno.uni -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 2 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD

$ANGSD -glf $OUTFOLDER/$POP3.glf.gz -nInd $(($POP3SIZE / 2)) -doGeno 2 -out $OUTFOLDER/$POP3.Geno.uni -fai $OUTPUT/reference.fa.fai -ref $OUTPUT/reference.fa -isSim 1 -doPost 2 -doMajorMinor 4 -doMaf 1 -postCutoff 0 -minInd $MININD

gunzip $OUTFOLDER/$POP1.Geno.uni.geno.gz
gunzip $OUTFOLDER/$POP2.Geno.uni.geno.gz
gunzip $OUTFOLDER/$POP3.Geno.uni.geno.gz

awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP1.Geno.uni.geno > $OUTFOLDER/$POP1.geno.uni.txt
awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP2.Geno.uni.geno > $OUTFOLDER/$POP2.geno.uni.txt
awk '{$1=""; $2=""; print}' $OUTFOLDER/$POP3.Geno.uni.geno > $OUTFOLDER/$POP3.geno.uni.txt



done

ENDTIME=$(date +%s)

echo "It took $(($ENDTIME - $STARTTIME)) seconds to complete this task..." > $OUTFOLDER/time.txt
cat $OUTFOLDER/time.txt

exit