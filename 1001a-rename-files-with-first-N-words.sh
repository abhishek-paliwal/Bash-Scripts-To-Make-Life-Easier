#!/bin/bash
## THIS PROGRAM RENAMES ALL FILES IN A FOLDER BY KEEPING THE FIRST N-WORDS, REMOVING EVERYTHING AFTER THAT

PWD=`pwd` ;
cd $PWD ;
echo "Present working directory: $PWD" ; echo ;

echo ">>>> NOTE: Make sure that the existing filenames don't have any spaces with them, and words are separated by hyphens." ;


mkdir _TMP_DIR ;

echo "How many words from beginning do you want to keep in your new filename: " ;
read num_words ;

## CONVERTING IT TO AN INTEGER
num_words_new=`echo $num_words | bc` ;

echo "$num_words = NUMBER OF WORDS TO KEEP FROM BEGINNING " ;

for x in *.* ;
do
    filename=$(basename -- "$x") ;
    extension="${filename##*.}" ;
    filename="${filename%.*}" ;

    ## NEW VARIABLE WHICH HOLDS WHOLE FILENAME WITH FIRST N-WORDS
    new_name=`echo $filename | cut -d "-" -f1-$num_words_new` ;

    cp $x _TMP_DIR/$new_name.$extension ;
    echo "RENAMING DONE: $x -> $new_name.$extension " ;

done
