#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="517-mggk-delete-every-2nd-csv-file-and-keep-max-15-csv-files-in-subdirs.sh"
################################################################################
cat << EOF
  ################################################################################
  ## THIS SCRIPT RUNS AS CRONJOB EVERYDAY, AND DELETES EVERY Nth CSV FILE PRESENT
  ## UNDER ALL SUBDIRS INSIDE A DIRECTORY. THIS IS TO ENSURE THAT WE DON'T PILE UP
  ## MANY CSV FILES AS OUTPUTTED FROM RUNNING MANY SCRIPTS.
  ## FOR EXAMPLE, WE HAVE CHOSEN N=16, i.e. IF TOTAL CSV FILES IN A SUBDIR IS MORE THAN 16, THEN
  ## THIS DELETES EVERY 2ND FILE, MEANING ON ANY GIVEN DAY AFTER THIS SCRIPT RUNS,
  ## WE WILL HAVE ABOUT 8-16 CSV FILES REMAINING.
  ################################################################################
  ## USAGE:
  ##> bash $THIS_SCRIPT_NAME
  ################################################################################
  CREATED ON: Monday December 16, 2019
  CREATED BY: PALI
  ################################################################################
EOF

##------------------------------------------------------------------------------
## ASSIGNING THE MAIN PWD DEPENDING UPON WHETHER THIS PROGRAM IS RUN: ON VPS SERVER
## OR ELSEWHERE LOCALLY
if [ $USER = "ubuntu" ]; then
  MY_PWD="$HOME/scripts-made-by-pali/517-mggk-delete-every-2nd-csv-file"
  echo "USER = $USER // USER is ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
else
  MY_PWD="$HOME/Desktop/X"
  echo "USER = $USER // USER is not ubuntu. Hence, MY_PWD will be: $MY_PWD " ;
fi
##------------------------------------------------------------------------------

################################################################################
TMP_LOGFILE="$MY_PWD/_TMP_PROGRAM_LOGFILE_517_SCRIPT.TXT" ;
## INITILIZING TMP_LOGFILE
echo "FILE CREATED AT: $(date)" > $TMP_LOGFILE
echo "FILE CREATED BY: $THIS_SCRIPT_NAME" >> $TMP_LOGFILE
echo "==================================================" >> $TMP_LOGFILE

################################################################################
## DEFINING MAIN FUNCTION
FUNC_DELETE_EVERY_2ND_CSVFILE () {
  LOOK_IN_DIR="$1" ;
  total_files_to_delete=$(ls $LOOK_IN_DIR/*.CSV |sort -n| awk 'NR % 2 == 0 { print }' $N | wc -l) ;
  echo ">>>> LOOKING AT CSV FILES IN THIS DIRECTORY => $LOOK_IN_DIR" ;
  echo ">>>> TOTAL NUMBER OF CSV FILES TO DELETE => $total_files_to_delete"  ;
  ## LISTING + ACTUAL DELETION BELOW
  echo; echo ">>>>>>>> THESE FILES WILL BE DELETED..." ;
  ls $LOOK_IN_DIR/*.CSV |sort -n| awk 'NR % 2 == 0 { print }' ;
  ## ACTUAL DELETION
  ls $LOOK_IN_DIR/*.CSV |sort -n| awk 'NR % 2 == 0 { print }' | xargs rm -f ;
  echo; echo ">> DONE! $total_files_to_delete CSV FILES DELETED IN $LOOK_IN_DIR."
}

################################################################################
## GOING THROUGH ALL THE DIRECTORIES STARTING WITH 601*
for dirname in $(ls -d1 $MY_PWD/601*/); do
  echo "" | tee -a $TMP_LOGFILE
  echo; echo "#######################################################################";
  echo "=> CURRENT DIRECTORY = $dirname" ;
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ## FIND TOTAL NUMBER OF CSV FILES IN THIS DIRECTORY
  total_csvfiles=$(ls $dirname/*.CSV | wc -l | sed 's/ //g') ;
  ## DO SOMETHING IF TOTAL FILES ARE MORE THAN 16
  NUM_FILES_TO_KEEP=16 ;
  if [[ "$total_csvfiles" -gt "$NUM_FILES_TO_KEEP" ]]; then
    echo "CURRENT DIRECTORY => $dirname" | tee -a $TMP_LOGFILE
    echo ">>>> SUCCESS // TOTAL NUMBER OF FILES ARE MORE THAN $NUM_FILES_TO_KEEP (= $total_csvfiles). HENCE, CSV FILES WILL BE DELETED." | tee -a $TMP_LOGFILE
    ## RUNNING THE DELETION FUNCTION
    FUNC_DELETE_EVERY_2ND_CSVFILE $dirname | tee -a $TMP_LOGFILE
  else
    echo "CURRENT DIRECTORY => $dirname" | tee -a $TMP_LOGFILE
    echo ">>>> FAILURE // TOTAL NUMBER OF FILES ARE LESS THAN OR EQUAL TO $NUM_FILES_TO_KEEP (= $total_csvfiles). HENCE, NO CSV FILES WILL BE DELETED." | tee -a $TMP_LOGFILE
  fi
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
done
