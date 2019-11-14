#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="601-step1-run-this-bash-script-if-website-subfolders-are-present-for-AI-NLP-mggk.sh"
################################################################################
cat << EOF
  ################################################################################
  ## This is the only script in this folder that you need to run for running the
  ## underlying python program and for after-program housecleaning.
  ## This script will look for the subfolders in working directory, such as XX-SITENAME-COM,
  ## and will then loop through all those subfolders by running the following steps for
  ## each subfolder:
  #### Step 1. Go to a subfolder
  #### Step 2. Run the XML sitemap extractor python script, outputting two csv files.
  #### Step 3. Take the simple one of those sitemap csv files, rename it to a text file
  #### and move it to original working directory.
  #### Step 4. Then run the main AI + NLP keywords finder python script, outputting a
  #### final csv file (Optionally an HTML file too. To output the html file too, comment-out
  #### the block in this program where the html file is deleted.)
  ################################################################################
  ## Created on: November 5, 2019
  ## Coded by: Pali
  ###############################################################################
  # USAGE (run the following command):
  # > bash $THIS_SCRIPT_NAME
  ############################################################################
EOF
################################################################################

################################################################################
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN ON VPS SERVER
## OR ELSEWHERE LOCALLY
################################################################################
if [ $USER = "ubuntu" ]; then
  MY_PWD="$HOME/scripts-made-by-pali/600-mggk-ai-nlp-scripts"
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/Y"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi
################################################################################

################################################################################
## SETTING SOME FILENAME VARIABLES
TODAY=$(date +%Y%m%d)
HTML_OUTPUT_FILE_TO_USE="${TODAY}_TMP_601_MGGK_AI_NLP_HTML_OUTPUT.HTML"
CSV_OUTPUT_FILE_TO_USE="${TODAY}_TMP_601_MGGK_AI_NLP_OUTPUT_FOR_FUTURE_ANALYSES.CSV"
TMP_LAST_RUN_SUMMARY_FILE="${TODAY}_TMP_SUMMARY_FOR_LAST_RUN.TXT"

## INITIALIZNG THE TMP SUMMARY FILE
echo "## SUMMARY FILE CREATED AT: $(date)" > $TMP_LAST_RUN_SUMMARY_FILE
echo "===================================" >> $TMP_LAST_RUN_SUMMARY_FILE

################################################################################

################################################################################
## DOWNLOADING THE IMPORTANT SCRIPT FILE + STOPWORDS LIST FROM GITHUB
#### DOWNLOADING THE PYTHON SCRIPT
PYTHON_SCRIPT_TO_DOWNLOAD="601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls.py"
STOPWORDS_TEXTFILE_TO_DOWNLOAD="601-MGGK-PYTHON-RAKE-SmartStoplist.txt"

echo ">>>> DOWNLOADING => $PYTHON_SCRIPT_TO_DOWNLOAD" ; echo;
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls/$PYTHON_SCRIPT_TO_DOWNLOAD

#### DOWNLOADING THE STOPWORDS LIST
echo ">>>> DOWNLOADING => $STOPWORDS_TEXTFILE_TO_DOWNLOAD" ; echo;
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/mggk_bash_scripts/600-mggk-artificial-intelligence-nlp-programs/601-mggk-using-ai-nlp-to-find-keywords-from-list-of-top-google-urls/$STOPWORDS_TEXTFILE_TO_DOWNLOAD

########################################################################################
## BEGIN: DEFINING THE MAIN FUNCTION FOR PARENT DIRECTORY
########################################################################################
function RUN_AI_NLP_KEYWORDS_PYTHON_PROGRAM_FOR_PARENTFOLDER_PWD () {
  START_TIME=$(date)
  echo "CURRENT WORKING DIRECTORY: $(pwd)"
  echo;
  echo ">>>> Running underlying python program: "
  python3 $PYTHON_SCRIPT_TO_DOWNLOAD
  echo ""
  echo ">>>> COPYING OUTPUT HMTL FILE TO WWW DIRECTORY = ${HTML_OUTPUT_FILE_TO_USE}"
  cp ${HTML_OUTPUT_FILE_TO_USE} /var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/

  echo;
  echo ">>>> CHECK IT HERE ON WEB:"
  echo "https://vps.abhishekpaliwal.com/scripts-html-outputs/${HTML_OUTPUT_FILE_TO_USE}"

  END_TIME=$(date)
  echo "PROGRAM STARTED AT: $START_TIME"
  echo "PROGRAM FINISHED AT: $END_TIME"
  echo;
}
########################################################################################
## END: DEFINING THE MAIN FUNCTION FOR PARENT DIRECTORY
########################################################################################

