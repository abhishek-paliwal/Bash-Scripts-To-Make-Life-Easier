#/bin/bash
################################################################################
## This script is contains a function which prints a string in a box of a given width made with chosen characters
## Date created: 2023-03-30
## Created by: Pali
################################################################################
## Examples of usage from other scripts after sourcing this script
## palidivider arg1 arg2 arg3
    ## Arguments:
    ## \$1. string to print
    ## \$2. character_line to use for the left side of the box (palihline|palialine|palibline|palimline|palipline|palixline)
    ## \$3. character_line to use for the right side of the box (palihline|palialine|palibline|palimline|palipline|palixline)
    ## Examples:
# palidivider "$testStringInput" $palialine $palibline
# palidivider "$testStringInput" $palihline $palihline
# palidivider "$testStringInput" $palipline $palimline
# palidivider "THIS IS A TEST STRING. THIS IS A TEST STRING." 
################################################################################

################################################################################
## Main Function
################################################################################
palidivider () {
    ## This function takes a string and prints it in a box of a given
    ## width made with chosen characters
    ## Arguments:
    ## \$1. string to print
    ## \$2. character_line to use for the left side of the box
    ## \$3. character_line to use for the right side of the box
    ####################################
    local FUNCTION_NAME="$FUNCNAME" ;
    local OUTDIR="$DIR_Y/_tmp_output_$FUNCTION_NAME" ; 
    mkdir -p "$OUTDIR" ;
    local tmpfile="$OUTDIR/_tmp1.txt" ;
    local maxlength=80 ; 
    ####################################
    stringInput="$1" ;
    lineBegin=$2 ; 
    lineEnd="$3" ;
    # check if cli argument exists. If not, use defaults.
    if [ -z "$1" ] ; then stringInput="" ; lineBegin="$palihline" ; lineEnd="$palihline" ; fi
    if [ -z "$2" ] ; then lineBegin="$palialine" ; lineEnd="$palibline" ; fi
    ## fold the input
    echo $stringInput | fold -w70 -s > "$tmpfile" ;
    ########
    echo;
    echo $palialine ; 
    ##
    while read line ; do
        #echo "$line" ;
        countBegin=$((  ((maxlength - ${#line})/2)-1   )) ; 
        #countBegin=5 ; 
        countEnd=$(( (maxlength - ${#line} - $countBegin) -2 )) ;
        #echo $maxlength $countBegin $countEnd ${#line};
        newline="${lineBegin:0:$countBegin} $line ${lineEnd:0:$countEnd}" ;
        echo "$newline" ;
    done < "$tmpfile"
    ##
    echo $palibline ; 
    echo; 
}
################################################################################

## Variables to be used by other scripts after sourcing this script
palihline="################################################################################" ; 
palialine=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ; 
palibline="<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; 
palipline="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
palimline="--------------------------------------------------------------------------------" ;
palixline="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ;

# test string = lorem ipsum
testStringInput="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed auctor, augue et tincidunt aliquam, nulla nisl aliquam ligula, eget scelerisque dui justo a nunc. Nullam sed nulla ac turpis lacinia aliquam adipiscing ela." ; 

################################################################################
# Unset variables to avoid name collisions in other scripts after sourcing this script
################################################################################
unset OUTDIR
unset testStringInput
unset lineBegin
unset lineEnd
unset tmpfile
unset countBegin
unset countEnd
unset newline
################################################################################
