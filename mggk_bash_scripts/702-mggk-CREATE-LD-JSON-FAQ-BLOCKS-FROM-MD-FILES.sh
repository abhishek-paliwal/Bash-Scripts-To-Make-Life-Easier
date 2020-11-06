#/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS SCRIPT CREATES FAQS JSON FILES BY PARSING ALL MD FILES PRESENT IN THE 
  ## CHOSEN HUGO_CONTENT_DIR.
  ## It then moves all those faqs json files + a faqs summary file to the proper 
  ## hugo project directories.
  ###############################################################################
  ## USAGE: bash $(basename $0)
  ###############################################################################
  ## Coded by: PALI
  ## On: October 12, 2020
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################
## ONLY RUN THIS SCRIPT ON UBUNTU MACHINE, AND NOT ON MAC OS
## Because the sed command on MAC OS returns a different output
if [ $(uname) = "Darwin" ] ; then
    echo "IMPORTANT NOTE: This is MAC OS. This script will exit now. Run this program only from a Linux (ubuntu) Machine." ;
    echo ; 
    exit 1 ;
fi 
##################################################################################

## SETTING VARIABLES
HUGO_CONTENT_DIR="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content/_FIXED" ;
DIR_TO_MOVE_FAQS_FILES="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/FAQS" ;
DIR_TO_MOVE_SUMMARY_FILE="$DIR_GITHUB/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static" ;

TMPDIR="$HOME_WINDOWS/Desktop/Y"
WORKDIR="$TMPDIR/_tmp_faqs" ;
mkdir $WORKDIR ;

cd $TMPDIR ;
echo ">> Current working directory => $TMPDIR" ; echo; 

