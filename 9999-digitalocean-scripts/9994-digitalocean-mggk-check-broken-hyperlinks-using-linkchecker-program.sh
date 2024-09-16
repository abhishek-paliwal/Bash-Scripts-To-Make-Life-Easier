#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
echo "################################################################################" ;

###############################################################################
## VARIABLES (write full paths, and not the environmental variables)
STARTTIME="$(date)" ; 
DIR_WWW_OUT="/var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs" ; 
WORKDIR="/home/ubuntu/Desktop/Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p "$WORKDIR" ;
echo; echo "Current working directory: $WORKDIR" ; echo;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## RUNS THE ACTUAL COMMAND (r0 = link recursion depth)
## Enter full paths to linkchecker executable
MY_SITE="https://www.mygingergarlickitchen.com" ;
DATEVAR="$(date +%Y%m%d)" ; 
HTML_OUTPUT="$WORKDIR/$DATEVAR-linkchecker-out-mggk.html"
##
/usr/bin/linkchecker --check-extern -F html/$HTML_OUTPUT -o failures "$MY_SITE" ;
## Copying the created HTML output to the www accessible folder, then renaming the original
cp $HTML_OUTPUT $DIR_WWW_OUT/ ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## SEND COMPLETETION EMAIL USING AMAZON SES
ENDTIME="$(date)" ; 
aws ses send-email --from info@mygingergarlickitchen.com --to abhiitbhu@gmail.com --subject "LINKCHECKER RUN COMPLETED" --text "Linkchecker Cronjob Started = $STARTTIME) // Completed = $ENDTIME " ;
