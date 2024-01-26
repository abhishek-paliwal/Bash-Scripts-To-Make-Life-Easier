#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

## SETTING VARIABLES
ROOTDIR="$REPO_MGGK/content/allrecipes/top-20" ;  # use this dir for reading files with frontmatter
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
DIR_OUTPUT_MDFILES_PARA_SHORTENED="$WORKDIR/_OUTPUT_MDFILES_PARAGRAPH_SHORTENED"
##
mkdir -p "$WORKDIR" ; ## create dirs if not present
mkdir -p "$DIR_OUTPUT_MDFILES_PARA_SHORTENED" ; 
## 
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_PROCESS_AND_SHORTEN_EACH_LINE_IN_THIS_MDFILE () {
    # Specify the path to your text file
    file_path="$1" ; 

    # Set the maximum line length as characters
    max_line_length=300 ; 

    # Set the regular expression to match URLs
    url_regex='(https?://[^\s]+)' ; 

    # Read all lines from the file into an array named 'lines'
    IFS=$'\n' read -d '' -r -a lines < "$file_path"

    # Iterate over the lines
    for ((i=0; i<${#lines[@]}; i++)); do
    ############
        currentLine="${lines[i]}"
        #echo "Line $((i+1)): $currentLine"
        # Break the line at the first full stop if it exceeds the maximum line length
        #echo "${#currentLine} : ${currentLine}"
        if [[ ${#currentLine} -ge ${max_line_length} ]]; then
            #####
            # Check if the line does not contain a URL and does not contain a hashtag sign (bcoz some lines end with hashtags)
            if [[ ! $currentLine =~ $url_regex && "$currentLine" != *#* ]] ; then
                currentLine_part1=$(echo $currentLine | cut -d '.' -f1-3  | sd '^ ' '') ;  ## field 1-3
                currentLine_part2=$(echo $currentLine | cut -d '.' -f4-6  | sd '^ ' '') ;  ## field 4-6
                currentLine_part3=$(echo $currentLine | cut -d '.' -f7-9  | sd '^ ' '' ) ;  ## field 7-9
                currentLine_partRemaining=$(echo $currentLine | cut -d '.' -f9-  | sd '^ ' '' ) ;  ## field 9 onewards
                ##
                tmpfile01="$WORKDIR/_tmpfile01.txt" ; 
                tmpfile02="$WORKDIR/_tmpfile02.txt" ; 
                echo > "$tmpfile01" ; 
                echo > "$tmpfile02" ;
                ## append
                echo "${currentLine_part1}." >> "$tmpfile01" ; 
                echo >> "$tmpfile01" ;
                echo "${currentLine_part2}." >> "$tmpfile01" ; 
                echo >> "$tmpfile01" ;
                echo "${currentLine_part3}." >> "$tmpfile01" ; 
                echo >> "$tmpfile01" ;
                echo "${currentLine_partRemaining}" >> "$tmpfile01" ; 
                ##
                ## remove consecutive empty lines and concatenate to a file
                cat "$tmpfile01" | sd '\.\.' '.' | sd '^\.$' '' | sd '\?\.' '?' | sd '!\.' '!' > "$tmpfile02" ; 
                cat -s "$tmpfile02"  ; 
            else
                echo ; echo "$currentLine" ;
            fi 
            ######
        else 
            #echo "OLD: ${#currentLine} : $currentLine" ; 
            echo ; echo "$currentLine" ; 
        fi
    ############
    done
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##------------------------------------------------------------------------------

function FUNC_STEP1 () {
    ## STEP1 = RUN EXTERNAL PROGRAM TO SEPARATE FRONTMATTER AND CONTENT FROM ALL MDFILES
    echo "Running STEP1 = RUN EXTERNAL PROGRAM TO SEPARATE FRONTMATTER AND CONTENT FROM ALL MDFILES ..." ; 
    bash "$REPO_SCRIPTS_MINI/00234_mggk_extract_and_save_frontmatter_and_content_as_txtfiles_from_mggk_hugo_markdown_files.sh" | pv -pt > /dev/null ; 
}

function FUNC_STEP2 () {
    ## STEP2 = CALL FUNCTION FOR EACH MDFILE AND PROCESS IT
    echo "Running STEP2 = CALL FUNCTION FOR EACH MDFILE AND PROCESS IT ..." ; 
    ##
    STEP1_OUTDIR="$DIR_Y/_OUTPUT_00234_mggk_extract_and_save_frontmatter_and_content_as_txtfiles_from_mggk_hugo_markdown_files" ; 
    DIR_FILES_FRONTMATTER="$STEP1_OUTDIR/_TMP_FRONTMATTER/" ; 
    DIR_FILES_CONTENT="$STEP1_OUTDIR/_TMP_CONTENT/" ;
    ##
    for mdfile in $(fd -HItf -e md --search-path="$ROOTDIR" | sort -r | grep -iv '_index' | head -3) ; do
        BASE_MDFILE=$(basename "$mdfile") ; 
        FRONTMATTER_FILE=$(fd -HItf $BASE_MDFILE --search-path="$DIR_FILES_FRONTMATTER") ; 
        CONTENT_FILE=$(fd -HItf $BASE_MDFILE --search-path="$DIR_FILES_CONTENT") ; 
        ##
        TMPFILE_CONTENT_NEW="$WORKDIR/_tmpfile_content.txt" ; 
        TMPFILE_FINAL0="$WORKDIR/_tmpfile_final0.txt" ; 
        TMPFILE_FINAL1="$WORKDIR/_tmpfile_final1.txt" ; 
        ##
        FUNC_PROCESS_AND_SHORTEN_EACH_LINE_IN_THIS_MDFILE "$CONTENT_FILE" > "$TMPFILE_CONTENT_NEW" ;
        ## concatenate old frontmatter with new content
        cat "$FRONTMATTER_FILE" "$TMPFILE_CONTENT_NEW" > "$TMPFILE_FINAL0" ; 
        echo >> "$TMPFILE_FINAL0" ;  
        cat "$TMPFILE_FINAL0" > "$TMPFILE_FINAL1" ; ## clean output by deleting repeated empty lines
        icdiff "$mdfile" "$TMPFILE_FINAL1" ; 
        ##
        ## Finally copy the output file to proper directory, and rename according to original mdfile.
        cp "$TMPFILE_FINAL1" "$DIR_OUTPUT_MDFILES_PARA_SHORTENED/$BASE_MDFILE" ;
    done
}
##------------------------------------------------------------------------------

FUNC_STEP1
FUNC_STEP2