#!/bin/bash
## THIS PROGRAM RESIZES ALL (png, jpg, webp) IMAGES IN PWD TO 1200px wide dimensions for MGGK 

WORKDIR="$DIR_Y" ; 
tmpfile0="$WORKDIR/_tmp00226_images_dimensions_and_filesizes_listing.txt" ; 
tmpfile1="$WORKDIR/_tmp00226_images_filepaths_listing.txt" ; 

##------------------------------------------------------------------------------
function FUNC_PRINT_IMAGE_DIMENSIONS () {
    ##
    ## initializing tmpfiles
    echo | tee $tmpfile0 $tmpfile1  ; 
    echo "## DISPLAYING DIMENSIONS => SORTED FROM SMALLER TO LARGER" | tee -a $tmpfile0  ; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a $tmpfile0 ; 
    ####
    for x in $(fd -e jpg -e png -e jpeg -e gif -e webp -e JPG -e PNG -e GIF -e WEBP --search-path="$(pwd)") ; do 
        dimensions=$(identify -format "%wx%h\n" "$x")  ;  
        filesize=$(du -skh "$x")  ;  
        echo "$dimensions $filesize" >> $tmpfile0 ; 
        ## PRINTING CURRENT FILEPATHS
        echo "$x" >> $tmpfile1 ; 
    done
    ####
    ## sort and display
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    sort -n $tmpfile0 ; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
}
#######
function FUNC_RESIZE_FILES_IF_SIZE_MORE_THAN_1200PX () {
    INFILE="$tmpfile1" ; 
    NEWDIR="$WORKDIR/_resized_1200px"; 
    NEWDIR_WEBP="$WORKDIR/_resized_1200px_webp"; 
    mkdir -p "$NEWDIR" "$NEWDIR_WEBP" ; 
    echo ">> Now, resizing ... please wait ..." ; 
    desired_width=1200 ; 
    count=0;
    total_files=$(cat $INFILE | wc -l ) ; 
    ####
        while IFS= read -r file_path ; do
           # Check if the line is empty (contains only whitespace or is blank)
            if [[ -z "${file_path}" ]]; then
                continue  # Skip processing empty lines
            fi
            ####
            ((count++)) ; 
            echo ">> CURRENT FILE ($count of $total_files) : $file_path" ; 
            # Get the current image width using 'identify'
            current_width=$(identify -format "%w" "$file_path") ; 
            echo ">> CURRENT WIDTH : $current_width" ; 
            # Check if the image width is less than desired_width
            if [ "$current_width" -le "$desired_width" ]; then
                echo "Skipping resizing for $file_path (already less than $desired_width pixels wide)." ; 
            else
                # Resize the image to desired_width pixels wide
                ########
                # Get the file extension. Use different tools to resize after.
                file_extension="${file_path##*.}"
                if [ "$file_extension" = "webp" ]; then
                    # If the image is a webp file, use cwebp
                    cwebp -short "$file_path" -o "$NEWDIR_WEBP/$(basename $file_path)" -resize "$desired_width" 0 ; 
                else
                    # For other image formats, use imagemagick
                    convert "$file_path" -quality 95 -resize "$desired_width"x "$NEWDIR/$(basename $file_path)" ; 
                fi
                ########
                echo "Resized $file_path to $desired_width pixels wide." ; 
            fi
        done < "$INFILE"
    ####    
    echo ">> Resizing completed ..." ; 
}
##------------------------------------------------------------------------------

echo ">> DISPLAYING DIMENSIONS (BEFORE RESIZING)" ; 
FUNC_PRINT_IMAGE_DIMENSIONS ;

## RESIZING
FUNC_RESIZE_FILES_IF_SIZE_MORE_THAN_1200PX ; 
echo ">> DISPLAYING DIMENSIONS (AFTER RESIZING)" ; 
#FUNC_PRINT_IMAGE_DIMENSIONS ;
