#/bin/bash

SCRIPT_BASENAME=$(basename $0)
SCRIPT_BASENAME_SANS_EXTN="${SCRIPT_BASENAME%.*}"
WORKDIR="$DIR_Y/$SCRIPT_BASENAME_SANS_EXTN" ; 
mkdir -p $WORKDIR ;

####
maxlength=80 ; 
#### 
hline="################################################################################" ; 
aline=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" ; 
bline="<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" ; 
mline="--------------------------------------------------------------------------------" ;
pline="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
xline="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ;

################################################################################
## main function
################################################################################
palidivider () {
    ## This function takes a string and prints it in a box of a given
    ## width made with chosen characters
    ## Arguments:
    ## \$1. string to print
    ## \$2. character_line to use for the left side of the box
    ## \$3. character_line to use for the right side of the box
    stringInput="$1" ;
    lineBegin=$2 ; 
    lineEnd="$3" ;
    # check if cli argument exists. If not, use defaults.
    if [ -z "$1" ] ; then stringInput="" ; lineBegin="$hline" ; lineEnd="$hline" ; fi
    if [ -z "$2" ] ; then lineBegin="$aline" ; lineEnd="$bline" ; fi
    ## fold the input
    tmpfile="$WORKDIR/_tmp1.txt" ;
    echo $stringInput | fold -w70 -s > $tmpfile ;
    ########
    echo;
    echo $aline ; 
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
    echo $bline ; 
    echo; 
}
################################################################################

# test string = lorem ipsum
stringInput="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed auctor, augue et tincidunt aliquam, nulla nisl aliquam ligula, eget scelerisque dui justo a nunc. Nullam sed nulla ac turpis lacinia aliquam adipiscing ela." ; 

## Examples of usage
# palidivider "$stringInput" $aline $bline
# palidivider "$stringInput" $hline $hline
# palidivider "$stringInput" $pline $mline
# palidivider "THIS IS A TEST STRING. THIS IS A TEST STRING. THIS IS ANOTHER TEST STRING." 
