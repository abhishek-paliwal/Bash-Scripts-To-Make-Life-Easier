#!/bin/bash
THIS_SCRIPT_NAME="1002-leelasrecipes-MOVE-ALL-PWD-IMAGES-TO-PROPER-WEBSITE-FOLDER.sh"

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS SCRIPT MOVES ALL JPGs or PNGs found in the present working directory and
  ## MOVES THEM TO THE IMAGES FOLDER LOCATED IN THE LEELASRECIPES WEBSITE DIRECTORY.
  ## USAGE:
  #### bash $THIS_SCRIPT_NAME
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## VARIABLE SETTING = Image directory to move files to
IMGDIR="$DIR_GITHUB/2020-LEELA-RECIPES/static/images/masonary-post/2021/" ; 
echo; echo ">>>> IMPORTANT NOTE: All images will be moved from $(pwd) => $IMGDIR" ;

echo; echo ">> BEFORE MOVING- Current images found in => $IMGDIR"; echo;
ls $IMGDIR | nl ; 

echo; echo ">> BEFORE MOVING - Current images found in => $(pwd)"; echo;
fd -e jpg -e png -d1 --search-path="$(pwd)" | nl;

echo; echo; echo ">>>> WARNING >>>> This command will move all above jpg + png images to this directory => $IMGDIR" ; 

################
## GETTING USER CONFIRMATION TO MOVE ALL FILES. THE USER HAS TO PRESS y KEY.
echo "Enter Y/y key to continue" ;
read myNumber ; 
if [[ "$myNumber" =~ ^[Yy]$ ]] ; then 
  fd -e jpg -e png -d1 --search-path="$(pwd)" -x mv {} $IMGDIR/ ;
  echo ">> All lowercase jpg + png images moved." ;
  ####
  echo ;  echo ">>>> AFTER MOVING - CURRENT FILES in $IMGDIR =>" ; echo ; 
  ls $IMGDIR | nl ;
  echo ;  echo ">>>> AFTER MOVING - CURRENT FILES in $(pwd) =>" ; echo ; 
  ls -l $(pwd) | nl ;
  ####
else 
  echo ">>>> ERROR: No files were moved because Y/y key was not pressed. OR some other key was pressed. <<<< " ; 
fi ; 
################
