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
    ## Kela related attachments renaming
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: 2016-03-06
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
##
ago0month=$(date +%Y%m) ;
ago1month=$(date --date='-1 month' +%Y%m) ;
ago2month=$(date --date='-2 month' +%Y%m) ;
dateToday="$(date +%Y%m%d)" ;
##
TMPFILE1="$WORKDIR/_tmp1.txt" ; 
TMPFILE2="$WORKDIR/_tmp2.txt" ; 

##################################################################################
echo ">> Enter date duration prefix [201601-201602 .... etc.]" ;
echo "// Press ENTER for using calculated defaults (= $ago2month-$ago1month)" ;
read durationPrefix ; 
## If user input is empty
if [ -z "$durationPrefix" ] ; then 
    echo ">> IMPORTANT NOTE: User chose defaults. " ;
    durationPrefix="$ago2month-$ago1month" ;
else 
    echo ">> IMPORTANT NOTE: User provided input will be used." ;
    durationPrefix="$durationPrefix" ;
fi
##
echo ">> Chosen duration_prefix = $durationPrefix" ;
echo ">> Calculated today date  = $dateToday" ;
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## function definitions
#########
function FUNC1_CREATE_FILE_STRUCTURE_TMPFILE () {
outFile1="$TMPFILE1" ;
outFile2="$TMPFILE2" ;
##
echo "##------------------------------------------------------------------------------ 
1.pdf,$durationPrefix-Husband-Danske.pdf 
2.pdf,$durationPrefix-Husband-Nordea.pdf 
3.pdf,$durationPrefix-Nordea-Concepro.pdf 
4.pdf,$durationPrefix-Spouse-Nordea.pdf 
5.pdf,$durationPrefix-Spouse-Nordea-Perk.pdf 
##------------------------------------------------------------------------------ 
a.pdf,$ago1month-Kotivakuutus.pdf 
b.pdf,$ago1month-MAKSUT-Asunto-Oy-Merivesi.pdf 
c.pdf,$ago1month-YTK-Invoice.pdf 
d.pdf,$ago1month-Fortum-Invoice.pdf 
##------------------------------------------------------------------------------ 
z1.md,$ago1month-Important-Information.md 
z2.pdf,$ago1month-Important-Information.pdf 
z3.png,$ago1month-Home-Loan-Interest.png 
##------------------------------------------------------------------------------ 
x1.pdf,$dateToday-attachments-list.pdf 
x2.pdf,$dateToday-personal-message.pdf" > $outFile1 ;
## 
## Removing lines containing hash symbols
cat $outFile1 | grep -iv '#' > $outFile2 ;
}

#########
function FUNC2_PRINT_MESSAGE () {
    inFile="$TMPFILE2" ; 
    ##
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo ">> MANUAL RENAMING => Rename as following: " ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    ##
    while read line ; do 
        oldname=$(echo $line | cut -d ',' -f1) ; 
        newname=$(echo $line | cut -d ',' -f2) ; 
        echo "$oldname => $newname" ; 
    done < $inFile ;
}

#########
function FUNC4_RENAME_ALL_FILES () {
    inFile="$TMPFILE2" ; 
    ##
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo ">> AUTOMATIC RENAMING => Files will be renamed now ... " ;
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    ##
    while read line ; do 
        oldname=$(echo $line | cut -d ',' -f1) ; 
        newname=$(echo $line | cut -d ',' -f2) ; 
        if [ -f "$oldname" ]; then
            echo "##----------------------" ;
            echo "  $oldname exists. Will be renamed." ;
            echo "  $oldname => $newname" ; 
            mv "$oldname" "$newname" ; 
        else 
            echo "$oldname does not exist. Hence, not renamed."
        fi
        ##
    done < $inFile ;
}

#########
function FUNC3_CREATE_ZIP_BACKUP () {
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
    echo ">> CREATING ZIP BACKUP FROM ALL FILES IN PWD ... " ;
    CURRENT_DIR=$(pwd) ; 
    zip -r "_TMP-$(basename $CURRENT_DIR)".zip * ;
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## Calling functions 
FUNC1_CREATE_FILE_STRUCTURE_TMPFILE ;
FUNC2_PRINT_MESSAGE ;
##
echo ">> DO YOU WANT TO RENAME ALL FILES, ENTER y OR n : " ;
read DeleteFiles ;
if [ "$DeleteFiles" == "y" ]; then
    FUNC3_CREATE_ZIP_BACKUP ;
    FUNC4_RENAME_ALL_FILES ; 
else 
    echo ">> ALRIGHT, NO FILES RENAMED. The program will exit now." ;
    exit 1 ;
fi 
##
