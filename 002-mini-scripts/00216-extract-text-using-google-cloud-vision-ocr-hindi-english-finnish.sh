#/bin/bash
################################################################################
## THIS SCRIPT DOES OCR TEXT EXTRACTION FROM INDIVIDUAL JPG IMAGES
## USING GOOGLE CLOUD VISION SERVICES
## NOTE: THE IMAGES NEED TO BE PRESENT IN PRESENT WORKING DIRECTORY.
################################################################################

dirJson="00DIR_json" ;
dirResultsOCR="00DIR_results_ocr_hindi" ; 
dirResultsOCRcombined="00DIR_results_ocr_hindi_combined" ;
## CREATE DIRS
mkdir -p $dirJson $dirResultsOCR $dirResultsOCRcombined ; 

################################################################################
## FUNCTION DEFINITIONS
################################################################################

##############################################
FUNC1_OCR_EXTRACT_TEXT_FROM_JPG_IMAGES () {
for x in *.jpg; do
    ####
    jsonFile="$dirJson/$x.json" ; 
    resultsFile="$dirResultsOCR/OCR-$x.txt" ; 
    ##
    # Extract text using google cloud, save as json 
    # IMPORTANT NOTE: You need to have an active google cloud account and shoud be logged in 
    gcloud ml vision detect-text $x > $jsonFile ; 
    ##
# parse json and save its last text tag replacing literal newline chars to newlines
cat $jsonFile | grep -i '"text":' | tail -1 | sd '"text":' '' | sed 's/\\n/\
/g' > $resultsFile ;
    ##
    # print final summary
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    echo ">> SUMMARY: " ; 
    echo ">>>> CURRENT INPUT JPG = $x" ; 
    echo ">>>> jsonFile = $jsonFile"; 
    echo ">>>> resultsFile = $resultsFile"; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    ####
done 
}
##############################################
FUNC2_CONCATENATE_ALL_EXTRACTED_TEXT_FILES_INTO_ONE () {
    for x in $(ls "$dirResultsOCR/*.txt" | sort -V) ; do echo; echo; echo ">>>>>>>>>> $x" ; echo; cat $x ; done >> "$dirResultsOCRcombined/101.txt" ; 
    echo ">> SUMMARY: Combined file saved => $dirResultsOCRcombined/101.txt " ; 
}
################################################################################
################################################################################

## CALLING FUNCTIONS IN RIGHT ORDER
#FUNC1_OCR_EXTRACT_TEXT_FROM_JPG_IMAGES ; 
FUNC2_CONCATENATE_ALL_EXTRACTED_TEXT_FILES_INTO_ONE ; 

