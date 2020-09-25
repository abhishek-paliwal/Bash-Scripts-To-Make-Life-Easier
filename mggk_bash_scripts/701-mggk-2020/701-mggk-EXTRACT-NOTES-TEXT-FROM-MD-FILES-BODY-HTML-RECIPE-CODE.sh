#!/bin/bash
THIS_SCRIPT_NAME="$basename $0" ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ##################################################################################
    ## THIS PROGRAM EXTRACTS ALL VALID NOTES TEXT FROM ALL MD FILES
    ## AND THEN SAVES THOSE FILES IN TWO DIRECTORIES IN PWD AS valid and
    ## invalid notes.
    ##################################################################################
    ## Created on: September 25, 2020
    ## Coded by: Pali
    #########################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##------------------------------------------------------------------------------
HUGODIR="/home/ubuntu/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
TMPDIR_VALID="$HOME_WINDOWS/Desktop/Y/_valid_notes" ;
TMPDIR_INVALID_FILES="$HOME_WINDOWS/Desktop/Y/_invalid_notes" 
mkdir $TMPDIR_VALID ;
mkdir $TMPDIR_INVALID_FILES ;
##------------------------------------------------------------------------------

for x in $(grep -irl '<h3>NOTES:</h3>' $HUGODIR/ ) ; 
do
    echo ">> current file: $x"
    x_new=$(basename $x) ;

    sed -n "/<h3>NOTES:<\/h3>/,/<\/div>/p" $x | tr -d "\'" | xargs | sed 's+<h3>NOTES:</h3>++ig' | sed 's+<!-- /------------/ -->++ig' | sed 's+</div>++ig' | sed 's+<!-- recipe right flexbox ends -->++ig' | sed 's+<br>+\n+ig' | sed 's+<br />+\n+ig' | sed 's+<p>++ig' | sed 's+</p>++ig' | sed 's+<ol>++ig' | sed 's+</ol>++ig'  | sed 's+<li>+\n+ig' | sed 's+</li>++ig'> $TMPDIR_VALID/_TMPNOTES_$x_new.txt ; 
done 

##################################################################################
## BEGIN: Moving empty files + files with invalid notes
##################################################################################
### MOVING TOTALLY BLANK EMPTY FILES TO AN TMP DIRECTORY 
## MOVE IF COUNT OF WORDS IN FILE IS ZERO
for x in $TMPDIR_VALID/*.txt ; 
do 
    myvar=$(cat $x | wc -w ) ; 
    echo "MYVAR = $myvar" ;
    if [ "$myvar" = "0" ] ; then
        echo ; 
        echo ">>>>BLANK FILE = $x" ;  
        cat $x ; 
        mv $x $TMPDIR_INVALID_FILES/
    fi 
done

### MOVING FILES WITH INVALID NOTES
echo ;  
echo ">> BEGIN: Moving Invalid Notes Files to => $TMPDIR_INVALID_FILES" ; 
for y in $(grep -irl 'no notes' $TMPDIR_VALID/** ) ; do mv $y $TMPDIR_INVALID_FILES/ ; done
for y in $(grep -irl 'no special recipe notes' $TMPDIR_VALID/** ) ; do mv $y $TMPDIR_INVALID_FILES/ ; done
for y in $(grep -irl 'no special notes' $TMPDIR_VALID/** ) ; do mv $y $TMPDIR_INVALID_FILES/ ; done
echo ">> END:   Moving Invalid Notes Files to => $TMPDIR_INVALID_FILES" ; 
##################################################################################
## END: Moving empty files + files with invalid notes
##################################################################################

