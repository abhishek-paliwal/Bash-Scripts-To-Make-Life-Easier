#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
###################################################################################
## THIS PROGRAM REPLACES THE DATES OF ALL POSTS IN CONTENT DIRECTORY 
## FOR CONCEPRO HUGO WEBSITE WHICH ARE MORE THAN 6 MONTHS OLD.
## THIS PROGRAM CHOOSES FRIDAYS FOR RANDOM REPLACEMENT DATES.
####
## DATE: 2023-11-08
## CREATED BY: PALI
###################################################################################

##############################################################################
## SETTING VARIABLES
ROOTDIR="$REPO_CONCEPRO/content" ; 
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

TMPFILE1="$WORKDIR/_tmpfile1.txt" ; 
TMPFILE1_CUSTOM="$WORKDIR/_tmpfile1_custom_sorted.txt" ;
TMPFILE2="$WORKDIR/_tmpfile2.txt" ; 
TMPFILE3="$WORKDIR/_tmpfile3_fridays.txt" ; 

echo ">> WORKDIR             = $WORKDIR" ;   
echo ">> ROOTDIR FOR MDFILES = $ROOTDIR" ;   

##############################################################################
# FIND YEAR AND MONTH TILL 6 MONTHS AGO INCLUDING PRESENT MONTH
v0=$(gdate -d '0 months ago' +%Y-%m)
v1=$(gdate -d '1 months ago' +%Y-%m)
v2=$(gdate -d '2 months ago' +%Y-%m)
v3=$(gdate -d '3 months ago' +%Y-%m)
v4=$(gdate -d '4 months ago' +%Y-%m)
v5=$(gdate -d '5 months ago' +%Y-%m)

## LIST ALL DATES BEFORE 6 MONTHS AGO
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">> LISTING ALL DATES FOUND IN MDFILES BEFORE 6 MONTHS AGO ..."
ag 'date:' --nofilename "$ROOTDIR" | grep -ivE "^$|$v1|$v2|$v3|$v4|$v5|$v0" | sort | nl ; 

## LIST ALL MDFILES BEFORE 6 MONTHS AGO
grep -ir 'date:' "$ROOTDIR" | grep -ivE "$v1|$v2|$v3|$v4|$v5|$v0" | awk -F ':' '{print $1}' | sort > $TMPFILE1 ;
## CUSTOM SORTING, AS WE WANT THE BLOG POSTS TO UPDATE WITH LATEST DATE ALWAYS
grep -i '/blog/' $TMPFILE1  | grep -iv '_index.md' > $TMPFILE1_CUSTOM ; # CHOOSE FIRST
grep -i '/blog/_index' $TMPFILE1 >> $TMPFILE1_CUSTOM ; # APPEND REST OF LINES
grep -iv '/blog/' $TMPFILE1 >> $TMPFILE1_CUSTOM ; # APPEND REST OF LINES
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">> LISTING ALL MDFILES WITH DATES BEFORE 6 MONTHS AGO ..."
cat $TMPFILE1_CUSTOM | nl ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## IF NO MD FILES ARE FOUND, ADD SOME BLOG POSTS TO IT.
if [ -s "$TMPFILE1_CUSTOM" ]; then
    echo "TMPFILE1_CUSTOM = File is NOT BLANK."
else
    echo "TMPFILE1_CUSTOM = File is BLANK. 4 oldest blog posts paths will be added to it. "  ;
    for x in $(fd -e md --search-path="$ROOTDIR/blog") ; do v1=$(grep -i 'date:' "$x") ; echo "$v1,$x"; done | sort | awk -F ',' '{print $2}' | head -4 >>  $TMPFILE1_CUSTOM ; 
fi
##
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">> LISTING ALL MDFILES WITH DATES BEFORE 6 MONTHS AGO ..."
cat $TMPFILE1_CUSTOM | nl ; 
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## LIST LAST 26 FRIDAYS, (ABOUT IN LAST 6 MONTHS)
for i in {1..26}; do gdate -d "last Friday -$(($i-1)) week" +%Y-%m-%d ; done | sort -r > $TMPFILE2 ; 
echo "##-----------------------------------------------------" ; 
echo ">> LISTING LAST 26 FRIDAYS FROM TODAY ..." ; 
cat $TMPFILE2 | nl ; 
echo "##-----------------------------------------------------" ; 
## REPEAT IF MULTIPLE TIMES IF THERE ARE MORE MD FILES WHERE THE DATES NEED REPLACEMENT
cat $TMPFILE2 $TMPFILE2 $TMPFILE2 $TMPFILE2 > $TMPFILE3 ; 

## CHANGE DATES IN THOSE MD FILES
count=0 ; 
for myfile in $(cat $TMPFILE1_CUSTOM) ; do
    ((count++)) ; 
    echo ">> $count // CURRENT MD FILE = $myfile" ;  
    ######
    # CHOOSE A RANDOM DATE BETWEEN TODAY AND 180 DAYS AGO 
    #tmpDateVar=$(gdate -d "$(date -d '180 days ago' +%Y-%m-%d) + $((RANDOM % 180)) days" +%Y-%m-%d) ;
    ######
    tmpDateVar=$(sed -n "${count}p" "$TMPFILE3") ; ## read corresponding line in fridays file
    newdate="date: ${tmpDateVar}T00:00:00+00:00" ;  
    olddate=$(grep -i 'date: ' $myfile) ;  
    echo "    OLD DATE = $olddate" ;
    echo "    NEW DATE = ${newdate}" ;  
    # replace old date in the original file
    echo "    REPLACING OLD DATE IN MDFILE ..." ; 
    gsed -i "s|${olddate}|${newdate}|g" "$myfile" ; 
done 

