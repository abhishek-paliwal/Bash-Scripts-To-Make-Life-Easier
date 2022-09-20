#/bin/bash

WORKDIR="$DIR_Y/_TMPDIR" ; 
mkdir -p $WORKDIR ; 
##
cd $WORKDIR ; 
##

## CHANGE THE FOLLOWING VARIABLES FOR EACH BOOK YOU WISH TO DOWNLOAD
bookname="sharir_ki_adbhut_kshmtaye_aur_vilakshantaye" ; 
total_pages_to_download=17;

## download all pages one by one
for x in $(seq 1 1 $total_pages_to_download) ; do wget http://literature.awgp.org/book/$bookname/v1.$x ; done

## add html file extension
for x in * ; do mv $x $x.html ; done

####
## run the python bsoup program to extract the desired data from locally present html files
python_program_path="$REPO_SCRIPTS/1003-gayatri-parivar-book-making-programs/1003-gayatri-parivar-parse-local-html-book-data-using-beautiful-soup.py" ;
## Check output
python3 $python_program_path
## Then run again to save output to html
python3 $python_program_path > $WORKDIR/$bookname.html ## save to html
