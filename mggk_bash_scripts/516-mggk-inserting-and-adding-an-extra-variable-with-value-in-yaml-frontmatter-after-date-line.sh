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
  ## choice, in markdown files.
  ## ALSO PRESENT => ONE LINE VERSION TO ADD EXTRA FRONTMATTER VARIABLE(s) 
  ## (if you simply want to add new variable(s) above my_custom_variable variable name)
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

################################################################################
################################################################################
## ONE LINE VERSION TO ADD EXTRA FRONTMATTER VARIABLE(s) 
## (if you simply want to add new variable(s) above my_custom_variable variable name)
################################################################################
## STEP1 = The following is an example command (fully working) // copy-paste after uncommenting
#fd --search-path="$REPO_MGGK/content/" -e md -x sed -i .bak "s|my_custom_variable|toc: true\n\nseo_title_value: \"demo title demo title\"\n\nmy_custom_variable|g" {} ;

## STEP2 = Get the value from the existing title and insert into the newly created variable
mydir="$REPO_MGGK/content/"
##
for x in $(ag -l "seo_title_value" "$mydir") ; do 
    echo $x; 
    ## get the existing title value to be inserted into the new one
    new_seo_title=$(grep -irh '^title:' $x | sd 'title' 'seo_title_value') ;
    ##
    sed -i '' "s%seo_title_value.*$%$new_seo_title%g" $x
done

