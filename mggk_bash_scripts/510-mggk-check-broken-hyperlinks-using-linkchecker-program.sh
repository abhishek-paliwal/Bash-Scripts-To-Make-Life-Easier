#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS SCRIPT CHECKS BROKEN HYPERLINKS IN ANY GIVEN SITE.
  ## THIS SCRIPT USES DOCKER. SO, RUN DOCKER BEFORE RUNNING IT.
  ## GET HELP: https://linkchecker.github.io/linkchecker/install.html
  ## Local Help > linkchecker --help
  ###############################################################################
  ## USAGE (if run from command line interactive terminal):
  ## > linkchecker --verbose --check-extern www.mygingergarlickitchen.com
  ###############################################################################
  ## UPDATED ON: 2021-08-07
  ## BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


###############################################################################
## VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p "$WORKDIR" ;
echo; echo "Current working directory: $WORKDIR" ; echo;

## RUNS THE ACTUAL COMMAND (r0 = link recursion depth)
echo "################################################################################" ;
MY_SITE="https://www.mygingergarlickitchen.com" ;
HTML_OUTPUT="$WORKDIR/linkchecker-out-mggk.html"

##------------------------------------------------------------------------------
function FUNC_RUN_LINKCHECKER () {
      linkchecker --check-extern -F html/$HTML_OUTPUT "$MY_SITE" ;
      ## Copying the created HTML output to the www accessible folder, then renaming the original
      cp $HTML_OUTPUT /var/www/vps.abhishekpaliwal.com/html/scripts-html-outputs/
      ## FINALLY SEND FINAL EMAIL USING AMAZON SES
      aws ses send-email --from info@mygingergarlickitchen.com --to abhiitbhu@gmail.com --subject "LINKCHECKER RUN COMPLETED // DOCKER LINKCHECKER" --text "Cronjob completed at $(date)" ;

}

function FUNC_ONLY_RUN_FOR_THIS_USER () {
    ## ## Only run this program for this user
    echo "IMPORTANT NOTE: This script only runs on MAC OS." ; 
    if [ "$USER" == "ubuntu" ] ; then
      echo "This is not MAC OS. So, script will continue ... " ;
      FUNC_RUN_LINKCHECKER ;
    else
    echo "This is MAC OS. So, script will stop and exit now." ;
    exit 1 ;
    fi
}
FUNC_ONLY_RUN_FOR_THIS_USER
##------------------------------------------------------------------------------


