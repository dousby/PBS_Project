FOLDER= ## Filepath of 1000GP BAM Download folder

SAMTOOLS=  ## Filepath to SAMTOOLS

INPUT=$FOLDER/CEU_list.txt

INDS=`cat $INPUT`

for i in $INDS; do

grep $i $FOLDER/phase3_bamlist.txt >> $FOLDER/CEU_BAMs/CEU.txt

done

INDLIST=`cat $FOLDER/CEU_BAMs/CEU.txt`

for i in $INDLIST; do

NAME=`echo -n $i | tail -c 58`

$SAMTOOLS view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/$i 1 > $FOLDER/CEU_BAMs/$NAME

done

exit