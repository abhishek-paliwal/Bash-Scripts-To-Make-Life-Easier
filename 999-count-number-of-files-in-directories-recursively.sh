#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	################################################################################
	## THIS PROGRAM PRINTS THE NUMBER OF FILES FOUND IN ALL THE SUBDIRECTORIES IN 
	## THE DIRECTORY TREE. 
	## OPTIONALLY IT REQUIRES A CLI ARGUMENT AS THE DIRECTORY FOR
	## WHICH THE FILES COUNT NEEDED TO BE FOUND. IF NO CLI ARGUMENT IS PROVIDED,
	## IT USES THE CURRENT WORKING DIRECTORY FOR THE FILE COUNT.
	################################
	## USAGE: bash THIS_SCRIPT_NAME \$1
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

## CHECK IF THE CLI HAS ARGUMENTS GIVEN
echo "##--------------------------------------" ;
if [ $# -eq 0 ]; then
	DIRPATH=$(pwd) ;
    echo "No arguments provided. Hence, DIRPATH will be current working directory => $DIRPATH " ;
else
	DIRPATH="$1" ;
    echo "CLI Argument provided. Hence, DIRPATH => $DIRPATH " ;
fi

## COUNTING FILES IN ALL SUBDIRECTORIES THROUGH LOOPING
for dir in $(find $DIRPATH -type d | sort) ; do
	## creating an array with all filenames 
 	numfiles=($dir/*)
  	numfiles=${#numfiles[@]}
  	echo "$numfiles FILES present in => $dir" >> /tmp/tmp.txt 
done

## PRINTING FINAL SORTED OUTPUT
echo "##--------------------------------------" ;
echo "==> NOTE: OUTPUT IS NUMERICALLY SORTED (from HIGHER to LOWER)."
echo "##--------------------------------------" ;
cat /tmp/tmp.txt | sort -nr
#echo "##--------------------------------------" ;
#echo "==> OUTPUT SORTED ALPHABETICALLY BY DIRECTORY NAMES:"
#cat /tmp/tmp.txt
##
echo "##--------------------------------------" ;
echo "## SUMMARY FOR DIRECTORY => $DIRPATH" ;
echo "##--------------------------------------" ;
total_folders=$(fd . -t d $DIRPATH | wc -l | awk '{$1=$1;print}') ;
total_files=$(fd . -t f $DIRPATH | wc -l | awk '{$1=$1;print}') ;
total_files_and_folders_recursive=$(fd . $DIRPATH | wc -l | awk '{$1=$1;print}') ;
##
echo "$total_folders => TOTAL FOLDERS + SUBFOLDERS" ;  
echo "$total_files => TOTAL FILES" ;  
echo "$total_files_and_folders_recursive => TOTAL FILES + FOLDERS + SUBFOLDERS" ;

##
echo "##--------------------------------------" ;
echo "## SUMMARY OF FILES BY EXTENSION => $DIRPATH" ;
echo "##--------------------------------------" ;
fd . -t f $DIRPATH | rev | grep '\.' | cut -d '.' -f1 | rev | sort | uniq -c | sort -nr
echo "##--------------------------------------" ;
