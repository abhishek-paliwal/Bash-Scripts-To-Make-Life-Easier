#!/bin/bash
## CREATE HTML LISTING OF MP3 FILES WITH THEIR DURATION IN HOURS MINUTES SECONDS
##############################################################################
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNC_SOURCE_SCRIPTS () {
    ####
    source "$REPO_SCRIPTS_MINI/00200a_source_script_to_print_fancy_divider.sh" ;
    echo ">> This enables => 'palidivider' command, which prints a fancy divider on cli." ; 
    ####
    source "$REPO_SCRIPTS_MINI/00200b_source_script_to_delete_chosen_files_and_dirs.sh" ; 
    echo ">> This enables => 'palidelete, palitrash-put, palitrash-empty, palitrash-list' commands, which move files into a _trashed_directory instead of deleting completely." ; 
    ####
    ####################### ADDING COLOR TO OUTPUT ON CLI ##########################
    echo "Currently sourcing the bash color script, which outputs chosen texts in various colors ..." ;
    source $REPO_SCRIPTS/2000_vendor_programs/color-logger.sh
    info "This enables use of keywords for coloring, such as: debug, info, error, success, warn, highlight." ;
    debug "Read it's help by running: >> bash $DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/color-logger.sh -h"
    ##############################################################################
}
FUNC_SOURCE_SCRIPTS ; 
palidivider "Currently running: $THIS_SCRIPT_NAME" ; 
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##############################################################################
## SETTING VARIABLES
WORKDIR="$DIR_Y/_OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION" ;
mkdir -p $WORKDIR ; ## create dir if not exists
echo "##########################################" ; 
echo "## PRESENT WORKING DIRECTORY = $WORKDIR" ;
echo "##########################################" ; 

time_taken="$WORKDIR/tmp-time-taken-$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
echo "$(date) = START-TIME" > $time_taken

##############################################################################
## Confirmation to proceed
read -p "Press Enter key if OKAY ..." ; 
##############################################################################
OUTPUT_HTML="$WORKDIR/OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION.html" ;
OUTPUT_TXT="$WORKDIR/OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION.txt" ;
OUTPUT_CSV="$WORKDIR/OUTPUT_$THIS_SCRIPT_NAME_SANS_EXTENSION.csv" ;
##
TMPFILE_CSV="$WORKDIR/_tmp_csv.csv" ; 
TMPFILE_HTML="$WORKDIR/_tmp_html.html" ; 
echo > $TMPFILE_CSV ## initializing file
echo > $TMPFILE_HTML ## initializing file
echo ;
##############################################################################

##############################################################################
HTML_BOOTSTRAP_HEADER="<!doctype html>
<html lang='en'>
<head>
    <!-- Required meta tags -->
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <!-- Bootstrap CSS -->
    <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' rel='stylesheet'
        integrity='sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC' crossorigin='anonymous'>

    <!-- DATATABLE BLOCK -->
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
    <link rel='stylesheet' type='text/css' href='https://cdn.datatables.net/1.13.3/css/dataTables.bootstrap5.min.css' />
    <script type='text/javascript' src='https://cdn.datatables.net/1.13.3/js/jquery.dataTables.min.js'></script>
    <script type='text/javascript' src='https://cdn.datatables.net/1.13.3/js/dataTables.bootstrap5.min.js'></script>
    <script>
        \$(document).ready(function () {
            \$('#mytable').DataTable(
                {
                    'scrollY': '700px',
                    'paging': false,
                    'autoWidth': true
                }
            );
        });
    </script>
    <!-- DATATABLE BLOCK -->

    <title>OUTPUT - AWGP MP3 FILES LISTING WITH DURATION</title>
</head>
<body>
<div class='container'>" ;

HTML_BOOTSTRAP_FOOTER="</div><!-- Option 1: Bootstrap Bundle with Popper -->
<script src='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js'
  integrity='sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM' crossorigin='anonymous'></script>
</body></html>" ;

