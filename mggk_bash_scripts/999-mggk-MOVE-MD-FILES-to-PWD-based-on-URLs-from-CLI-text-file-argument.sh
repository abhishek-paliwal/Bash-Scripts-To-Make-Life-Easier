#!/bin/bash

##################################################################################
## SOME VARIABLES (CHANGE THE SOURCE DIR IF NEEDED)
#SOURCE_DIR="$DIR_GITHUB/ZZ-HUGO-TEST/content/top-501-END" ;
SOURCE_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/594x" ;
DIR_TO_MOVE="$HOME_WINDOWS/Desktop/Y/_TMP_md_files_moved" ;
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS SCRIPT TAKES A TEXT FILE CONTAINING URLs AS COMMAND LINE ARGUMENT
  ## INPUT AND READS IT LINE BY LINE.
  ## BASED ON THOSE LINES, IT MOVES ALL MD FILES FROM A GIVEN SOURCE DIRECTORY TO CWD.
  ## Example: SOURCE_DIR (change this if needed) => $SOURCE_DIR 
  ###############################################################################
  ## USAGE: bash THIS_SCRIPT_NAME \$1
  ###############################################################################
  ## Coded by: PALI
  ## On: October 5, 2020
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## MAKING THE TMP DIRECTORY TO STORE FILES
mkdir $DIR_TO_MOVE ;

#### Getting the URLs TXT file from CLI argument
input="$1"

## READING THIS FILE LINE BY LINE
while IFS= read -r line
do
#########################################
echo; 
echo "FOUND LINE => $line" ;

## Reomving the domain name part from each line
line=$(echo $line | sed 's+http://localhost:1313++g' | sed 's+https://www.mygingergarlickitchen.com++g' ) ;

####
for mdfile in $SOURCE_DIR/*.md ; do
  url=$(grep -irh 'url: ' $mdfile | sed 's/url: //g') ;
  if [ "$url" = "$line" ] ; then 
    echo; 
    echo ">>>> $line = LINE IN URLS FILE" ;
    echo ">>>> $url = URL FOUND IN $mdfile" ;
    mv $mdfile $DIR_TO_MOVE/
    echo ">>>> This MDFILE is moved to => $DIR_TO_MOVE" ;
  fi
done
#########################################
done < "$input"

################################################################################
## CHECKING WHICH LINES IN TXT FILE ARE NOT FOUND AS VALID RECIPE MD FILES
## Making 2 temporary files for comparision:
## file 1 = all urls found in the moved files
grep -irh 'url: ' $DIR_TO_MOVE/ | sed 's/url: //g' | sort > _tmp1.txt
## file 2 = all urls found in the original input file
cat $input | sed 's+http://localhost:1313++g' | sed 's+https://www.mygingergarlickitchen.com++g' | sort > _tmp2.txt

## Finding the differences between the 2 tmp files
echo; 
echo "##------------------------------------------------------------------------------" ;
echo ">> FOLLOWING LINES IN INPUT TXT FILE (= $1) ARE NOT FOUND AS VALID ..." ;
echo ">> ... RECIPE MD FILES PRESENT IN GIVEN SOURCE DIRECTORY = $SOURCE_DIR" ;
diff _tmp1.txt _tmp2.txt  | grep -i '>' | nl
echo "##------------------------------------------------------------------------------" ;
