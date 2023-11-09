#!/bin/bash
THIS_SCRIPT_NAME="$(basename $0)" ;
THIS_SCRIPT_NAME_SANS_EXTENSION="$(echo $THIS_SCRIPT_NAME | sed 's/\.sh//g')" ;
##
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
    ################################################################################
    ## USAGE:
    #### > bash $THIS_SCRIPT_NAME
    ################################################################################
    ## This script concerns recipe steps images. 
    ## This script needs user input as a number string. It then splits that string into
    ## an array, and based on the array element, moves those number of recipe steps images
    ## present in CWD (jpg + png) into corresponding automatically created subdirectories.
    ################################################################################
    ## CREATED BY: PALI
    ## CREATED ON: NOV 11, 2020
    ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## FUNCTION DEFINITION
function calculate_sum_of_digits_of_array() {
    # Initialize sum to 0
    sum=0
    # Iterate through the array and add each number to the sum
    for num in "${my_array[@]}"; do  sum=$((sum + num)) ; done
    # Print the sum
    echo "$sum" ; 
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####
echo "Enter the images count (eg: 323123, OR with comma, eg: 11,12,13,21) ..." ; 
read my_string_raw
## Deleting any invisible spaces ...
my_string=$(echo $my_string_raw | sed 's/ //g') ;


## CREATE ARRAY DEPENDING UPON WHETHER INPUT HAS COMMAS IN BETWEEN NUMBERS OR NOT
if [[ $my_string == *","* ]]; then
  echo "The string contains a COMMA. Array will be calculated accordingly..." ; 
  ## Replace commas with spaces and store the result in an array
  my_array=(${my_string//,/ }) ; 
else
  echo "The string DOES NOT contain a COMMA. Array will be calculated accordingly..." ; 
  ## grep matches every character in the string and ...
  ## ... prints it on a new line, resulting in an array
  my_array=($(echo "${my_string}" | grep -o .)) ; 
fi

## PRINTING
echo "MY STRING IS      => $my_string" ;
echo "MY ARRAY ELEMENTS => ${my_array[@]}" ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRINTING SOME CALCULATIONS ON CLI
num_recipesteps=$(echo "${#my_array[@]}" | bc ) ; 
echo; 
echo "$num_recipesteps => Length of string (meaning number of recipe steps)" ;
echo; 
##
num_stepsImages=$(calculate_sum_of_digits_of_array) ; ## get from the function
num_original_images=$(fd -t f -e png -e jpg -e jpeg -e PNG -e JPG | wc -l) ;
echo "$num_stepsImages => Sum of digits (meaning calculated number of total images)" ;
echo "$num_original_images => Original images found" ;
####
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####
read -p ">> If OKAY, press ENTER key to continue ..."  ;

####
## ZIP all files found in PWD for backup (just in case) ...
echo ">> ZIPPING ... creating backup ..." ; 
tmpdir="_tmpdir_original_images" ;
zip -v $tmpdir.zip *.* ; 

## Make sequential directory for each array element and move images to it
echo; echo ">> CREATING SUBDIRECTORIES ..." ;
########
count=1 ;
for i in "${my_array[@]}" ; do
    dir_name=$(printf "%03d" $count) ; ## padded with zeroes
    echo;
    echo "$count // Number of images to move = $i" ; 
    echo ">> Creating directory: $dir_name" ; 
    mkdir $dir_name ; 
    ###
    ### Move images one by one to this new directory
    for x in $(seq 1 1 $i); do
        image_to_move="$(fd -t f -d1 -e jpg -e png | sort | head -1)" ;
        echo ">> MOVING THIS IMAGE => $image_to_move => $dir_name" ;
        mv "$image_to_move" $dir_name ;
    done
    ###
    ((count++))
done
########

## PRINTING THE FINAL DIRECTORY TREE NOW ...
echo; echo ">> Current Directory Tree ..." ; echo ;
tree