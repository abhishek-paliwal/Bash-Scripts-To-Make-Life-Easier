#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;


WORKDIR="$DIR_Y/_output_$THIS_SCRIPT_NAME_SANS_EXTENSION" ; 
mkdir -p $WORKDIR ; 
inFileCSV="$CSV_AWGP" ## get from env variable

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## USER INPUT:
echo; 
echo ">>>> PLEASE PROVIDE THE SEARCH TERM INPUT (press ENTER key to exit) =>" ;
read search_term
echo;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

TMPFILE1="$WORKDIR/_tmp1.txt" ; 
TMPFILE2="$WORKDIR/_tmp2.txt" ; 
TMPFILE3="$WORKDIR/_tmp3.csv" ; 

head -1 $inFileCSV > $TMPFILE1
grep -i "$search_term" $inFileCSV > $TMPFILE2
cat $TMPFILE1 $TMPFILE2 > $TMPFILE3 
## use miller command (mlr) to print the result in xtab format
mlr --c2x --ifs ';' cat "$TMPFILE3" ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
