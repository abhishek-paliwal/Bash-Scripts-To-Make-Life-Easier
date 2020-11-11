#!/bin/bash

REQUIREMENTS_FILE="$REPO_SCRIPTS_MGGK/_REQUIREMENT_FILES_MGGK/0000-bash-script-creation-template.txt" ;

SCRIPTNAME="script_from_template_$(date +%Y%m%d-%H%M%S).sh" ;

cat $REQUIREMENTS_FILE > $SCRIPTNAME

echo "Enter Script Description: " ; read $SCRIPT_DESC ; echo $SCRIPT_DESC | fold -sw 75 | sed 's/^/    ## /g' >> $SCRIPTNAME
