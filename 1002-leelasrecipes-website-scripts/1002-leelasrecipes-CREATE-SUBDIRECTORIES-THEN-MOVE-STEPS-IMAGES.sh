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
function calculate_sum_of_digits() {
    ## This function needs a command line long integer, such as 123456 ;
    Num=$1 ;
    # store the sum of digits
    sum=0
    # use while loop to caclulate the sum
    while [ $Num -gt 0 ]
    do   
        k=$(( $Num % 10 ))  # get Remainder  
        Num=$(( $Num / 10 )) # get next digit
        sum=$(( $sum + $k ))     # calculate sum of digits 
    done
    echo "$sum" ;
}
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

####
echo "Enter the images count (eg: 3231232313, etc), separated by NO spaces ..." ; 
read my_string
#my_string="3231232313" ; ## Example
##
echo "MY STRING IS => $my_string" ;
## Deleting any invisible spaces ...
my_string=$(echo $my_string | sed 's/ //g') ;

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## PRINTING SOME CALCULATIONS ON CLI
len_string=$(echo "${#my_string} - 1" | bc ) ; 
num_recipesteps=$(echo "$len_string +1" | bc ) ; 
echo "$num_recipesteps => Length of string (meaning number of recipe steps)" ;
##
num_stepsImages=$(calculate_sum_of_digits $my_string) ; ## get from the function
num_original_images=$(fd -t f -e png -e jpg -e jpeg -e PNG -e JPG | wc -l) ;
echo "$num_stepsImages => Sum of digits (meaning calculated number of total images)" ;
echo "$num_original_images => Original images found" ;
####
## Split the string and store characters in an array 
for j in $(seq 0 $len_string) ; do 
    my_array[$j]=${my_string:$j:1} ;
done
echo "MY ARRAY ELEMENTS => ${my_array[@]}" ;
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