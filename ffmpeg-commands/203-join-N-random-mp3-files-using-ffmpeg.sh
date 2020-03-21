#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    #################################################
    ## THIS PROGRAM CONCATENATES N MP3 FILES.
    ## WHERE, N = AN INTEGER PROVIDED BY USER
    ## DATE: Sunday August 12, 2018
    ## MADE BY: PALI
    #################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
PWD=`pwd` ;
cd $PWD ;

## CREATING A TEXT FILES WITH ALL MP3 FILES
rm _TMP_*.TXT ; ##removing all tmp txt files

for f in ./*.mp3;
    do
    echo "file '$f'" >> _TMP_MP3_LIST_ALL.TXT ;
    done

## USER INPUT
echo "How many random MP3 files do you want to concatenate: " ;
read how_many_mp3 ;


## NOW PRINTING THE DESIRED NUMBER OF RANDOM LINES FROM THAT FILE,
## AND THEN SAVING THOSE TO ANOTHER TEXT FILES
gshuf -n $how_many_mp3 _TMP_MP3_LIST_ALL.TXT > _TMP_MP3_LIST_RANDOM.TXT

echo ">>>> THESE $how_many_mp3 RANDOM SONGS ARE CHOSEN..."
cat _TMP_MP3_LIST_RANDOM.TXT ;
echo; echo; 

## CREATING A NAME FOR THE OUTPUT FILE BASED UPON THE INPUT FILES
NEW_FILENAME=`cat _TMP_MP3_LIST_RANDOM.TXT | sed 's/file //g' | sed "s/\'//g" | sed "s/.\///g" | sed 's/\.mp3//g' | tr '\n' '-'` ;

## FINALLY SOME FFMPEG CONCATENATE MAGIC, AND CREATING FINAL FILE
mkdir _TMP_DIR ;
ffmpeg -f concat -safe 0 -i _TMP_MP3_LIST_RANDOM.TXT -c copy _TMP_DIR/joined-$how_many_mp3-$NEW_FILENAME.mp3
