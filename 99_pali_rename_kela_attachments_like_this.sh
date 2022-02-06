#/bin/bash
## Kela related attachments renaming

##################################################################################
## SET VARIABLES
WORKDIR="$DIR_Y" ;
cd $WORKDIR ;
echo ">> CURRENT WORKING DIRECTORY = $WORKDIR" ;
##
ago0month=$(date +%Y%m) ;
ago1month=$(date --date='-1 month' +%Y%m) ;
ago2month=$(date --date='-2 month' +%Y%m) ;
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
##################################################################################

echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
echo ">> Rename as following: " ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;

## Directory structure
echo "##------------------------------------------------------------------------------" ;
echo "$durationPrefix-Husband-Danske.pdf" ;
echo "$durationPrefix-Husband-Nordea.pdf" ;
echo "$durationPrefix-Nordea-Concepro.pdf" ;
echo "$durationPrefix-Spouse-Nordea.pdf" ;
echo "$durationPrefix-Spouse-Nordea-Perk.pdf" ;
echo "##------------------------------------------------------------------------------" ;
echo "$ago1month-Fortum-Invoice.pdf" ;
echo "$ago1month-YTK-Invoice.pdf" ;
echo "$ago1month-Kotivakuutus.pdf" ;
echo "$ago1month-MAKSUT-Asunto-Oy-Merivesi.pdf" ;
echo "##------------------------------------------------------------------------------" ;
echo "$ago1month-Important-Information.md" ;
echo "$ago1month-Important-Information.pdf" ;
echo "$ago1month-Home-Loan-Interest.png" ;
echo "##------------------------------------------------------------------------------" ;
dateToday="$(date +%Y%m%d)" ;
echo "$dateToday-attachments-list.pdf" ;
echo "$dateToday-personal-message.pdf" ;