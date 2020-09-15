#!/bin/bash

THIS_SCRIPT_NAME=$(basename $0) ;
THIS_SCRIPT_NAME_WITHOUT_EXTENSION=$(echo $THIS_SCRIPT_NAME | sed 's/.sh//g') ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## THIS SCRIPT READS url AND featured_image TAGS IN THE FRONTMATTER OF ALL
    ## MD FILES IN HUGO_CONTENT_DIRECTORY FOR MYGINGERGARLICKITCHEN.COM WEBSITE. 
    ## IT THEN COPIES THEM TO PRESENT WORKING DIRECTORY AND ALSO RENAMES THEM
    ## BASED UPON THE url FOUND IN FRONTMATTER.
    ################################################################################
    ## CREATED ON: 2020-09-15
    ## CREATED BY: PALI
    ################################################################################
    ## USAGE:
    #### bash $THIS_SCRIPT_NAME
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
ROOTDIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL" ;
BASEDIR="$ROOTDIR/content" ; 
BASEDIR_IMAGE="$ROOTDIR/static" ; 
WORKINGDIR="$HOME_WINDOWS/Desktop/Y" ;
DOWNLOAD_DIR="$WORKINGDIR/_TMP_DOWNLOADS_$THIS_SCRIPT_NAME_WITHOUT_EXTENSION" ;
##
mkdir $DOWNLOAD_DIR ;
##
TMP_OUTFILE="$WORKINGDIR/_TMP_$THIS_SCRIPT_NAME_WITHOUT_EXTENSION.txt" ;
echo "// TMP file created on: $(date) //" > $TMP_OUTFILE ; ## Writing blank first line
################################################################################

echo; echo ">>>> Present working directory: $WORKINGDIR" ;
echo ">>>> Images will be copied and renamed to: $DOWNLOAD_DIR" ;
echo;

## User confirmation to continue
read -p "If PWD is correct, please press ENTER to continue ..." ;
echo ">>>>>>>>>>>>>>>>> GOOD TO GO ... >>>>>>>>>>>>>>>>>>>>" ;
################################################################################

##------------------------------------------------------------------------------
## FINDING TOTAL FILES WITH VALID url TAG AND PROCESSING THEM ONE BY ONE:
TOTAL_FILES=$(grep -irl 'url: ' $BASEDIR/* | wc -l) ;

## BEGIN: FOR LOOP ##
COUNT=1;
for x in $(grep -irl 'url: ' $BASEDIR/*) ;
do
    ## Reading url and featured_image tags
    URL=$(grep -i 'url: ' $x | sed 's+url: ++g' | sed 's+/++g') ;
    IMAGE=$(grep -i 'featured_image: ' $x | sed 's/featured_image: //g') ;
    
    ## Creating new image name
    NEW_IMAGE="$DOWNLOAD_DIR/$URL.jpg" ;
    
    ## Actually copying and renaming the featured image
    cp $BASEDIR_IMAGE/$IMAGE $NEW_IMAGE ;
    echo "Copying + Renaming done => IMAGE $COUNT of $TOTAL_FILES" ;

## The following HEREDOC block should not be indented at all ## 
cat << EOF >> $TMP_OUTFILE
COUNT = $COUNT ;
URL = $URL ;
IMAGE = $IMAGE" ; 
NEW DOWNLOADED IMAGE = $NEW_IMAGE ;  
========================== 
EOF
    ## Updating the running counter
    COUNT=$((COUNT+1))
done
## END: FOR LOOP ##
##------------------------------------------------------------------------------

