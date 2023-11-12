#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

################################################################################
## This program extracts and prints the duration of MP3 files in the current working directory
## converting the duration to hours, minutes, and seconds, creating a CSV file at the end in workdir.
################################################################################

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
CURRENTDIR="$(pwd)" ; 
TMPCSV="$WORKDIR/mp3_durations_in_$(basename $CURRENTDIR).csv" ; 
echo "DURATION,MP3_FILEPATH" > $TMPCSV ; ## initializing columns in csv file
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## CURRENT DIRECTORY = $CURRENTDIR" ;
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_PRINT_MP3_DURATION_IN_PWD () {
    # Replace "yourfile.mp3" with the actual filename
    file="$1" ## mp3 filepath
    echo ">> CURRENT MP3 FILE = $file" ; 
    # Use ffprobe to get the duration
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
    # Convert seconds to hours, minutes, and seconds using bc
    hours=$(echo "$duration / 3600" | bc) ; 
    minutes=$(echo "($duration % 3600) / 60" | bc) ; 
    seconds_tmp=$(echo "$duration % 60" | bc) ; 
    seconds=$(echo "$seconds_tmp / 1" | bc) ;  ## rounding 
    # Print duration
    echo "${hours}h_${minutes}m_${seconds}s" ; 
    echo "${hours}h_${minutes}m_${seconds}s,$file" >>  $TMPCSV ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## RUN FOR ALL MP3 FILES 
for mp3file in $(fd -e mp3 --search-path="$(pwd)") ; do 
    FUNC_PRINT_MP3_DURATION_IN_PWD "$mp3file"  
done 
##
echo "################################################################################" ;
echo ; echo ; 
echo ">> CSV file generated. Now printing it ( $TMPCSV )" ; 
echo ; echo ; 
cat $TMPCSV ; 
echo ; echo ; 
echo "##------------------------------------------------------------------------------" ; 
echo ">> CHECK FINAL CSV FILE = $TMPCSV " ; 
echo "##------------------------------------------------------------------------------" ; 

