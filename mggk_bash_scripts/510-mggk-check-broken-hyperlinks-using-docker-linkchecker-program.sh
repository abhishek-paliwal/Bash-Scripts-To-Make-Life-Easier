#!/bin/bash
###############################################################################
cat <<EOF
  ###############################################################################
  ## THIS SCRIPT CHECKS BROKEN HYPERLINKS IN ANY GIVEN SITE.
  ## THIS SCRIPT USES DOCKER. SO, RUN DOCKER BEFORE RUNNING IT.
  ## GET HELP: https://github.com/linkchecker/linkchecker
  ###############################################################################
  ## USAGE:
  ## > docker run --rm -it -u \$(id -u):\$(id -g) -v "\$PWD":/mnt linkchecker/linkchecker --verbose www.mygingergarlickitchen.com
  ###############################################################################
  ## CODED ON: Wednesday April 24, 2019
  ## BY: PALI
  ###############################################################################
  ## FOR HELP WITH LINKCHECKER PROGRAM: RUN THE FOLLOWING COMMAND:
  ## >>>>>>>>> PRINTS HELP MESSAGE ABOUT HOW TO RUN THIS IMAGE <<<<<<<<<<<
  ## docker run --rm -it -u \$(id -u):\$(id -g) -v "\$PWD":/mnt linkchecker/linkchecker --help
  ###############################################################################
EOF
###############################################################################

## VARIABLES
MY_SITE="https://www.mygingergarlickitchen.com" ;
HTML_OUTPUT_FILE="_tmp_linkchecker_output_file.html" ;

PWD=$(pwd) ;
echo; echo "Current working directory: $PWD" ; echo;

###############################################################################
## USER CONFIRMATION
echo "You are about to run the following command, are you sure????" ;

echo ">>>>> COMMAND >>>>> docker run --rm -it -u \$(id -u):\$(id -g) -v '\$PWD\':/mnt linkchecker/linkchecker --verbose -o html r0 $MY_SITE > $HTML_OUTPUT_FILE"

read -p ">>>>>> If your sure sure, press ENTER key ..." ;
echo; 
###############################################################################

## RUNS THE ACTUAL COMMAND FOR $MY_SITE
## docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --verbose www.mygingergarlickitchen.com
docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --verbose -o html r0 $MY_SITE > $HTML_OUTPUT_FILE
