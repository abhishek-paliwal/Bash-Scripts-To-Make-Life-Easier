#!/bin/bash
## THIS PROGRAMS RESIZES ALL (png, jpg) IMAGES IN PWD TO 1200px wide dimensions for MGGK 

##------------------------------------------------------------------------------
function FUNC_PRINT_IMAGE_DIMENSIONS () {
    ##
    ## initializing tmpfiles
    echo > $tmpfile0
    echo "## DISPLAYING DIMENSIONS => SORTED FROM SMALLER TO LARGER" | tee -a $tmpfile0  ; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a $tmpfile0 ; 
    ####
    for x in $(fd -e jpg -e png -e jpeg -e gif -e JPG -e PNG -e GIF --search-path="$(pwd)") ; do 
        dimensions=$(identify -format "%wx%h\n" "$x")  ;  
        filesize=$(du -skh "$x")  ;  
        echo "$dimensions $filesize" >> $tmpfile0 ; 
    done
    ####
    ## sort and display
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    sort -n $tmpfile0 ; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
}
#######
functions FUNC_RESIZE_FILES () {
    NEWDIR="$WORKDIR/_resized"; 
    mkdir -p "$NEWDIR" ; 
    echo ">> Now, resizing ... please wait ..." ; 
    for file in *.jpg ; do  convert "$file" -resize 1200x "$NEWDIR/${file%.jpg}.jpg" ;  done
    for file in *.png ; do  convert "$file" -resize 1200x "$NEWDIR/${file%.png}.png" ;  done
    echo ">> Resizing done..." ; 
}
##------------------------------------------------------------------------------

WORKDIR="$DIR_Y" ; 
tmpfile0="$WORKDIR/_tmp00226_images_dimensions_and_filesizes.txt" ; 

echo ">> DISPLAYING DIMENSIONS (BEFORE RESIZING)" ; 
FUNC_PRINT_IMAGE_DIMENSIONS ;

## RESIZING
FUNC_RESIZE_FILES ; 
echo ">> DISPLAYING DIMENSIONS (AFTER RESIZING)" ; 
FUNC_PRINT_IMAGE_DIMENSIONS ;
