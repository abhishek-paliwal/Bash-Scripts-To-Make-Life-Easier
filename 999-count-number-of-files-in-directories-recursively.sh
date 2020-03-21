#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	################################################################################
	## THIS PROGRAM PRINTS THE NUMBER OF FILES FOUND IN ALL THE SUBDIRECTORIES IN 
	## THE DIRECTORY TREE
	## USAGE: bash THIS_SCRIPT_NAME
	################################
	## CREATED BY: PALI
	## CREATED ON: 2020-02-05
	#################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## NEEDED FOR PROPER PRINTING OF OUTPUT
shopt -s nullglob

## creating a temporary file in tmp directory
echo > /tmp/tmp.txt

## COUNTING FILES IN ALL SUBDIRECTORIES THROUGH LOOPING
for dir in $(find . -type d) ; do
	## creating an array with all filenames 
 	numfiles=($dir/*)
  	numfiles=${#numfiles[@]}
  	echo "$numfiles FILES present in => $dir" >> /tmp/tmp.txt 
done

## PRINTING FINAL SORTED OUTPUT
cat /tmp/tmp.txt | sort -nr