##------------------------------------------------------------------------------
## Begin: DEFINING MAIN FUNCTION
##------------------------------------------------------------------------------
function extract_content_between_two_successive_faqs () {
################
    ## Reading inline CLI arguments 
    recipe_mdfile=$1 ;
    faqs_json_file_final=$2 ;
    
    recipe_file_basename=$(basename $recipe_mdfile) ;

    recipe_url_tmp=$(grep -irh 'url: ' $recipe_mdfile | sed 's/url: //g') ;
    recipe_url_without_slashes=$(echo $recipe_url_tmp | sed 's+/++g') ;
    recipe_url_final="https://www.mygingergarlickitchen.com/$recipe_url_tmp" ;
    
    recipe_name=$(grep -rh '^title: ' $recipe_mdfile | sed 's/title: //g') ;

    ## create tmp faqs file
    faqs_json_file="$WORKDIR/$recipe_url_without_slashes.tmp99" ;
    tmp_faqs_file="$WORKDIR/$recipe_url_without_slashes.ALLFAQS" ;

    ## GETTING ALL HEADING LEVEL 2 LINES WITH QUESTION MARKS IN THEM
    grep -ir '^## .*?' $recipe_mdfile > $tmp_faqs_file

    ## Counting number of faqs found for this recipe file
    num_lines=$(cat $tmp_faqs_file | wc -l | bc -l) ; 
    number_of_faqs_found=$(($num_lines + 0)) ;
    
    echo "$number_of_faqs_found <= TOTAL FAQs FOUND" ; 

## Only progress if there are faqs found in recipe md file
if [ $number_of_faqs_found -ne 0 ] ; then
##+++++++++++++++++++++++++++++
    ## Outputting first line  
    echo '<script type="application/ld+json">{"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [' > $faqs_json_file
    ####
    for x in $(seq 1 $num_lines) ; 
    do 
        faq_file_final="$WORKDIR/$recipe_url_without_slashes-faq-${x}.FINAL" ;
        faq_file="$WORKDIR/$recipe_url_without_slashes-faq-${x}.tmp1" ;

        ## Using the power of sed to find lines based on their line number
        this_faq=$(sed -n "${x}p" $tmp_faqs_file) ;
        next_faq=$(sed -n "$(($x + 1))p" $tmp_faqs_file) ;

        echo; 
        echo "THIS FAQ =$this_faq " ;
        echo "NEXT FAQ =$next_faq " ;

        ## Using the power of sed to find all text between two phrases
        echo ">> Dumping all text found between these two faqs to this file => $faq_file" ;
        sed -n "/$this_faq/,/$next_faq/p" $recipe_mdfile > $faq_file

        ## CHECK IF NEXT_FAQ VARIABLE HAS NON-ZERO STRING LENGTH
        ## THEN, DELETE THE LINES WITH HASHES AND SOME HUGO SPECIFIC CHARACTERS IN THEM.
        if [ -z "$next_faq" ] ; then
            cat $faq_file | sed "s/$this_faq//g" | grep -v '{{<' > $faq_file.tmp2 ;
        else 
            cat $faq_file | sed "s/$this_faq//g" | sed "s/$next_faq//g" | grep -v '{{<' > $faq_file.tmp2 ;
        fi

        ## DELETING EMPTY LINES + MARKDOWN SPECIFIC HYPERLINKS SYNTAX BRACKETS LINES + IMG lines
        cat $faq_file.tmp2 | sed 's/\*//g' | grep -iv '\<img' | grep -v '\[[0-9]*\]\s*$' | grep -iv '^\s*\[[0-9]*\]' | grep -iv '<script'> $faq_file.tmp3 ;

        ## RUNNNING PANDOC TO CONVERT WHOLE TEXT TO PLAIN TEXT
        pandoc --from markdown --to html5 $faq_file.tmp3 >  $faq_file.tmp4

        ## PREFIXING EACH LINE WITH HTML LINE BREAK
        cat $faq_file.tmp4 > $faq_file_final

        echo "<p><strong>Recommended Next Step: </strong>To get answers to all your questions about this recipe, such as cooking method, tips and tricks, and best ways to serve it, go to  <a href='$recipe_url_final'>${recipe_name}</a></p>" >> $faq_file_final ;

        echo " >> FAQ FILE CREATED =>  $faq_file_final" ;

        data_to_insert=$(cat $faq_file_final | sed 's/"/\\\"/g' ) ;
        faq_name_modified=$(echo $this_faq | sed 's/## //g') ;

        echo " >> faq_file_final =>  $faq_file_final" ;
        echo " >> faqs_json_file =>  $faqs_json_file" ;
        echo " >> faqs_json_file_final =>  $faqs_json_file_final" ;

        mydata="{\"@type\": \"Question\",
        \"name\": \"$faq_name_modified\",
        \"acceptedAnswer\": {
            \"@type\": \"Answer\",
            \"text\": \"$data_to_insert\"
        }}" ;

        echo "$mydata" >> $faqs_json_file ;
        echo " >> JSON DATA INSERTED ..." ;

## APPENDING THE COMMA ON A SEPARATE LINE, BECAUSE
## WE WILL NEED TO REPLACE IT IN THE LAST JSON LINE OF THIS FILE
printf "," >> $faqs_json_file ;
##+++++++++++++++++++++++++++++
    done   
################    
    echo "]} </script>" >> $faqs_json_file

    ## FINALLY CHANGING THE LAST LINE TO MAKE IT VALID JSON FILE
    cat $faqs_json_file  | sed s+,]}+]}+g > $faqs_json_file_final 

fi
}
##------------------------------------------------------------------------------
## End: DEFINING MAIN FUNCTION
##------------------------------------------------------------------------------

## RUNNING THE ABOVE FUNCTION FOR EACH MD FILE 
for recipe_mdfile in $(find $HUGO_CONTENT_DIR/ -type f -name '*.md' ) ;
do
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    myURL=$(grep -irh 'url: ' $recipe_mdfile | sed 's/url: //g' | tr -d '/') ;
    faqs_json_file_final="$TMPDIR/${myURL}.FAQS.json" ;

    echo; 
    echo "##------------------------------------------------------------------------------" ;
    echo ">>>> CURRENT RECIPE MD FILE = > $(basename $recipe_mdfile)" ; echo; 
        
    ## CALLING THE FUNCTION TO EXTRACT FAQS FOR THIS RECIPE MD FILE
    extract_content_between_two_successive_faqs $recipe_mdfile $faqs_json_file_final
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
done

