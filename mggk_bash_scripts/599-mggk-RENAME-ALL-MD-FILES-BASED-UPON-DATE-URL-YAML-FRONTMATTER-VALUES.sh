#!/bin/bash
################################################################################
THIS_SCRIPT_NAME="599-mggk-RENAME-ALL-MD-FILES-BASED-UPON-DATE-URL-YAML-FRONTMATTER-VALUES.sh"
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS PROGRAM RENAMES ALL MD FILES FOUND IN HUGO_CONTENT_DIR BASED UPON THE
  ## VALUES OF date AND url FRONTMATTER VARIABLE VALUES.
  ###############################################################################
  ## CODED ON: Friday September 27, 2019
  ## CODED BY: PALI
  ###############################################################################
  ## STEPS OF LOGICAL EXECUTION:
  #### 1. Create a zip backup of full hugo-content-directory containing md files
  #### 2. Finding dates and url in yaml frontmatter of all files in content directory
  #### 3. Create a new filename based upon the those variable values.
  #### 4. Finally, rename the existing file with the new filename, replacing the original.
  #### 5. Check everything is as it should be in Github Desktop. Make sure that
  #### the filenames have indeed been changed.
  ###############################################################################
  # USAGE (run the following command):
  # > bash $THIS_SCRIPT_NAME
  ############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################

## VARIABLE SETTING
################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content" ;
#HUGO_CONTENT_DIR="$HOME/Desktop/Z/content"
OUTPUT_DIR="$HOME/Desktop/Y/"
OUTPUT_HTML_FILE="$OUTPUT_DIR/_TMP_OUTPUT_FILE.HTML"
OUTPUT_HTML_FILE_RENAMED_ONLY="$OUTPUT_DIR/_TMP_OUTPUT_FILE_RENAMED_ONLY.HTML"

## DELETE HTML FILES IF ALREADY EXISTS
rm $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE

################################################################################
#################### DON'T CHANGE ANYTHING BELOW THIS LINE #####################
################################################################################

cd $OUTPUT_DIR ;

PWD=$(pwd) ;
echo; echo ">>>> Present working directory: $PWD" ;
echo;

## User confirmation to continue
read -p "If PWD is correct, please press ENTER to continue ..." ;
echo ">>>>>>>>>>>>>>>>> GOOD TO GO ... >>>>>>>>>>>>>>>>>>>>" ;
################################################################################

## FIRST IMPORTANT THINGS FIRST, WE WILL MAKE A ZIP BACKUP OF THE ORIGINAL DIRECTORY
## BEFORE MAKING ANY CHANGES TO THE EXISTING FILE. THIS IS A PRECAUTION.
BACKUP_DATE_PREFIX=$(date '+%Y-%m-%d-%H%M%S') ;
BACKUP_ZIPFILE_NAME="$PWD/$BACKUP_DATE_PREFIX-BACKUP-of-2019-HUGO-MGGK-WEBSITE-OFFICIAL-content-directory.zip"

zip -r $BACKUP_ZIPFILE_NAME $HUGO_CONTENT_DIR ;
echo;
echo "==> BACKUP ZIP FILE CREATED of directory (= $HUGO_CONTENT_DIR) ==> $BACKUP_ZIPFILE_NAME " ;

################################################################################
## USER CONFIRMATION TO CONTNUE TO
## SEE IF EVERYTHING IS OKAY, ELSE PRESS CTRL+C to stop
echo;
#say "LISTEN TO THIS WARNING! This program will now try to rename all files replacing the originals. Press ENTER key, if OKAY to proceed ..." ;

read -p ">>>>>>>>>>>>>>>>> IF ALL IS OKAY, then press ENTER key to continue ... (else press ctrl+c to cancel)" ;
echo ;

################################################################################
########################## REAL MAGIC BEGINS BELOW
################################################################################

## INITIALIZING THE TWO TEMPORARY HTML OUTPUT FILES
echo "<!doctype html>
<html lang='en'>
  <head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>

    <!-- Bootstrap CSS -->
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'>

    <title>Program output</title>
  </head>
  <body>
  <div class='container'><!-- BEGIN: main containter div -->" | tee -a $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE

echo "<h1>LIST OF MD FILES (ONLY RENAMED)</h1>" >> $OUTPUT_HTML_FILE_RENAMED_ONLY
echo "<h1>LIST OF MD FILES (ALL + RENAMED)</h1>" >> $OUTPUT_HTML_FILE

echo "<h4>UNDER DIRECTORY = $HUGO_CONTENT_DIR</h4>" >> $OUTPUT_HTML_FILE

echo "<h6 style='color:red;'>THE FOLLOWING FILES HAVE BEEN RENAMED IN THE FOLLOWING DIRECTORIES.</h6>" >> $OUTPUT_HTML_FILE
echo "<hr><h5>COLOR-KEY: RED = renamed // LIGHT-BLUE = not renamed</h5></hr>" >> $OUTPUT_HTML_FILE

