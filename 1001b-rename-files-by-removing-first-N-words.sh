#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## THIS PROGRAM RENAMES ALL FILES IN A FOLDER BY
    ## REMOVING THE FIRST WORD, KEEPING ALL OTHERS AS IT IS
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PWD=`pwd` ;
cd $PWD ;
echo "Present working directory: $PWD" ; echo ;

echo ">>>> NOTE: Make sure that the existing filenames don't have any spaces with them, and words are separated by hyphens." ;

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
