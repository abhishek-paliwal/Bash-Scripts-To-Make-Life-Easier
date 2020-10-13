#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    #############################################################################
    ## THIS PROGRAM READS ALL MD FILES FROM A GIVEN CONTENT DIRECTORY AND DELETES
    ## RECIPE JSON + HTML + HUGO VIDEO-SHORTCODES FROM EACH ONE OF THEM.
    ## THESE BLOCKS ARE:
    ## ... mggk_json_recipe JSON block
    ## ... {{< mggkrecipeHTMLcode >}} HTML recipe block
    ## ... {{< mggk-youtube-video-embed >}} HUGO VIDEO SHORTCODE
    #############################################################################
    ## CODED ON: October 5, 2020
    ## BY: Pali
    #############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##################################################################################
## CHOOSE YOUR CORRECT CONTENT DIRECTORY BEFORE RUNNING THIS SCRIPT
##################################################################################

#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-01-50" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-51-100" ;
CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-101-150" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-151-200" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-201-300" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-301-400" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-401-500" ;
#CONTENT_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-501-END" ;

PWD="$HOME_WINDOWS/Desktop/Y" ;
##################################################################################

cd $PWD ;
echo ;
echo "###########################################" ;
echo "Present working directory = $PWD" ;
echo ">> Make REALLY sure that your chosen content directory is OKAY => $CONTENT_DIR" ;
echo "###########################################" ;

## USER CONFIRMATION
read -p ">>>> Check if CONTENT DIRECTORY is OKAY. Press ENTER to continue ..."

##################################################################################
BASENAME_CONTENTDIR=$(basename $CONTENT_DIR) ;
DIR_COPY="$PWD/_original_copied_$BASENAME_CONTENTDIR" ;
mkdir $DIR_COPY

##################################################################################
for x in $CONTENT_DIR/* ; do 
    echo; echo "READING CURRENT FILE => $x" ; 
    file_basename="$(basename $x)" ;
    file_copied="$DIR_COPY/$file_basename"

    ## COPYING THE ORIGINAL MD FILE TO OUR PWD
    cp $x $file_copied ;
    echo "  >> ORIGINAL FILE COPIED AS => $file_copied" ;

    ##################################################################################
    ## DELETING ALL THE UNWANTED JSON + HTML + VIDEO-SHORTCODE ONE BY ONE
    ##################################################################################

    ## Delete mggk json recipe block from the frontmatter
    echo "  >> DELETING = mggk json recipe JSON CODE in frontmatter" ;
    sed '/mggk_json_recipe/,/BLOCK ABOVE THIS -->/d' $file_copied > _tmp1

    ## Delete recipe html code from the main content
    echo "  >> DELETING = mggk recipe HTML CODE from the main content" ;
    sed '/{{< mggkrecipeHTMLcode >}}/,/{{< \/mggkrecipeHTMLcode >}}/d' _tmp1 > _tmp2

    ## Delete mggk youtube shortcode 
    echo "  >> DELETING =  mggk youtube shortcode " ;
    sed '/{{< mggk-youtube-video-embed >}}/,/$/d' _tmp2 > _tmp3

    ## Delete mggk print button + new html recipe block 
    sed '/{{< mggk-print-recipe-button >}}/,/$/d' _tmp3 > _tmp4
    sed '/{{< mggk-INSERT-RECIPE-HTML-BLOCK >}}/,/$/d' _tmp4 > $file_basename

    echo "{{< mggk-print-recipe-button >}}" >> $file_basename
    echo "" >> $file_basename
    echo "{{< mggk-INSERT-RECIPE-HTML-BLOCK >}}" >> $file_basename


    ##################################################################################
done 

##################################################################################
## PRINTING NEXT STEPS
##################################################################################
echo "##------------------------------------------------------------------------------" ;
echo ">>>> NEXT STEPS: " ;
echo "      If everything is okay so far, copy all the final files and replace them with the existing md files present in the original hugo directory." ;
echo "      To do that, run this command => cp _TOCHECK*.md $CONTENT_DIR/"
echo "##------------------------------------------------------------------------------" ;