DATATABLE_HEADER="<table class='table table-striped' id='mytable' class='display' style='width:100%'>
    <thead>
        <tr>
            <th>FILE_DURATION</th>
            <th>AUDIO_NAME</th>
            <th>AUDIO_NAME_FROMFILE</th>
            <th>AUDIO_STREAM</th>
            <th>MP3_FILE_BASENAME</th>
        </tr>
    </thead>
    <tbody>"

DATATABLE_CONTENT_ROWS="<tr>
            <td>1</td>
            <td>Demo recipe title 1 </td>
            <td>demo recipe url link 1</td>
        </tr>
        <tr>
            <td>2</td>
            <td>Demo recipe title 2</td>
            <td>demo recipe url link 2</td>
        </tr>"

DATATABLE_FOOTER="</tbody></table>"

##################################################################################
##################################################################################
## CREATING HTML OUTPUT
##################################################################################
echo "$HTML_BOOTSTRAP_HEADER" > $OUTPUT_HTML ; ## Initializing HTML output
echo "<h1>HTML OUTPUT - AWGP MP3 FILES LISTING WITH DURATION</h1>" >> $OUTPUT_HTML ;
echo "<p>Page last updated: $(date)" >> $OUTPUT_HTML ;
echo "<br>Page updated by script: ${THIS_SCRIPT_NAME//\_/ }</p><hr>" >> $OUTPUT_HTML ;
##
NUMFILES_FOUND="$(fd -e mp3 -e MP3 --search-path="$(pwd)" | sort -V | wc -l)" ;
echo "<h2>$NUMFILES_FOUND = Number of MP3 files found</h2>" >> $OUTPUT_HTML ;
##
echo "<hr>" >> $OUTPUT_HTML ;
##
echo "$DATATABLE_HEADER"  >> $OUTPUT_HTML ;
#echo "$DATATABLE_CONTENT_ROWS"  >> $OUTPUT_HTML ;

##################
## CREATING CSV
##################
echo "$CSV_HEADER"  > $OUTPUT_CSV ; ## Initializing CSV output

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
count=0 ;
for x in $(fd -e mp3 -e MP3 --search-path="$(pwd)" | sort -V) ; do  
    ((count++)) ; 
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    MP3_FILE_BASENAME="$(basename $x)" ; 
    MP3_FILE_BASENAME_SANS_EXTENSION="$(basename -s .mp3 $x)" ;
    path_to_replace="$(pwd)/awgp" ; 
    MP3_FILE_RELATIVE_PATH="${x/$path_to_replace/.}";
    ##
    get_serial_number_of_book=$(echo "$MP3_FILE_BASENAME" | awk -F '_XX_' '{print $1}' | sd ' ' '') ;
    ## Use CSV_AWGP environment variable
    get_bookname=$(grep -i "${get_serial_number_of_book};" $CSV_AWGP | awk -F ';' '{print $3}' | head -1)  ; 
    get_bookname_txtmd=$( fd -e txt -e md "$MP3_FILE_BASENAME_SANS_EXTENSION" -x head -1 {} )  ; 
    ##
    TMPFILE="$WORKDIR/_tmp011.txt" ; 
    ffprobe -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$x" 2>/dev/null > "$TMPFILE" ;
    duration_in_secs="$(cat $TMPFILE | cut -d . -f1)" ;
    echo ">> DURATION IN SECONDS = $duration_in_secs"    ;
    song_duration=$(gdate -d@${duration_in_secs} -u +%Hh-%Mm-%Ss) ;
    warn ">> Current file => $count of $NUMFILES_FOUND ..." ; 
    info ">> ORIGINAL FILE => $x" ; 
    info ">> MP3_FILE_RELATIVE_PATH => $MP3_FILE_RELATIVE_PATH" ; 
    success ">> ORIGINAL FILE BASENAME => $(basename $x)" ; 
    success ">> MP3 song duration in hours mins seconds => $song_duration" ;
    echo "$get_bookname // $get_serial_number_of_book"
    ##
    audio_stream_text="<audio controls='controls' preload='none' src='$MP3_FILE_RELATIVE_PATH'><a href='$MP3_FILE_RELATIVE_PATH'>Download audio</a></audio>" ; 
    echo "<tr> <td>$song_duration</td> <td>$get_bookname</td> <td>$get_bookname_txtmd</td> <td>$audio_stream_text</td> <td>$MP3_FILE_BASENAME</td> </tr>"  >>  "$TMPFILE_HTML" ; 
    ##
    echo "$song_duration;$get_bookname;$get_bookname_txtmd;$audio_stream_text;$MP3_FILE_BASENAME"  >>  "$TMPFILE_CSV" ; 
