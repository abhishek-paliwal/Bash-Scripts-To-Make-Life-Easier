#!/bin/bash
## THIS SCRIPT AUTOMATICALLY ADDS 'CREATION TIME' PREFIX TO IMAGE FILES.
## Created By: Abhishek
## Creation Date: Monday April 3, 2017
#################################
ORIGINAL_DIR="_ORIGINAL" ;
mkdir $ORIGINAL_DIR
#################################
#################################
##PNGs
for f in *.png
do
    filename=`basename -s .png $f` ; ## getting the filename without extension
    cp "$f" "$ORIGINAL_DIR/" ; ## First copying the original file as BACKUP
    mv -n "$f" "$(date -r "$f" +"%Y%m%d-$filename").png" ; ## finally renaming the original file after copying the original
done
#################################
##JPGs
for f in *.jpg
do
    filename=`basename -s .jpg $f` ; ## getting the filename without extension
    cp "$f" "$ORIGINAL_DIR/" ; ## First copying the original file as BACKUP
    mv -n "$f" "$(date -r "$f" +"%Y%m%d-$filename").jpg" ; ## finally renaming the original file after copying the original
done
#################################
#GIFs
for f in *.gif
do
    filename=`basename -s .gif $f` ; ## getting the filename without extension
    cp "$f" "$ORIGINAL_DIR/" ; ## First copying the original file as BACKUP
    mv -n "$f" "$(date -r "$f" +"%Y%m%d-$filename").gif" ; ## finally renaming the original file after copying the original
done
#################################
