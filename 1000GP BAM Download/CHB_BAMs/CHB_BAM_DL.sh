FOLDER= ## Filepath of 1000GP BAM Download folder

SAMTOOLS=  ## Filepath to SAMTOOLS

INPUT=$FOLDER/CHB_list.txt

INDS=`cat $INPUT`

for i in $INDS; do

grep $i $FOLDER/phase3_bamlist.txt >> $FOLDER/CHB_BAMs/CHB.txt

done

INDLIST=`cat $FOLDER/CHB_BAMs/CHB.txt`

for i in $INDLIST; do

NAME=`echo -n $i | tail -c 58`

$SAMTOOLS view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/$i 1:119549417-119577202> $FOLDER/CHB_BAMs/$NAME

done

exit