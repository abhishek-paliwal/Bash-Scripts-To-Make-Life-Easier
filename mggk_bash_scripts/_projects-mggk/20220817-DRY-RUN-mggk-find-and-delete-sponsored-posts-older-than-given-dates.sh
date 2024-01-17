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
    ## This program only moves those posts which are not to be kept forever. Hence, it's safe.
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
INITIAL_NUMBER_OF_FILES_FOUND_IN_INDIR=$(ls $INDIR | wc -l) ; 
TMPFILE1="$WORKDIR/_tmpSpon1.txt" ; 
TMPFILE2="$WORKDIR/_tmpSpon2.txt" ; 
TMPFILE3="$WORKDIR/_tmpSpon3.txt" ;

################################################################################
## Finding the first published dates for the posts other than DONT_DELETE_POSTS_WITH_THESE_DATES
DONT_DELETE_POSTS_WITH_THESE_DATES="(2024-|2023-|2022-|2021-12)" ; ## Change this accordingly as you please
echo ">> Everything other than these posts will not be deleted ... $DONT_DELETE_POSTS_WITH_THESE_DATES (change the settings in this original program = $THIS_SCRIPT_NAME)" ; 

##
echo; echo "################################################################################" ;  
echo ">> FINDING THE FIRST PUBLISHED DATES FOR THE POSTS OTHER THAN GIVEN DATES ..." ; 
rm $TMPFILE1 ; ## remove if already exists
## Loop through all the posts which are not to be kept forever
echo ">> Don't select those file where, keep_this_post_forever = yes" ; 
for x in $(grep -irL 'keep_this_post_forever: yes' $INDIR/*.md) ; do 
    ## echo $x ; 
    ack 'first_published_on' $x | grep -ivE "$DONT_DELETE_POSTS_WITH_THESE_DATES" >> $TMPFILE1 ; 
done
## Sorting the output
sort -nr $TMPFILE1 | grep -iv '^$' > $TMPFILE2 ; 
################################################################################

## Reading the file line by line and finding the corresponding md files locations
rm $TMPFILE3 ; ## remove if already exists
count=1; 
while read line ; do 
    echo "##------------------------------------------------------------------------------" ; 
    echo "$count ====== $line" ; 
    grep -irl "$line" $INDIR >> $TMPFILE3 ; 
    ((count++)) ; 
done < $TMPFILE2 ; 

## Moving files from original directory to the WORKDIR
echo; echo "################################################################################" ;  
echo ">> MOVING FILES FROM ORIGINAL DIRECTORY TO THE WORKDIR ..." ; 
countA=1;
while read line_filepath ; do 
    echo "--------"  ;
    echo "$countA >>>> CURRENT FILEPATH = $line_filepath" ; 
  ####
    ## FOR DRY RUN, USE cp command. FOR WET RUN, USE mv command. Comment-out the other one.
    cp "$line_filepath" $WORKDIR/ ; #Dry run
    #mv "$line_filepath" $WORKDIR/ ; #Wet run
  ####
    ((countA++)) ;  
done < $TMPFILE3

################################################################################
## SUMMARY
echo; echo "################################################################################" ;  
echo ">> SUMMARY ==>" ;
echo "  $INITIAL_NUMBER_OF_FILES_FOUND_IN_INDIR = TOTAL_FILES_FOUND BEFORE in DIR $INDIR (before running the program)" ; 
echo "  $(cat $TMPFILE3 | grep -iv '^$' | wc -l) = VALID_FILES_FOUND (older than the dates given)" ; 
echo "  $(ls $INDIR | wc -l) = TOTAL_FILES_FOUND AFTER in DIR => $INDIR (after running the program)" ; 

################################################################################
## FINAL IMPORTANT NOTE
echo;
echo "################################################################################" ;  
echo "################################################################################" ;  
echo ">> IMPORTANT NOTES: " ;
echo ">>>> This is the dry run of the program. It will only copy the found mdfiles." ; 
echo ">>>> For the wet run, meaning to actually move the files, comment-out the dry-run cp command on line-82, and uncomment the wet-run mv command on line-83." ; 
echo ">>>> Immediately after running this program, check the Github Desktop in the MGGK HUGO DIR that no unnecessary files have been deleted or moved. This is very important."
echo "################################################################################" ;  
echo "################################################################################" ;  
