#!/bin/bash
################################################################################
## THIS PROGRAM PRINTS THE NUMBER OF FILES FOUND IN ALL THE SUBDIRECTORIES IN 
## THE DIRECTORY TREE
## USAGE: bash THIS_SCRIPT_NAME
################################
## CREATED BY: PALI
## CREATED ON: 2020-02-05
#################################################################################

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
