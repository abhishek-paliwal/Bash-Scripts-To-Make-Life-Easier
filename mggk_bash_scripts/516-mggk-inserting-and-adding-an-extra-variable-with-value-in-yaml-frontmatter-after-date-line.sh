#!/bin/bash
################################################################################
## THIS PROGRAM SHOULD NEVER BE RUN AGAIN, EVER. SO, DISPLAYING ERROR MESSAGE.
echo ">>>> THIS SCRIPT SHOULD NEVER BE RUN AGAIN, NOT EVEN BY MISTAKE. ITS JOB IS DONE." ;
echo ">>>> HENCE, THE PROGRAM WILL EXIT NOW."
exit 1;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## This program adds (inserts) extra yaml frontmatter variable(s) of your 
  ## choice in mggk markdown files.
  ###############################################################################
  ## CREATED ON: 2021-08-26
  ## CREATED BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

mydir="$REPO_MGGK/content/"
#mydir="$REPO_ZZMGGK/content/blog"

################################################################################
function func_create_new_frontmatter_variables () {
    ## Add frontmatter variables to those files where seo_title_value is not found 
    ## Adds three new variable before title tag: toc, seo_title_value, my_custom_variable. 
    for mdFile in $(ag -L "seo_title_value" "$mydir") ; do 
        sed -i '' "s|^title|toc: true\n\nseo_title_value: \"demo title demo title\"\n\nmy_custom_variable: \"custom_variable_value\"\n\ntitle|g" $mdFile ;
    done 
}
########################################
function func_insert_value_to_seo_title_value () {
    ## Replace exiting frontmatter variable value from another variable
    ## Replaces value of seo_title_value from exiting title value.
    for x in $(ag -l "seo_title_value" "$mydir") ; do 
        echo $x; 
        ## get the existing title value to be inserted into the new one
        new_seo_title=$(grep -irh '^title:' $x | sd 'title' 'seo_title_value') ;
        ##
        sed -i '' "s%seo_title_value.*$%$new_seo_title%g" $x
    done
}
################################################################################

## STEP1 = The following is an example command (fully working) // copy-paste after uncommenting
func_create_new_frontmatter_variables

## STEP2 = Get the value from the existing title and insert into the newly created variable
func_insert_value_to_seo_title_value
