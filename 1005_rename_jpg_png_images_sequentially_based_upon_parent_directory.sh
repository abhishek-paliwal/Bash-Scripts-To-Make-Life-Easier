#!/bin/bash
##############################################################################
## rename files based upon their parent directory
function FUNC_RENAME_FILES_SEQUENTIALLY () {
    c=$1 ;
    c1=$( printf '%03d' $c) ; 

    myfullpath="$(dirname $x)" ;
    myDirname="$(basename $myfullpath)" ;  

    x_base="$(basename $x)" ;
    x_newname="$myDirname-$c1.jpg" ; 

    echo "  ORIG = $x_base" ; 
    echo "  NEW = $x_newname" ; 

    echo ; echo ; echo ">>>> MOVING ... ($x_base => $x_newname)" ; 
    mv $x_base $x_newname ; 
}
##############################################################################
##############################################################################
## RENAME ALL JPG FILES
count=0;
for x in $(fd -e jpg -e JPG -t f --search-path="$(pwd)"); do
    ((count++))
    FUNC_RENAME_FILES_SEQUENTIALLY $count ;
done
###################################
## RENAME ALL PNG FILES
count=0;
for x in $(fd -e png -e PNG -t f --search-path="$(pwd)"); do
    ((count++))
    FUNC_RENAME_FILES_SEQUENTIALLY $count ;
done