#!/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## IMPORTANT NOTE: comment/uncomment the dry-run, wet-run lines as needed.
##
## THIS PROGRAM MOVES THE MGGK MD FILES TO Y_DIR AND CREATES RANKED FOLDERS
## ACCORDING TO THE MGGK URLS RANKING TEXT FILES. 
###############
## Make sure to replace the urls rankings in these files every 90 days 
## from Google Search Console.
# └── ranked_files
#     ├── ranked-001-100.txt
#     ├── ranked-101-200.txt
#     ├── ranked-201-300.txt
#     ├── ranked-301-400.txt
#     ├── ranked-401-500.txt
#     ├── ranked-501-END.txt
#     └── ranked-top-20.txt
################
## DATE: 2024-01-25
## CODED BY: PALI
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo ">> IMPORTANT NOTE: THIS PROGRAM WILL CURRENTLY RUN IN DRY-RUN. MEANING, IT WILL ONLY COPY FILES, AND NOT MOVE THEM." ;
echo "  >> Uncomment the wet-run line (line 50) if you want to move files instead of copying them. Check MGGK GITHUB REPO for any unintended changes." ; 
echo "      >> YOUR_TASK: After successful wet-run, you will need to move the files from Y DIR to MGGK content folder. Check MGGK GITHUB REPO for any unintended changes." ; 
echo ; 
echo ">> For safety purpose, this program will just exit now. Exiting ..." ; 
exit 1 ; 

## READ ALL RANKED URL FILES ONE BY ONE
for txtfile in ./ranked_files/ranked*.txt ; do 
    echo "=========================== $txtfile" ;  echo ; 
    while IFS=$'\n' read -r line; do
        echo ; 
        #echo "$line" ; 
        # Substring to be replaced
        substring_to_replace="https://www.mygingergarlickitchen.com" ; 
        replacement="" ; 
        # Replace all occurrences of the substring
        base_url="${line//$substring_to_replace/$replacement}" ; 
        space_var=" " ; 
        base_url_new="${base_url//$space_var/}" ; 
        base_url_new_noslash="${base_url//\/}" ; 
        ##
        mdfile_found=$(ack -il "url: ${base_url_new}" "${REPO_MGGK}/content/allrecipes/" | head -1)  ; 
        echo "url: ${base_url_new} || $base_url_new_noslash || $mdfile_found" ;    
        #fd -HItf "$base_url_new_noslash" --search-path="$REPO_MGGK/content/allrecipes/" ; 
        mydir="$DIR_Y/ranked_dirs/dir_$(basename $txtfile)" ;
        mkdir -p "$mydir" ; 
        ##
        ## DRY-RUN
        cp "$mdfile_found"  "$mydir/" ; ## uncomment this line for dry-run
        ## WET-RUN
        #mv "$mdfile_found"  "$mydir/" ; ## uncomment this line for wet-run
    done < "$txtfile"
done 
