#/bin/bash
################################################################################
## THIS PROGRAM READS READS JPG/PNG IMAGES FROM ORIGINAL CDN FOLDER AND
## CREATES CORRESPONDING MISSING WEBP IMAGES IN ORIGINAL_WEBP DIRECTORY, AND ALSO
## IN VARIOUS OTHER RESOLUTIONS.
## NOTE: THIS PROGRAM USES COMMAND LINE TOOL: cwebp (INFO: https://developers.google.com/speed/webp/docs/cwebp)
## DATE: 2023-10-10
## CREATED_BY: PALI
################################################################################

ROOTDIR="$REPO_CDN/cdn.mygingergarlickitchen.com" ;
ROOTDIR_WEBP="$ROOTDIR/images_webp" ; 
DIR_IM="$ROOTDIR/images/original" ; 
DIR_IM_WEBP="$ROOTDIR/images_webp/original" ; 
##
tmpfile1="$DIR_Y/tmpfile1.txt" ;
tmpfile2="$DIR_Y/tmpfile2.txt" ;   
tmpfile_compare="$DIR_Y/tmpfile_compare.txt"

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_PRINTDIVIDER () {
    echo "##------------------------------------------------------------------------------" ; 
}
####
function FUNC1_WEBP_COMPARE_AND_COPY_IMAGES_TO_WEBP_DIRECTORY () {
    echo ">> RUNNING FUNCTION : $FUNCNAME" ; 
    fd -HIt f -e png -e jpg --search-path="$DIR_IM" -x echo {/.} | sort -u > "$tmpfile1" ; 
    fd -HIt f -e webp --search-path="$DIR_IM_WEBP" -x echo {/.}  | sort -u > "$tmpfile2" ; 
    ## comparing and listing differences 
    diff "$tmpfile1" "$tmpfile2"  | grep -i '<' | sd '< ' '' > "$tmpfile_compare" ;
    ## 
    echo ">> NOTE: These images will be converted to WEBP ... (will be blank if no image differences are found.)" ; 
    cat -n "$tmpfile_compare" ; 
}
####
function FUNC2_WEBP_CREATE_ORIGINAL_WEBP_IMAGES_FROM_ORIGINAL_JPG_PNG () {
    echo ">> RUNNING FUNCTION : $FUNCNAME" ;
    INFILE="$tmpfile_compare" ; 
    INDIR="$DIR_IM" ; 
    dir2make="$DIR_IM_WEBP" ;
    mkdir -p "${dir2make}" ; 
    echo "Created directory, if does not exist already ... (for webp images): $dir2make" ;
    ####
    for filename_sans_extn in $(cat $INFILE) ; do 
        echo ; 
        outfile_webp="$dir2make/${filename_sans_extn}.webp" ; 
        image_path_found=$(fd --search-path="$INDIR" -HItf -- "${filename_sans_extn}.jpg|${filename_sans_extn}.png" | head -1) ; 
        cwebp -short "$image_path_found" -o "$outfile_webp" -q 85 ;
        echo ">> SUCCESS. CREATED IMAGE IN $dir2make : $outfile_webp" ; 
    done
    ####
}
####
function FUNC3_WEBP_RESIZE_ORIGINAL_WEBP_IMAGES_TO_VARIOUS_SIZES () {
    echo ">> RUNNING FUNCTION : $FUNCNAME" ;
    ## resizing webp images to various resolutions using 'cwebp' command
    # Declare an array with directory names
    directories=("350" "425" "550" "675" "800") ; 

    # Loop through the array and create the directories
    for dir in "${directories[@]}"; do
        INFILE="$tmpfile_compare" ; 
        INDIR="$DIR_IM_WEBP" ; 
        dir2make="$ROOTDIR_WEBP/${dir}px" ;
        mkdir -p "${dir2make}" ; 
        echo "Created directory, if does not exist already ... (for webp images): $dir2make" ;
        ####
        #for filename in $(fd -HIt f -e webp --search-path="$INDIR") ; do 
        for filename_sans_extn in $(cat $INFILE) ; do 
            echo ; 
            current_file="$INDIR/${filename_sans_extn}.webp" ; 
            file=$(basename $current_file) ;
            outfile_webp0="$dir2make/${dir}px-${file}" ;  
            # Example command: cwebp input_file -o output_file -resize 600 0 ; ## 0 is needed to resize to 600px wide keeping aspect ratio intact.
            cwebp -short "$current_file" -o "$outfile_webp0" -q 85 -resize "$dir" 0 ; 
            echo ">> SUCCESS. CREATED:  $outfile_webp0" ; 
        done
        ####
    done
}
####
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## RUN FUNCTIONS IN SEQUENCE
FUNC_PRINTDIVIDER ; 
FUNC1_WEBP_COMPARE_AND_COPY_IMAGES_TO_WEBP_DIRECTORY ;
FUNC_PRINTDIVIDER ; 
FUNC2_WEBP_CREATE_ORIGINAL_WEBP_IMAGES_FROM_ORIGINAL_JPG_PNG ; 
FUNC_PRINTDIVIDER ; 
FUNC3_WEBP_RESIZE_ORIGINAL_WEBP_IMAGES_TO_VARIOUS_SIZES ; 
FUNC_PRINTDIVIDER ; 

FUNC_PRINTDIVIDER ; 
echo ">> WEBP PROGRAM RUN FINISHED AT: $(date)" ; 
FUNC_PRINTDIVIDER ; 
