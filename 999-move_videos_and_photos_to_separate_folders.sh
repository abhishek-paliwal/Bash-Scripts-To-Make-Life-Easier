#!/bin/bash
########################################################
## THIS PROGRAM SEPARATES PHOTOS AND VIDOES INTO TWO SEPARATE FOLDERS.
## IT DOES IT BY CREATING TWO NEW FOLDERS BASED UPON THE BASEDIRECTORY NAME, AND THEN
## MOVES ALL LOWERCASE PHOTO FILES (jpg, png) INTO PHOTOS FOLDER, AND ALL LOWERCASE VIDEO
## FILES (mp4, mov, m4v, 3gp) INTO VIDEOS FOLDER.
## CREATED ON: 05-02-2020 16:38
## CREATED BY: PALI
#########################################################

CWD=$(pwd); 

## PRINTING THE DIRECTORIES WHICH WILL BE CONSIDERED.
echo "DIRECTORIES TO PARSE (check for any errors):" ; 
find $CWD -maxdepth 1 -type d ; echo; 

for DIRNAME in $(find $CWD -maxdepth 1 -type d) ; do 

    cd $DIRNAME ; 
    MYDIR=$(basename $DIRNAME); 
    echo "Moving PNG/png, JPG/jpg, MP4/mp4, MOV/mov to separate folders..."; 

    ## CREATING THE TWO DIRECTORIES
    mkdir -p $MYDIR-photos $MYDIR-videos ; 

    ## MOVING IMAGES
    mv $DIRNAME/*.{jpg,png} $MYDIR-photos/ ; 
    ## MOVING VIDEOS
    mv $DIRNAME/*.{mp4,mov,m4v,3gp} $MYDIR-videos/ ; 

    echo "All files moved." ; 

    ## PRINTING NEW DIRECTORY TREE FOR CHECKING
    tree  ; 

    ## FINALLY MOVING BOTH THE NEWLY CREATED DIRECTORIES TO BASE-DIRECTORY
    mv $MYDIR-photos $CWD/ ; 
    mv $MYDIR-videos $CWD/ ; 
    cd $CWD ; 

done
