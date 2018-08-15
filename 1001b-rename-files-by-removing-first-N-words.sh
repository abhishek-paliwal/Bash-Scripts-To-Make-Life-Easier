#!/bin/bash
## THIS PROGRAM RENAMES ALL FILES IN A FOLDER BY REMOVING THE FIRST WORD, KEEPING ALL OTHERS AS IT IS

PWD=`pwd` ;
cd $PWD ;
echo "Present working directory: $PWD" ; echo ;

mkdir _TMP_DIR ;

echo "How many words do you want to remove from beginning: " ;
read num_words ;

num_words_new=`echo $num_words+1 | bc` ;

echo "$num_words = NUMBER OF WORDS TO REMOVE FROM BEGINNING " ;

for x in *.* ;
do
    filename=$(basename -- "$x") ;
    extension="${filename##*.}" ;
    filename="${filename%.*}" ;

    ## NEW VARIABLE WHICH HOLDS WHOLE FILENAME BEGINNNIG FROM SECOND DELIMITER TILL END
    ##
    new_name=`echo $filename | cut -d "-" -f$num_words_new-` ;

    cp $x _TMP_DIR/$new_name.$extension ;
    echo "RENAMING DONE: $x -> $new_name.$extension " ;

done
