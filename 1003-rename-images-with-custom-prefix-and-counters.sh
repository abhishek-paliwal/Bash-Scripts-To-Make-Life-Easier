#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ## FILENAME: 1003-rename-images-with-custom-prefix-and-counters.sh
    ## THIS PROGRAM RENAMES ALL UPPERCASE/lowercase JPG/jpg/PNG/png FILES IN PWD
    ## THRU COMMAND LINE BY ADDING A USER ENTERED CUSTOM PREFIX AND
    ## RNNING COUNTERS IN THIS FORMAT = YourPrefix-Counter.Extension
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

echo;
echo ">>>> Current file listing: "; 
ls -v1 ; 

echo ;
echo "ENTER YOUR PREFIX [separate words by hyphens only]: " ; 
read myVARNAME ; 

echo ">>>> RENAMING jpgs" ; 
ls -v *.jpg | cat -n | while read n f; do mv -n "$f" "$myVARNAME-$n.jpg"; done ;
echo ">>>> RENAMING JPGs" ; 
ls -v *.JPG | cat -n | while read n f; do mv -n "$f" "$myVARNAME-$n.JPG"; done ;


echo ">>>> RENAMING pngs" ; 
ls -v *.png | cat -n | while read n f; do mv -n "$f" "$myVARNAME-$n.png"; done ; 
echo ">>>> RENAMING PNGs" ; 
ls -v *.PNG | cat -n | while read n f; do mv -n "$f" "$myVARNAME-$n.PNG"; done ; 

echo ; 
echo ">>>> Final File listing:" ; 
ls -v1 ;

####################################################
############### PROGRAM ENDS #######################
