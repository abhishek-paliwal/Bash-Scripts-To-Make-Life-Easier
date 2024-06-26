#/bin/bash
## delete_chosen_image_files_from_mggk_cdn_based_upon_LROOM_dir_images

INPUT_IMAGES="$HOME/Desktop/_LROOM" ; 
WORKDIR="$DIR_Y" ;
TMPDIR="$WORKDIR/_TMP_00241" ; 
mkdir -p "$TMPDIR" ; 
echo ; 
echo "Wait for some seconds ... working ..." ; 

################################################################################
FUNC_COUNT_IMAGE_FILES_IN_MGGK_CDN() {
    ## count image files
    echo "##------------------------------------------------------------------------------" ; 
    echo ">> COUNTING IMAGE FILES AT THIS TIME IN REPO CDN MGGK ..." ; 
    fd -u --search-path="$REPO_CDN_MGGK" | wc -l ; 
    echo "##------------------------------------------------------------------------------" ; 
}
################################################################################

## LISTING ALL IMAGES TO BE DELETED
TMPFILE1="$TMPDIR/_tmp1.txt" ;  
echo > $TMPFILE1 ; ## initialize
for x in $(fd -u -e jpg -e webp --search-path="$INPUT_IMAGES") ; do 
    BASE_X=$(basename $x) ; 
    fd -u "$BASE_X" --search-path="$REPO_CDN_MGGK" >> $TMPFILE1 ; 
done

echo "IMPORTANT NOTE = FILENAMES WILL BE READ FROM IMAGES PRESENT IN LROOM DIRECTORY HERE => $INPUT_IMAGES" ;
echo ">> These files will be deleted from MGGK CDN ... (CHECK THEM CAREFULLY) ..." ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
cat -n $TMPFILE1 ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

FUNC_COUNT_IMAGE_FILES_IN_MGGK_CDN ; 
echo ">>>> Press 'y' key to delete these image files, any other key to exit. <<<<" ; 

# Read a single character from the user
read -n 1 -s mykey

################################################################################
## ACTUALLY DELETE IMAGE FILES
if [[ $mykey == "y" ]]; then
  echo "You pressed 'y'. Running the code..."
    for x in $(fd -u -e jpg -e webp --search-path="$INPUT_IMAGES") ; do 
        BASE_X=$(basename $x) ; 
        fd -u "$BASE_X" --search-path="$REPO_CDN_MGGK" -x rm {} ; 
    done
    echo ">> RESULT = ALL IMAGES DELETED." ; 
else
  echo "You did not press 'y'. Exiting."
fi
################################################################################

FUNC_COUNT_IMAGE_FILES_IN_MGGK_CDN ; 
