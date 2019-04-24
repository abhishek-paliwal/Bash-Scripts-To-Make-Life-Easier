#!/bin/bash
###############################################################################
cat <<EOF
  ###############################################################################
  ## This script checks broken hyperlinks in any given site
  ## THIS SCRIPT USES DOCKER
  ## GET HELP: https://github.com/linkchecker/linkchecker
  ###############################################################################
EOF
###############################################################################

## VARIABLES
MY_SITE="https://www.mygingergarlickitchen.com" ;
HTML_OUTPUT_FILE="_tmp_linkchecker_output_file.html" ;

## PRINTS HELP MESSAGE ABOUT HOW TO RUN THIS IMAGE
docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --help

## RUNS THE ACTUAL COMMAND FOR $MY_SITE
docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --verbose -o html r0 $MY_SITE > $HTML_OUTPUT_FILE