done
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##
sort "$TMPFILE_HTML" >> $OUTPUT_HTML ;  ## sort by first column ( = mp3 duration)
echo "$DATATABLE_FOOTER"  >> $OUTPUT_HTML ;
echo "$HTML_BOOTSTRAP_FOOTER" >> $OUTPUT_HTML ;

##################
## CREATING CSV
##################
CSV_HEADER="FILE_DURATION;AUDIO_NAME;AUDIO_NAME_FROMFILE;AUDIO_STREAM;MP3_FILE_BASENAME" ;   
echo "$CSV_HEADER" | grep -iv '^$' > $OUTPUT_CSV ; ## Initializing CSV output
sort "$TMPFILE_CSV" | grep -iv '^$' >> $OUTPUT_CSV ; ## sort by first column ( = mp3 duration)
##################################################################################
##################################################################################

##################################################################################
## CREATING TXT OUTPUT
##################################################################################
echo "HTML OUTPUT - $THIS_SCRIPT_NAME_SANS_EXTENSION" >> $OUTPUT_TXT ;
echo "Page last updated: $(date)" >> $OUTPUT_TXT ;
echo "Page updated by script: $THIS_SCRIPT_NAME" >> $OUTPUT_TXT ;
echo "##---------------------------------------------------------" >> $OUTPUT_TXT ;
##################################################################################


################################ FINAL SUMMARY ####################################
echo "## SUMMARY PRINTING #########################################################" ;
echo "##---------------------------------------------------------------------------"
success ">>>> SUCCESS // SUMMARY: OUTPUT HTML FILE CREATED AT => $OUTPUT_HTML" ;
success ">>>> SUCCESS // SUMMARY: OUTPUT TXT FILE CREATED AT => $OUTPUT_TXT" ;
echo "################################################################################" ;

##------------------------------------------------------------------------------
## FINALLY COPY THE OUTPUT HTML + CSV FILE TO THE DESIRED LOCATION
palidivider "Copying output HTML + CSV file to Dropbox folder" ;
##########
function FUNC_COPY_FILES_TO_DROPBOX_DIR () {
    inFile="$1" ; 
    DROPBOX_FILEPATH="$DIR_DROPBOX_SCRIPTS_OUTPUT/_AWGP_gayatri_pariwar_outputs/$(basename $inFile)" ;
    cp "$inFile" "$DROPBOX_FILEPATH" ;
    warn ">>>> MESSAGE // OUTPUT FILE COPIED TO => $DROPBOX_FILEPATH" ;
    ## ADDITIONALLY COPY IT TO awgp directory (DIR_Y/awgp/)
    fileExtension=${inFile##*.}
    EXTRA_COPYPATH="$DIR_Y/awgp/index_books.$fileExtension" ; 
    cp "$inFile" "$EXTRA_COPYPATH" ;
    warn ">>>> MESSAGE // OUTPUT FILE ALSO COPIED TO => $EXTRA_COPYPATH" ;
}
##
FUNC_COPY_FILES_TO_DROPBOX_DIR "$OUTPUT_HTML" ;
FUNC_COPY_FILES_TO_DROPBOX_DIR "$OUTPUT_CSV" ;  
##########


## FINALLY RUN THIS COMMAND
echo ">> FINALLY RUN THIS COMMAND with DIR_Y as pwd : rclone sync -P ./awgp/ dreamobjects:public-palibucket/awgp/" | lolcat ; 

##------------------------------------------------------------------------------

################################################################################
############################### PROGRAM ENDS ###################################
################################################################################
echo "$(date) = END-TIME" >> $time_taken
cat $time_taken

