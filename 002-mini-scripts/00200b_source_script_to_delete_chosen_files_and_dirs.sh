#/bin/bash
################################################################################
# This script will delete all files in a directory and move them to a trash directory
################################################################################
# Author: Pali
# Date: 2023-03-25 
# Usage: source demo.sh, then run commands from cli or in another script
##        palitrash-put temptemp ## delete directory    
##        palitrash-put 1.txt ## delete file
##        palitrash-put * ## delete multiple files and directories
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_vars () {
    dateNow=$(date +%Y%m%d) ; 
    TRASH_DIR="$DIR_X/_trashed_${dateNow}" ;
    mkdir -p "$TRASH_DIR" ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function palitrash-put () {
    set_vars ;
    echo "###########################################" ;
    for file in "$@" ; do
    dateTimeNow=$(date +%Y-%m-%dT%H:%M:%S) ;
    presentDir=$(pwd) ;
    ##
    echo "[Trash Info]
    DeletedFrom=$presentDir
    DeletionDate=$dateTimeNow" > "$TRASH_DIR/$(basename $file).trashinfo" ;
    ##
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
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#function which reads the contents of a directory and lists them numerically
function palitrash-list () {
    set_vars ;
    echo "###########################################" ;
    echo ">> Listing contents of $TRASH_DIR" ;
    fd -HI --search-path="$TRASH_DIR" | grep -iv 'trashinfo' | nl  ;
    echo "############################################" ;
} 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#function which reads the contents of a directory and lists them numerically
function palitrash-empty () {
    set_vars ;
    echo "###########################################" ;
    # confirm if user wants to delete all files in trashdir
    echo ">> Are you sure you want to delete all files in $TRASH_DIR? (y/n): " ;
    read myanswer ;
    if [[ "$myanswer" == "y" ]] ; then
        echo ">> Deleting all files in $TRASH_DIR" ;
        fd -HI --search-path="$TRASH_DIR" | xargs rm -rf  ;
    else
        echo ">> Exiting without deleting any files in $TRASH_DIR" ;
    fi 
    echo "############################################" ;
} 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




