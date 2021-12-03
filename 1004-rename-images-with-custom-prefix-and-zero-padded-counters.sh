#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ## THIS PROGRAM RENAMES ALL UPPERCASE/lowercase JPG/jpg/PNG/png FILES IN PWD
    ## THRU COMMAND LINE BY ADDING A USER ENTERED CUSTOM PREFIX AND
    ## RUNNING ZERO-PADDED COUNTERS IN THIS FORMAT = YourPrefix-ZeroPaddedCounter.Extension
    ###################################################
    ## Created: 2020-09-03
    ## By: Pali
    ###################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Starting in the present working directory
MAIN_DIR=$(pwd) ;
echo ; echo "Working directory: $MAIN_DIR" ;
cd $MAIN_DIR ;

######################################################################
## Check if PWD is not $HOME . Only then, it will run.
PWD=$(pwd) ;
if [ "$PWD" == "$HOME" ];
then
    echo "PWD is $PWD . Thus, this script will not run in this directory. " ;
    exit 1 ;
fi
######################################################################

####################################################
############### PROGRAM BEGINS #######################

echo ; 
echo ">>>> Current File listing (these will be renamed):" ; 
fd -t f -d1 -e jpg -e png -e JPG -e PNG ;

echo "ENTER YOUR PREFIX [separate words by hyphens only]: " ; 
read myVARNAME ; 

echo ">>>> RENAMING jpgs/pngs/PNGs/JPGs ..." ; 
count=0 ;
for x in $(fd -t f -d1 -e jpg -e png -e JPG -e PNG); do 
    ((count++)) ;
    filename=$(basename "$x")
    extn="${filename##*.}"
    fname="${filename%.*}"
    ##
    numVar=$(printf "%04i" "$count") ; ## ZERO-PADDING (4-INTEGERS TOTAL)
    echo ">> CURRENTLY RUNNING => $filename // $fname // $extn // $numVar // $myVARNAME-$numVar.$extn" ;
    mv "$x" "$myVARNAME-$numVar.$extn" ;
done

echo ; 
echo ">>>> Final File listing:" ; 
fd -t f -d1 -e jpg -e png -e JPG -e PNG ;

####################################################
############### PROGRAM ENDS #######################
