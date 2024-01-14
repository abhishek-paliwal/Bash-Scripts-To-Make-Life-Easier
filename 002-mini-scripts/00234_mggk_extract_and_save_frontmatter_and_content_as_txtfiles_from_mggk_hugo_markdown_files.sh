#!/bin/bash
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## THIS PROGRAM READS MGGK HUGO DIR AND PROCESSES EACH MDFILE TO SEPARATE
## FRONTMATTER AND CONTENT, AND SAVES THEM AS TXTFILES BASED UPON MDFILE NAME.
## DATE: 2024-01-14
## CODED BY: PALI 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

## SETTING VARIABLES
ROOTDIR="$REPO_MGGK/content" ;  # use this dir for reading files with frontmatter
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
DIR_FRONTMATTER="$WORKDIR/_TMP_FRONTMATTER" ; 
DIR_CONTENT="$WORKDIR/_TMP_CONTENT" ; 
##
mkdir -p "$WORKDIR" "$DIR_CONTENT" "$DIR_FRONTMATTER" ; ## create dirs if not present
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_PROCESS_EACH_MD_FILE () {
    for mdfile in $(fd -e md --search-path="$ROOTDIR") ; do 
        file_path="$mdfile" ; 
        #file_path="$REPO_MGGK/content/popular-posts/2023-11-13-T184127-dal-baati-churma.md"
        ####    
        if [ -f "$file_path" ]; then
            # Extract YAML frontmatter and content
            file_content=$(<"$file_path")

            # Use awk to find the line numbers of the first and last '---'
            start_line=$(awk '/^---/{print NR; exit}' <<< "$file_content") ; 
            end_line=$(awk '/^---/{print NR}' <<< "$file_content" | sed -n '2p') ; 

            # Extract frontmatter and content
            frontmatter=$(awk "NR>=$start_line && NR<=$end_line" <<< "$file_content")
            content=$(awk "NR>$end_line" <<< "$file_content")

            # Print or process the extracted frontmatter and content
            echo "Frontmatter:" ; 
            echo "$frontmatter" ; 

            echo -e "\nContent:" ; 
            echo "$content" ; 
            ####
            base_x=$(basename "$file_path") ; 
            echo "$frontmatter" > "$DIR_FRONTMATTER/${base_x}-FRONTMATTER.txt" ; 
            echo "$content" > "$DIR_CONTENT/${base_x}-CONTENT.txt" ; 
        else
            echo "File not found: $file_path" ;
        fi
        ####
    done    
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## CALL FUNCTION
FUNC_PROCESS_EACH_MD_FILE ;
