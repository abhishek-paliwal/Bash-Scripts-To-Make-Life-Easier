#!/bin/bash
##################################################################################
## Renaming all files to lowercase and copying them on Windows WSL
##################################################################################

# Get the list of files in the working directory
files=$(ls)

newdir="_tmp_renamed_lowercase" ;
mkdir -p "$newdir" ;  

# Iterate through each file
for file in $files; do
    # Get the original filename
    name_original=$file

    # Convert the filename to lowercase
    name_lower=${name_original,,}

    # Copy the file to dir01 and rename it to lowercase
    cp "$name_original" "$newdir/$name_lower" ;
    echo "... file copied => $newdir/$name_lower" ; 
done