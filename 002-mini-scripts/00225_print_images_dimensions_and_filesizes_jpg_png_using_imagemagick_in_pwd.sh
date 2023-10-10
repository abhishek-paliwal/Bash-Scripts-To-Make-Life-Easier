#!/bin/bash
## THIS PROGRAMS PRINT ALL IMAGES DIMENSIONS (sorted) USING IMAGEMAGICK - PNG, JPG, png, jpg, webp.

##------------------------------------------------------------------------------
WORKDIR="$DIR_Y" ; 
tmpfile0="$WORKDIR/_tmp00_images_dimensions_and_filesizes.txt" ; 
tmpfile1="$WORKDIR/_tmp01_images_dimensions.txt" ; 
tmpfile2="$WORKDIR/_tmp02_images_filesizes.txt" ; 

echo ">> CURRENT DIR = $(pwd)" ; 

## initializing tmpfiles
echo | tee $tmpfile0 $tmpfile1 $tmpfile2 ;
echo "## FILE SIZE => SORTED FROM SMALLER TO LARGER" | tee -a $tmpfile0 $tmpfile1 $tmpfile2 ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a $tmpfile0 $tmpfile1 $tmpfile2 ; 

for x in $(fd -HIt f -e jpg -e png -e jpeg -e gif -e JPG -e PNG -e GIF -e webp -e WEBP --search-path="$(pwd)") ; do 
    dimensions=$(identify -format "%wx%h\n" "$x")  ;  
    filesize=$(du -skh "$x")  ;  
    echo "$dimensions $filesize" >> $tmpfile0 ; 
    echo "$dimensions $x" >> $tmpfile1 ; 
    echo "$filesize" >> $tmpfile2 ; 
done

## sort and display
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
sort -n $tmpfile0 ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
sort -n $tmpfile1 ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
sort -h $tmpfile2 ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
