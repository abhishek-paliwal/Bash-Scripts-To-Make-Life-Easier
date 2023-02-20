#/bin/bash

## SOURCING PROJECT CONFIGURATION TO BE USED AS VARIABLES
source $REPO_SCRIPTS/1003-gayatri-parivar-book-making-programs/1003_configuration_parameters_for_project.config ; 


## GET CONFIG VARIABLES FROM CONFIGURATION FILE
DIR_PROJECT="$DIR_PROJECT" ;
BOOKNAME="$BOOKNAME" ; 
BOOK_URL_PREFIX_WITH_DOT_IN_END="$BOOK_URL_PREFIX_WITH_DOT_IN_END" ; 
NUMPAGES_TO_EXTRACT=$NUMPAGES_TO_EXTRACT ; 
DIR_OUTPUT="$DIR_OUTPUT" ; 


## 
WORKDIR="$DIR_OUTPUT" ; 
mkdir -p $WORKDIR ; 
##
cd $WORKDIR ; 
##

## download all pages one by one
for x in $(seq 1 1 $NUMPAGES_TO_EXTRACT) ; do wget "$BOOK_URL_PREFIX_WITH_DOT_IN_END"$x ; done

## add html file extension
for x in * ; do mv $x $x.html ; done

####
## run the python bsoup program to extract the desired data from locally present html files
python_program_path="$DIR_PROJECT/1003-gayatri-parivar-parse-local-html-book-data-using-beautiful-soup.py" ;
## Check output
python3 $python_program_path "$BOOKNAME" $NUMPAGES_TO_EXTRACT "$BOOK_URL_PREFIX_WITH_DOT_IN_END"
## Then run again to save output to html
#python3 $python_program_path > $WORKDIR/_FINAL_RESULT.html ## save to html
