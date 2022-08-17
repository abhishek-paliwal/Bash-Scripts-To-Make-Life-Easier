#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME 
    ################################################################################
    ## This program is a dry run. Change somethings to run it for real. However, here's 
    ## what it does ==> 
    ## This program finds and moves the sponsored posts mdfiles which are first published before 
    ## given dates. To change those dates, open this program and change the 
    ## variable known as DONT_DELETE_POSTS_WITH_THESE_DATES
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2022-08-17
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 
####
INDIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/blog/99_uncategorized" ;
TMPFILE1="$WORKDIR/_tmpSpon1.txt" ; 
TMPFILE2="$WORKDIR/_tmpSpon2.txt" ; 
TMPFILE3="$WORKDIR/_tmpSpon3.txt" ;
TMPFILE4="$WORKDIR/_tmpSpon4.txt" ; 
##  
DONT_DELETE_POSTS_WITH_THESE_DATES="(2022-|2021-|2020-12|2020-11|2020-10|2020-09)" ; ## Change this accordingly as you please
##

################################################################################
## finding the first published dates for the posts other than DONT_DELETE_POSTS_WITH_THESE_DATES
echo > $TMPFILE1 ; 
for x in $(fd --search-path="$INDIR") ; do 
    ## echo $x ; 
    ack 'first_published_on' $x | grep -ivE "$DONT_DELETE_POSTS_WITH_THESE_DATES" >> $TMPFILE1 ; 
done
## sorting the output
sort -n $TMPFILE1 | grep -iv '^$' > $TMPFILE2 ; 
################################################################################

## reading the file line by line and finding the corresponding md files locations
echo > $TMPFILE3 ; 
count=1; 
while read line ; do 
    echo "##------------------------------------------------------------------------------" ; 
    echo "$count ====== $line" ; 
    grep -irl "$line" $INDIR >> $TMPFILE3 ; 
    ((count++)) ; 
done < $TMPFILE2 ; 

## Moving files from original directory to the WORKDIR
echo ">> Moving files from original directory to the WORKDIR ..." ; 
while read line_filepath ; do 
    cp "$line_filepath" $WORKDIR/ ; 
done <  $TMPFILE3

################################################################################
## finding posts to keep forever because we would need to move them back (meaning undelete them)
echo "################################################################################" ;  
echo ">> Displaying posts with keep forever tag because they needed to be moved back (meaning undelete them) ..." ; 
echo > $TMPFILE4 ; 
ag 'keep_this_post_forever: yes' -l $WORKDIR >> $TMPFILE4 ; 

################################################################################
## FINAL IMPORTANT NOTE
echo "################################################################################" ;  
echo "################################################################################" ;  
echo ">> IMPORTANT NOTE: Immediately after running this program, check the Github Desktop in the MGGK HUGO DIR that no unnecessary files have been deleted or moved. This is very important."
echo ">>>> This is the dry run of the program." ; 
echo "################################################################################" ;  
echo "################################################################################" ;  