##################################################################################
## BEGIN: CREATING SUMMARY FILE FOR NUMBER OF FAQS FOUND IN EACH MD FILE
##################################################################################
SUMMARY_FILE_VALID_FAQS="_summary_for_faqs_found_and_notfound.html" ;
echo "<pre>" > $SUMMARY_FILE_VALID_FAQS
##############
echo "This file is autocreated by the FAQS bash script." >> $SUMMARY_FILE_VALID_FAQS ;
echo "Created on: $(date)" >> $SUMMARY_FILE_VALID_FAQS ;

echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
echo "## IMPORTANT NOTE: Make sure that there are no slashes in the FAQs, because it messes up the JSON FAQs generation. Replace / or \ characters with brackets before running this program. Search for these characters on this page and replace them in the original MD files." >> $SUMMARY_FILE_VALID_FAQS ;
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 

## summary for 1 or more faqs 
echo "" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
TOTAL_FILES=$(ls $WORKDIR/*.ALLFAQS | wc -l) ;
echo "$TOTAL_FILES = TOTAL NUMBER OF FILES USED FOR FINDING FAQS" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 

## summary for 1 or more faqs 
echo "" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
NUM_FILES_WITH_0_FAQS=$(grep -irL '#' $WORKDIR/*.ALLFAQS | wc -l) ;
echo "$NUM_FILES_WITH_0_FAQS = NUMBER OF FILES FOUND WITH 0 FAQS" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
for y in $(grep -irL '#' $WORKDIR/*.ALLFAQS) ; do echo; echo "========" ; echo "$(cat $y | wc -l) FAQs found in $(basename $y)" ; cat $y | nl ; done >> $SUMMARY_FILE_VALID_FAQS ;

## summary for 0 faqs 
echo "" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
NUM_FILES_WITH_1_OR_MORE_FAQS=$(grep -irl '#' $WORKDIR/*.ALLFAQS | wc -l) ;
echo "$NUM_FILES_WITH_1_OR_MORE_FAQS = NUMBER OF FILES FOUND WITH 1 OR MORE FAQS" >> $SUMMARY_FILE_VALID_FAQS 
echo "##################################################################################" >> $SUMMARY_FILE_VALID_FAQS 
for y in $(grep -irl '#' $WORKDIR/*.ALLFAQS) ; do echo; echo "========" ; echo "$(cat $y | wc -l) FAQs found in $(basename $y)" ; cat $y | nl ; done >> $SUMMARY_FILE_VALID_FAQS ;
##############
echo "<pre>" >> $SUMMARY_FILE_VALID_FAQS
##################################################################################
## END: CREATING SUMMARY FILE FOR NUMBER OF FAQS FOUND IN EACH MD FILE
##################################################################################

## MOVING GENERATED FILES TO THEIR PROPER HUGO DIRECTORIES
echo; 
echo "##################################################################################" ;
echo "## SUMMARY: " ;
echo "## IMPORTANT NOTE: Make sure that there are no slashes in the FAQs in MD files. Replace / or \ characters with brackets before running this program." ;
echo "##################################################################################" ;
mv $TMPDIR/$SUMMARY_FILE_VALID_FAQS $DIR_TO_MOVE_SUMMARY_FILE/ ;
mv $TMPDIR/*.FAQS.json $DIR_TO_MOVE_FAQS_FILES/ ; 
echo ">>>> Moved FAQS JSON files to => $DIR_TO_MOVE_FAQS_FILES/" ;
echo ">>>> Moved SUMMARY file to => $DIR_TO_MOVE_SUMMARY_FILE/" ;

##################################################################################
## KEEP THIS SECTION AT THE BOTTOM OF THIS SCRIPT
##################################################################################
echo; echo ">>>> DELETING ALL TMP UNNECESSARY FILES" ;
rm $WORKDIR/*.tmp*
