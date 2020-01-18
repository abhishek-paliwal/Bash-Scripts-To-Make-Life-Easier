#!/bin/bash
##############################
## USAGE COMMAND: sh 201_sorting_mp3_files_by_duration.sh "INTEGER_ARGUMENT" "SONG_DIRECTORY"
## IMPORTANT NOTE: ALWAYS USE AN ARGUMENT WITH THIS SCRIPT
##############################
## THIS PROGRAM GOES THROUGH A FOLDER CONTAINING MP3 Files
## THEN, FINDS THEIR DURATION, AND SORTS THEM IN A TEXT File
## IT THEN MAKES ANOTHER TXT FILE WHERE DURATION ARE GREATER THAN CERTAIN VALUE.
## FINALLY, CHOOSES A RANDOM MP3 FILE LONGER THAN THE SUPPLIED ARGUMENT ...
## ... FROM THAT SORTED FILE FOR FFMPEG VIDEO
## DATE: Tuesday July 3, 2018
## BY: PALI
##############################

## Checks if arguments are supplied at all
if [ $# -eq 0 ] ; then echo; echo "------> ERROR: NO ARGUMENTS SUPPLIED ON COMMAND LINE. <------"; echo ; fi
echo "------> \$1 should be an integer value in seconds. \$2 should be song directory path. <------"
echo;

## IF $1 is not supplied on command line, meaning if it's null (-z checks for null value):
if [ -z "$1" ]
  then
    echo "No argument supplied on CLI: LOOKUP_AUDIO_DURATION";
    LOOKUP_AUDIO_DURATION="1000" ; ## Setting to a default value in seconds
    echo "Thus, LOOKUP_AUDIO_DURATION = $LOOKUP_AUDIO_DURATION seconds (default value chosen)" ;
    echo;
else
    LOOKUP_AUDIO_DURATION="$1" ; ## First argument from command line (an integer)
    echo "LOOKUP_AUDIO_DURATION = $LOOKUP_AUDIO_DURATION seconds (taken from supplied argument)" ;
    echo;
fi

## IF $2 is not supplied on command line, meaning if it's null (-z checks for null value):
if [ -z "$2" ]
  then
    echo "No argument supplied on CLI: SONG_DIR";
    SONG_DIR=`pwd` ; ## Setting to a default value in seconds
    echo "Thus, SONG_DIR = $SONG_DIR (current working directory chosen as song directory)"
    echo;
else
    SONG_DIR="$2" ; ## First argument from command line (a string of directory path)
    echo "SONG_DIR = $SONG_DIR (taken from supplied argument)" ;
    echo;
fi

## CD'ing to that directory from wherever you are
cd $SONG_DIR
echo "PWD is: $SONG_DIR"
echo "=============================================================================================";
echo "THIS PROGRAM WILL SEARCH FOR AUDIO MP3 FILES WHICH HAVE A DURATION LONGER THAN $LOOKUP_AUDIO_DURATION SECONDS."
echo "=============================================================================================";

touch _tmp_song_lengths.txt
touch _tmp_chosen.txt
touch _tmp_song_lengths_in_minutes.txt

## Make a temporary directory to copy renamed song files to:
RENAMED_DIR="$SONG_DIR/_tmp_renamed_songs"
mkdir $RENAMED_DIR

##Removing all TMP txt files if exists
rm _tmp_*.txt ;

for x in *mp3;
    do
        ## Putting the duration of this audio file in tmp file, through AFINFO built-in command (ON MAC OS)
        ## OR on linux based machines, we will use ffmpeg's ffprobe command to get length in seconds.
        ## (but first check, whether this computer is raspberry pi)
        if [ "$USER" == "pi" ]
        then
          ffprobe -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$x" 2>/dev/null > _tmp_song.txt ;
        else
          afinfo $x | grep -i 'duration' | cut -d ':' -f 2 > _tmp_song.txt ;
        fi

        ## Extracting the first part before dot
        SONG_LENGTH=`cut -d '.' -f 1 _tmp_song.txt` ;

        ## Converting to Integer
        SONG_LENGTH_INTEGER=`printf '%d\n' "$SONG_LENGTH"` ;
        SONG_LENGTH_INTEGER_IN_MINUTES=`printf '%02dm-%02ds\n' $(($SONG_LENGTH_INTEGER/60)) $(($SONG_LENGTH_INTEGER%60))`

        echo "$SONG_LENGTH_INTEGER+$x" >> _tmp_song_lengths.txt ;
        echo "$SONG_LENGTH_INTEGER_IN_MINUTES+$x" >> _tmp_song_lengths_in_minutes.txt ;

        ## USING THE ARGUMENT VALUE TO COMPARE DURATIONS
        if [ "$SONG_LENGTH_INTEGER" -gt "$LOOKUP_AUDIO_DURATION" ]
            then
                echo "... f o u n d  m a t c h ... DURATION: $SONG_LENGTH_INTEGER seconds : $x";
                echo "... f o u n d  m a t c h ... DURATION: $SONG_LENGTH_INTEGER_IN_MINUTES : $x";
                echo "$x" >> _tmp_chosen.txt ;
        fi

        ## Rename and copy files only if NO ARGUMENTS are supplied. Else, it would rename songs unnecessarily every time.
        if [ $# -eq 0 ] ; then
            ## Rename and Copy the song files to a tmp directory
            cp $x $RENAMED_DIR/$SONG_LENGTH_INTEGER_IN_MINUTES+$x ;
            echo "... f i l e  r e n a m e d  a n d  c o p i e d ... : $x";
            echo ;
        fi


    done

## Sorting the audio lengths, from longest to shortest
cat _tmp_song_lengths.txt | sort -r -n > _tmp_song_lengths_sorted.txt
cat _tmp_chosen.txt | sort -r -n > _tmp_chosen_sorted.txt
cat _tmp_song_lengths_in_minutes.txt | sort -r -n > _tmp_song_lengths_in_minutes_sorted.txt

## List all audio files
echo; echo "<-- ALL AUDIO FILES BELOW : TEMPORARY NAMES -->" ; echo;
cat $SONG_DIR/_tmp_song_lengths.txt

echo; echo "<-- AUDIO FILES GREATER THAN $1 seconds : ORIGINAL NAMES -->" ; echo;
cat $SONG_DIR/_tmp_chosen_sorted.txt

## Choose one random line finally: Use gshuf tools from Homebrew coreutils
## This file will then be used for making video for FFMPEG
## The idea here is to choose an audio file which has a duration longer than the video itself
## (but first check, whether this computer is raspberry pi)
if [ "$USER" == "pi" ]
then
  MY_RANDOM_SONG=$(shuf -n 1 $SONG_DIR/_tmp_chosen_sorted.txt) ;
else
  MY_RANDOM_SONG=$(gshuf -n 1 $SONG_DIR/_tmp_chosen_sorted.txt) ;
fi

echo; echo "(IN-PROGRAM) Chosen random file: "$MY_RANDOM_SONG ; echo ;

## Open Directory to see status
#open $SONG_DIR
