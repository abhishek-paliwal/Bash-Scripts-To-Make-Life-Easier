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
ROOTDIR="$REPO_MGGK/content/allrecipes" ; 
ROOTDIR_IMAGES="$REPO_MGGK/static" ; 

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
        tmpfile1="$WORKDIR/_tmpfile_${count}.txt" ; 

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
            grep -iv '^$' $TMPFILE_CSV > $OUTFILE_CSV ; 
        fi 
    ######
    done
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_STEP1_CREATE_CSV_FILE_WITH_IMAGES_DIMENSIONS ; 
