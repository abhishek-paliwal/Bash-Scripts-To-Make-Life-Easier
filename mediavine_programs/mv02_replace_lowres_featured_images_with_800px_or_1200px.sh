#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
################################################################################
## THIS PROGRAM FINDS THE LOW RESOLUTION FEATURED IMAGES AND ALL OTHER IMAGE FILE IN AN MD FILE.
## THE PROGRAM ALSO MAKES A CSV FILE WITH ALL IMAGE DIMESIONS FOR ALL IMAGES IN THAT MD FILE.
## USER IS THEN ASKED TO REPLACE THE URL OF THE FEATURED IMAGE WITH A CHOSEN ONE.
## CREATED: 2024-01-29
## BY: PALI
################################################################################

## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if missing
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

################################################################################
ROOTDIR="$REPO_MGGK/content" ; 
ROOTDIR_IMAGES="$REPO_MGGK/static" ;
##
TMPDIR_MV02="$WORKDIR/__TMPDIR_MV02" ;
mkdir -p "$TMPDIR_MV02" ;   

## Min width for featured images
image_min_width=800;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_STEP1_CREATE_CSV_FILE_WITH_IMAGES_DIMENSIONS () {
    count=0 ; 
    for mdfile in $(fd -HItf -e md --search-path="$ROOTDIR" | head -100000) ; do 
    ######
        ((count++)) ; 
        echo ">> Running $count (=> $mdfile)" ; 
        tmpfile0="$DIR_Y/_tmpfile0.txt" ;
        tmpfile1="$TMPDIR_MV02/_tmpfile_${count}.txt" ; 

        ## find all images in this mdfile
        grep -i '.jpg' $mdfile | sd '.jpg' '.jpg\n' | sd 'src=' '\n' | sd '"' '' | sd ' ' '' |sd 'https://www.mygingergarlickitchen.com' '' | grep -i '.jpg' > $tmpfile0 ;
        ## find only featured image
        featured_image_found=$(grep -i 'featured_image:' $mdfile | sd ' ' '' | sd 'featured_image:' '') ;

        echo "$featured_image_found" > $tmpfile1 ; 
        cat "$tmpfile0" >> $tmpfile1 ; 

        image_path_Featured="$ROOTDIR_IMAGES/$featured_image_found" ; 
        im_width_featured=$(identify -format "%w" "$image_path_Featured") ;
        ## create csv file for matching featured image
        if [ "$im_width_featured" -lt "$image_min_width" ] ; then
            echo "      Featured Image width is less than $image_min_width." ;
            ##
            DIR_MDFILE="$WORKDIR/$(basename $mdfile)" ;
            mkdir -p "$DIR_MDFILE" ;
            ## CREATE DIR TO STORE THE NEW USER CHOSEN FEATURED IMAGE 
            mkdir -p "$DIR_MDFILE/ZZ_USE_THIS_FEATURED_IMAGE" ; 
            ##
            TMPFILE_CSV="$DIR_Y/_tmp_csvfile.txt" ; 
            OUTFILE_CSV="$DIR_MDFILE/$(basename $mdfile).csv" ; 
            echo > $TMPFILE_CSV ; 
            ##
            while read image_line_found ; do 
                image_line=$(echo $image_line_found | sd 'featured_image:|recipe_code_image:' '' ) ; 
                image_path="$ROOTDIR_IMAGES/$image_line" ; 
                dimensions=$(identify -format "%wx%h" "$image_path") ; 
                ## COPY IMAGES
                cp "$image_path" "$DIR_MDFILE/" ; 
                #echo "// $image_line_found" ; 
                #echo "//// $image_path" ; 
                echo "${dimensions},${image_path}" >> $TMPFILE_CSV ;   
            done < $tmpfile1
            grep -iv '^$' $TMPFILE_CSV | sd '//' '/' > $OUTFILE_CSV ; 
        fi 
    ######
    done
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_STEP2_REPLACE_FEATURED_IMAGE_IN_ORIGINAL_MDFILE () {
    INDIR="$WORKDIR" ; 
    TMPFILE0="$WORKDIR/_tmpdirFile.txt" ; 
    for mydir in $(fd --search-path="$INDIR" -HItd 'ZZ_') ; do 
    ######
        echo "##------------------------------------------------------------------------------" ; 
        mydir_dirname=$(dirname $mydir) ; 
        base_mydir_dirname=$(basename $mydir_dirname) ; 
        echo "BASE MYDIR DIRNAME = $base_mydir_dirname" ; 
        ## FIND ORIGINAL MDFILE PATH
        ORIG_MDFILE_FOUND=$(fd --search-path="$REPO_MGGK/content" -HItf "$base_mydir_dirname" ) ; 
        echo ">> FILE = $ORIG_MDFILE_FOUND" ; 
        ## FIND IMAGE FILE IN MYDIR
        replacementImage=$(fd --search-path="$mydir" -e jpg | head -1) ; 
        base_replacementImage=$(basename $replacementImage) ; 
        ##
        if [ -n "$base_replacementImage" ]; then
            echo "Variable is not empty = $base_replacementImage" ; 
            ##
            CSV_FILEPATH="$(fd --search-path="$mydir_dirname" -HItf -e csv -e CSV)" ; 
            filepath_replacementImage=$(grep -i "$base_replacementImage" $CSV_FILEPATH | head -1 | awk -F ',' '{print $2}') ; 
            replaceThisPart="/Users/abhishek/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ; 
            shortpath_replacementImage="${filepath_replacementImage//$replaceThisPart/}"
            ##
            echo "      >> REPLACEMENT IMAGE: $replacementImage" ; 
            echo "      >> REPLACEMENT IMAGE FILEPATH:$filepath_replacementImage" ; 
            echo "      >> REPLACEMENT IMAGE SHORTPATH:$shortpath_replacementImage" ; 
            ##
            ## FINALLY REPLACE IN ORIGINAL MDFILE
            echo ">> REPLACING IN ORIGINAL MDFILE ..." ; 
            sed -i '' "s|^featured_image.*|featured_image: ${shortpath_replacementImage}|" $ORIG_MDFILE_FOUND ; 
            ##
            ## REPLACE THE FEATURED IMAGE IN THE ORIGINAL DIRECTORY
            echo ">> REPLACING THE FEATURED IMAGE IN THE ORIGINAL DIRECTORY ..." ;
            cp "$replacementImage" "$filepath_replacementImage" ;  
        else
            echo "Variable is empty (SO NO CHANGES TO ORIGINAL MDFILE) = $base_replacementImage" ;    
        fi
    ######           
    done  
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

FUNC_STEP1_CREATE_CSV_FILE_WITH_IMAGES_DIMENSIONS ; 
#FUNC_STEP2_REPLACE_FEATURED_IMAGE_IN_ORIGINAL_MDFILE ; 