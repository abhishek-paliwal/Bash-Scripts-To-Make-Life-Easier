#!/bin/bash
##################################################
## THIS PROGRAM MAKES AN INDEX HTML PAGE WITH ALL THE IMAGES
## IN THE PRESENT WORKIND DIRECTORY
## DATE: Friday August 31, 2018
## By: Pali
##################################################
PWD=`pwd` ;
cd $PWD ;
echo "Present working directory: $PWD" ;
##################################################

x="index-of-all-photos.html" ;
touch $x
rm $x

TOTAL_IMAGES=`ls *.*g | wc -l | sed 's/ //g'` ;

echo "<body bgcolor=white><center>" >> $x
echo "<font color=red><h1>DIRECTORY: $PWD</h1></font>" >> $x
echo "<font color=blue><h2>TOTAL IMAGES IN FOLDER: $TOTAL_IMAGES</h2></font>" >> $x
echo "<hr>" >> $x
###################################################

## Taking all jpg/png
for p in *.*g
do
echo "<a href=\"$p\"> <img src=\"$p\" alt=\"$p\" height=20%> </a>" >> $x
done

## Taking all JPG/PNG
for p in *.*G
do
echo "<a href=\"$p\"> <img src=\"$p\" alt=\"$p\" height=20%> </a>" >> $x
done

###################################################
## OPENING DIRECTORY
echo "Opening directory: $PWD" ;
open $PWD ;