#######################################################################################
## RUNNING THE MAIN FUNCTION UNDER ALL THE DIRECTORIES FOUND IN PWD
#######################################################################################
## Checking out the output from ls -d1 $PWD/*/
ECHO; echo ">>>> LIST OF DIRECTORIES IN $PWD"
ls -d1 $PWD/*/ | nl ;
echo; echo;

########### BEGIN: MAIN FOR LOOP FOR SUBDIRS #################
DIR_NUM=0
for dirname in $(ls -d1 $PWD/*/); do
###########################################
  echo "//////////////////////////////////////////////////////////////////////////" ; echo;
  ((DIR_NUM++))
  CURRENT_DIR=$(echo $dirname | sed 's|\/$||g') ## extracting everything from 1st char to secondlast

  echo "[ DIR# $DIR_NUM ] => CURRENT_DIR = $CURRENT_DIR" ;
  echo;echo ">>>> RUNNING SITEMAP EXTRACTOR =>" ;
  python3 $CURRENT_DIR/9999_mggk_TEMPLATE_SCRIPT-get_all_urls_from_ALL_sitemap_urls.py
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
  echo;

  ## COPYING output csv from python script to the MAIN PWD folder for further processing.
  echo "COPYING => $MY_PWD/_OUTPUT_9999_SITEMAP_ALL_URLS.csv $MY_PWD/601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt" ;
  cp $MY_PWD/_OUTPUT_9999_SITEMAP_ALL_URLS.csv $MY_PWD/601-MGGK-REQUIREMENT-ALL-URLS-FOR-NLP.txt

  ## Running the main python function
  START_TIME=$(date)
  echo "CURRENT WORKING DIRECTORY: $(pwd)"
  echo;
  echo ">>>> Running underlying python program:"
  python3 $MY_PWD/$PYTHON_SCRIPT_TO_DOWNLOAD

  ## MOVING OUTPUT CSV AND HTML FILES AS A RESULT OF ABOVE FUNCTION TO CURRENT_DIR
  mv $MY_PWD/$CSV_OUTPUT_FILE_TO_USE $CURRENT_DIR/
  mv $MY_PWD/$HTML_OUTPUT_FILE_TO_USE $CURRENT_DIR/

  ## HTML OUTPUTS ARE LARGE, HENCE DELETING THE RESULTING HTML FILES IN CURRENT_DIR
  echo;
  echo ">>>> DELETING THE RESULTANT LARGE-SIZED HTML FILE, BECAUSE THEY ARE NOT NEEDED FOR OUR PURPOSE => $CURRENT_DIR/$HTML_OUTPUT_FILE_TO_USE" ;
  rm $CURRENT_DIR/$HTML_OUTPUT_FILE_TO_USE
  echo;

  END_TIME=$(date)
  ## APPENDING THE LAST RUN SUMMARY FILE
  echo "DIR => $CURRENT_DIR" >> $TMP_LAST_RUN_SUMMARY_FILE
  echo "  START TIME: $START_TIME"  >> $TMP_LAST_RUN_SUMMARY_FILE
  echo "  END   TIME: $END_TIME" >> $TMP_LAST_RUN_SUMMARY_FILE
  echo "=============================" >> $TMP_LAST_RUN_SUMMARY_FILE
  echo "" >> $TMP_LAST_RUN_SUMMARY_FILE
  echo;
done
########### END: MAIN FOR LOOP FOR SUBDIRS #################
#################################################################################

## UNCOMMENT THE FOLLOWING LINE FOR FUNCION CALL, RUNNING THE MAIN FUNCTION
## IF RUNNING FOR THE URLs FILE IN PARENT DIRECTORY
# RUN_AI_NLP_KEYWORDS_PYTHON_PROGRAM_FOR_PARENTFOLDER_PWD
