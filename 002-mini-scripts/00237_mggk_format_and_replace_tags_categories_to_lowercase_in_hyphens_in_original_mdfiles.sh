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
    #IFS="\n" # Set IFS to comma
    while read myCategoryOrTag
    do
        lowercase=${myCategoryOrTag,,} # Convert to lowercase
        newCategoryOrTag=${lowercase// /-} # Replace spaces with hyphens
        ##
        # Find mdfiles and process each of the found files 
        tmpfile="$DIR_Y/mdfilelist.txt" ; 
        grep -irEl "^.*- $myCategoryOrTag" "$REPO_MGGK/content/allrecipes" > $tmpfile ; 
        while IFS="\n" read mdfilepath ; do 
            ## replace the formatted text in original
            sed -i "s/^  -\s*$myCategoryOrTag\s*$/  - $newCategoryOrTag/" "$mdfilepath" ;
            sed -i "s/^    -\s*$myCategoryOrTag\s*$/    - $newCategoryOrTag/" "$mdfilepath" ;
        done < $tmpfile
    done < "$file2use"
}
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## CALL FUNCTION
FUNC_PROCESS_EACH_MDFILE_FOR_EACH_CATEGORY_OR_TAG "$file_category" ; 
FUNC_PROCESS_EACH_MDFILE_FOR_EACH_CATEGORY_OR_TAG "$file_tags" ; 
