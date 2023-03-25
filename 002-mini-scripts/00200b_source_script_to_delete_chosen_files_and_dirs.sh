#/bin/bash
################################################################################
# This script will delete all files in a directory and move them to a trash directory
################################################################################
# Author: Pali
# Date: 2023-03-25 
# Usage: source demo.sh, then run commands from cli or in another script
##        palidelete temptemp ## delete directory    
##        palidelete 1.txt ## delete file
##        palidelete * ## delete multiple files and directories
################################################################################

dateNow=$(date +%Y-%m-%d)
TRASH_DIR="$DIR_X/_trashed_${dateNow}"
mkdir -p "$TRASH_DIR" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function palidelete () {
    echo "###########################################" ;
    for file in "$@" ; do
    echo ">> Current => $file" ; 
        if [ -d "$file" ]; then
            echo ">> Trashing this directory => $file" ;  
            mv "$file" "$TRASH_DIR/" ;
        else
            if [ -f "$file" ]; then
                echo ">> Trashing this file => $file" ;  
                mv "$file" "$TRASH_DIR/" ;
            fi
        fi
    done
    echo "############################################" ;
}
