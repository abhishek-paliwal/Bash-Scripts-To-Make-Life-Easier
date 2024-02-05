#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    # This enables => 'palidivider' command, which prints a fancy divider on cli 
    # Eg. palidivider "THIS IS A TEST STRING." "$palihline | $palialine | $palibline | $palimline | $palipline | $palixline"
    palidivider "Running $FUNCNAME" ;
}
FUNC_SOURCE_SCRIPTS ; 
palidivider ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

INDIR="$REPO_MGGK/content/allrecipes" ; 
TMPFILE1="$WORKDIR/_tmpfile1.txt" ;
TMPFILE2="$WORKDIR/_tmpfile2.txt" ;
OUTFILE="$WORKDIR/_tmpfinal_number_of_images.txt" ;

echo > $TMPFILE1 ; 
echo > $TMPFILE2 ; 
echo > $OUTFILE ; 

count=0;
for x in $(fd -u --search-path="$INDIR" -e md) ; do 
    ((count++)); 
    echo ">> Currently running = $count" ; 
    grep -irh '.jpg' "$x" | grep -i 'figure ' > $TMPFILE1 ; 
    numImages=$(cat "$TMPFILE1" | wc -l) ; 
    echo "$numImages,$x" >> $TMPFILE2 ; 
done 

## sort and display the result
palidivider ">> PRINTING RESULTS ..." ; 

sort -n "$TMPFILE2" > "$OUTFILE" ;
cat "$OUTFILE" ;

palidivider "Check Results File = $OUTFILE" ; 
