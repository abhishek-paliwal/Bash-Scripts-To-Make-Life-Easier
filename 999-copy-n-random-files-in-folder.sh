#!/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USAGE FOR BASH 
## Print this help as >> this_script_name --help
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ###########################################################
    ## THIS PROGRAM COPIES N-RANDOM FILES TO TMP DIRECTORIES
    ## FROM ALL THE FILES IN A GIVEN DIRECTORY USING 2 DIFFERENT APPROACHES
    ## 1. BY SELECTING EVERY Nth FILE (eg., will select every 5th file after 'ls' from a list of 100 files, etc.)
    ## 2. BY DOING A SHUFFLE COMMAND (TOTALLY RANDOM FILES)
    ## MADE BY: PALI
    ## MADE ON: Thursday September 27, 2018
    ###########################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PWD=$(pwd) ;
echo; echo "Current working directory: $PWD " ;
cd $PWD ;

##################################
echo ; echo "How many files do you want to copy [enter an integer]: " ;
read HOW_MANY_FILES_TO_SELECT
##################################

TMP_DIR="_TMP-$HOW_MANY_FILES_TO_SELECT-EQUIDISTANT_RANDOM_FILES_FOR_TIMESLICE" ;
TMP_DIR_RANDOM="_TMP-$HOW_MANY_FILES_TO_SELECT-TOTALLY_RANDOM_FILES" ;

mkdir $TMP_DIR $TMP_DIR_RANDOM ;

###########################################################
## 1. COMMAND BLOCK TO COPY EQUIDISTANT RANDOM FILES TO TMP_DIR
## FINDING TOTAL FILES IN PWD
NUM_FILES=$(scale=0; ls -1 | wc -l | bc -l) ;

## NOW, FINDING HOW MANY FILES TO SKIP TO GET DESIRED NUMBER OF FINAL FILES
NUM_RANDOM_FILES=$(echo "scale=0; $NUM_FILES/$HOW_MANY_FILES_TO_SELECT" | bc -l ) ;
NUM_RANDOM_FILES=$(echo $NUM_RANDOM_FILES) ;

echo;
echo "<<<<<<<< NUM_FILES: $NUM_FILES // NUM_RANDOM_FILES: $NUM_RANDOM_FILES // HOW_MANY_FILES_TO_SELECT: $HOW_MANY_FILES_TO_SELECT >>>>>>>>>" ;
echo ;

MY_COMMAND="ls -1 *.* | awk 'NR == 1 || NR % $NUM_RANDOM_FILES == 0'" ;
echo "MY_COMMAND: $MY_COMMAND" ;

## ACTUAL COMMAND DOING ALL THE MAGIC
echo "=======> EQUIDISTANT: NOW COPYING $HOW_MANY_FILES_TO_SELECT FILES (--TO-->) $TMP_DIR" ; echo ;
cp $(ls -1 *.* | awk "NR == 1 || NR % $NUM_RANDOM_FILES == 0") $TMP_DIR/ ;

###########################################################

###########################################################
## 2. COMMAND BLOCK TO COPY TOTALLY RANDOM FILES
if [ $(uname) = "Darwin" ] ; then
    MY_COMMAND_RANDOM="ls -1 *.* | gshuf -n$HOW_MANY_FILES_TO_SELECT" ;
else 
    MY_COMMAND_RANDOM="ls -1 *.* | shuf -n$HOW_MANY_FILES_TO_SELECT" ;
fi 
echo "MY_COMMAND_RANDOM: $MY_COMMAND_RANDOM" ;

## ACTUAL COMMAND DOING ALL THE MAGIC
echo "=======> TOTALLY RANDOM: NOW COPYING $HOW_MANY_FILES_TO_SELECT FILES (--TO-->) $TMP_DIR" ; echo ;
if [ $(uname) = "Darwin" ] ; then
    cp $(ls -1 *.* | gshuf -n$HOW_MANY_FILES_TO_SELECT) $TMP_DIR_RANDOM/ ;
else 
    cp $(ls -1 *.* | shuf -n$HOW_MANY_FILES_TO_SELECT) $TMP_DIR_RANDOM/ ;
fi 

###########################################################

## FINALLY OPENING PWD (works on MAC OS)
echo "Opening ... $PWD ..."
open $PWD ; echo ;