############### BEGIN LOOP 1: LOOPING THRU DIRECTORIES IN THE MAIN-DIR #########
counter_directories=0;
counter=0;
counter_valid=0;
counter_invalid=0;

for d in $(find $HUGO_CONTENT_DIR -type d) ;
do
((counter_directories++))
echo "=========================================================================";
echo "$counter_directories // DIRECTORY FOUND = $d" ;
echo "<hr><h5 style='color:blue;'>$counter_directories // DIRECTORY FOUND = $d</h5>" | tee -a  $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE ;
echo "=========================================================================";

## Change the directory, so that the file listing can be done in that directory
cd $d

  ################ BEGIN LOOP 2: LOOPING THRU FILES IN EACH DIR THUS FOUND #####
  echo "<table class='table table-bordered text-center'>" | tee -a $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE

  echo "<thead class='thead-dark'><tr>
  <th scope='col'>FILE COUNTER</th>
  <th scope='col'>EXISTING NAME</th>
  <th scope='col'>NEW NAME</th>
  </tr></thead>
  <tbody>" | tee -a $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE

  #### Listing all files except the ones which have the words '_index' in name.
  #### IMPORTANT NOTE: Make sure that there are no _index.md file renamed at the end of this program.
  for f in $(ls *.md | grep -v '_index');
  do
    ((counter++))
    echo; echo "  FILE-$counter // FILE FOUND = $f" ;

    ## NOW THE NEW FILE NAME WILL BE CALCULATED
    #### NEW NAME PREFIX = date frontmatter variable value (colons removed)
    #### NEW NAME SUFFIX = url frontmatter variable value (slashes removed)
    new_prefix=$(grep -i '^date: ' $f | sed -e 's|date: ||g' -e 's|:||g' -e 's|+0000||g' -e 's|T|-T|g' ) ;
    new_suffix=$(grep -i '^url: ' $f | sed -e 's|/||g' -e 's|url: ||g' ) ;

    ## finalizing the new filename
    new_name="$new_prefix-$new_suffix.md" ;

    ## COMPARE THE OLD AND THE NEW NAME. RENAME ONLY IF THEY ARE DIFFERENT.
    if [[ "$f" == "$new_name" ]]
    then
      ((counter_invalid++))
      echo "    FILE-$counter // File WILL NOT BE renamed. Because old name and new name are the same."
      echo "<tr class='table-primary'><th scope='row'>$counter</th> <td>$f</td> <td>$new_name</td></tr>" >> $OUTPUT_HTML_FILE ;
    else
      ((counter_valid++))
      echo "    FILE-$counter // File WILL BE renamed." ;
      ## creating the output html file for a review
      echo "<tr class='table-danger'><th scope='row'>$counter</th> <td>$f</td> <td>$new_name</td></tr>" | tee -a  $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE ;

      ## ACTUAL FILE RENAMING
      mv $f $new_name ;
    fi

  done

  echo "<tbody></table>" | tee -a $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE
  ############### END LOOP 2: LOOPING THRU FILES IN EACH DIR THUS FOUND ########

done
############### END LOOP 1: LOOPING THRU DIRECTORIES IN THE MAIN-DIR ###########


################################################################################
################################################################################
echo;
echo "#########################################################################" ;
echo ">> PROGRAM SUMMARY >>"
echo "  TOTAL FILES FOUND = $counter // TOTAL DIRECTORIES FOUND = $counter_directories" ;
echo "  FILES RENAMED = $counter_valid"
echo "  FILES NOT RENAMED = $counter_invalid" ;
echo "#########################################################################" ;


echo "<hr><div style='padding: 10px; color: red; font-size:20px;'>" >> $OUTPUT_HTML_FILE ;
echo "<h2>PROGRAM SUMMARY</h2>" >> $OUTPUT_HTML_FILE ;
echo "TOTAL DIRECTORIES FOUND = $counter_directories"  >> $OUTPUT_HTML_FILE ;
echo "<br>TOTAL FILES FOUND = $counter"  >> $OUTPUT_HTML_FILE ;
echo "<br>FILES RENAMED = $counter_valid"  >> $OUTPUT_HTML_FILE ;
echo "<br>FILES NOT RENAMED = $counter_invalid"  >> $OUTPUT_HTML_FILE ;
echo "</div>"  >> $OUTPUT_HTML_FILE ;

## FINALIZING THE HTML OUTPUT FILES BY APPENDING THE FOOTER REQUIRED FOR BOOTSTRAP4
echo "</div> <!-- END: main containter div -->
    <!-- Optional Bootstrap JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src='https://code.jquery.com/jquery-3.3.1.slim.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'></script>
    <script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'></script>
  </body>
</html>" | tee -a $OUTPUT_HTML_FILE_RENAMED_ONLY $OUTPUT_HTML_FILE

## REVIEW RESULTS (following command only works on MAC OS)
open $OUTPUT_HTML_FILE
open $OUTPUT_HTML_FILE_RENAMED_ONLY
