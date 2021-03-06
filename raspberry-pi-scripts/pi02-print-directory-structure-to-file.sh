#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    # Purpose: Writes directory structures to a TXT file
    # Created on : Monday January 13, 2020
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#############################################################################

TODAY=$(date +%Y%m%dT%H:%M:%S) ;

FILE_DATE=$(date +%Y%m%d) ;
OUTPUT_TXTFILE="/home/pi/pali_personal/my-pi-scripts/_output_data_from_scripts/${FILE_DATE}-pi02-print-directory-structure-to-file-output.txt" ;

DIR1="/home/pi" ;
DIR2="/home/_AUDIOJUNGLE_MUSIC" ;

## Printing tree structures
echo "Output produced by cronjob at: $TODAY" > $OUTPUT_TXTFILE   ;
echo "##################################################" >> $OUTPUT_TXTFILE ;
tree $DIR1 >> $OUTPUT_TXTFILE ;
echo "##################################################" >> $OUTPUT_TXTFILE ;
tree $DIR2 >> $OUTPUT_TXTFILE ;


