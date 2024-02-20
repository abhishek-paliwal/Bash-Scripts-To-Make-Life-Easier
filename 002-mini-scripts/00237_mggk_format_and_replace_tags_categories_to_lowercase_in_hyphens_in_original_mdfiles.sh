######################################################################
## THIS PROGRAM REPLACES CATEGORIES AND TAGS TO LOWERCASE WITH HYPHENS, IN ORIGINAL 
## HUGO MDFILES LOCATED IN MGGK REPO
## DATE: 2024-02-07
## BY: PALI
######################################################################

MGGK_DATA_ANALYSIS_CSVFILE="$CSV_MGGK_DATA" ## GET THIS FROM ENV VARIABLE

## FIND EXISTING CATEGORY AND TAGS
echo ">> FIND EXISTING CATEGORY AND TAGS ..." ; 
file_category="$DIR_Y/_tmp00237_mggk-cat.csv" ; 
file_tags="$DIR_Y/_tmp00237_mggk-tag.csv" ; 
##
mlr --csv cut -f categories $MGGK_DATA_ANALYSIS_CSVFILE | sd '"' '' | sd ',' '\n'  | sort -f | uniq > $file_category ;
mlr --csv cut -f tags $MGGK_DATA_ANALYSIS_CSVFILE | sd '"' '' | sd ',' '\n'  | sort -f | uniq > $file_tags ; 

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function FUNC_PROCESS_EACH_MDFILE_FOR_EACH_CATEGORY_OR_TAG () {
    echo ">> RUNNING FUNCTION : $FUNCNAME" ;
    ##
    file2use="$1" ; 
    TOTAL_CATEGORIES_OR_TAGS=$(cat $file2use | wc -l ) ; 
    #IFS="\n" # Set IFS to comma
    COUNT1=0;
    while read myCategoryOrTag
    do
        ((COUNT1++)) ;
        lowercase=$(echo "$myCategoryOrTag" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
        newCategoryOrTag=$(echo "$lowercase" | tr ' ' '-') # Replace spaces with hyphens
        ##
        # Find mdfiles and process each of the found files 
        tmpfile="$DIR_Y/mdfilelist.txt" ; 
        grep -irEl "^.*- $myCategoryOrTag" "$REPO_MGGK/content/allrecipes" > $tmpfile ; 
        TOTAL_FILES_FOUND=$(cat $tmpfile | wc -l ) ; 
        ##
        while IFS="\n" read mdfilepath ; do 
            ## replace the formatted text in original (with various space levels)
            sed -i '' "s/^ - *$myCategoryOrTag *$/ - $newCategoryOrTag/" "$mdfilepath" ;
            sed -i '' "s/^  - *$myCategoryOrTag *$/  - $newCategoryOrTag/" "$mdfilepath" ;
        done < $tmpfile
        ##
        echo ">> CURRENT CATEGORY/TAG = $COUNT1 of $TOTAL_CATEGORIES_OR_TAGS (= $myCategoryOrTag) // TOTAL MDFILES FOUND FOR THIS CATEGORY/TAG = $TOTAL_FILES_FOUND" ; 
    done < "$file2use"
}
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## CALL FUNCTIONS FOR CATEGORY AND TAGS
echo ">> IMPORTANT NOTE: This program takes about 9 minutes to run completely." ; 
##
FUNC_PROCESS_EACH_MDFILE_FOR_EACH_CATEGORY_OR_TAG "$file_category" ; 
FUNC_PROCESS_EACH_MDFILE_FOR_EACH_CATEGORY_OR_TAG "$file_tags" ; 
