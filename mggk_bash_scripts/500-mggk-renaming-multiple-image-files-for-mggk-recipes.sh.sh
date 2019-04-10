#!bin/bash
cat << EOF
    ##############################################################################
    ## FILENAME: 500-mggk-renaming-multiple-image-files-for-mggk-recipes.sh
    ## USAGE: (\$1 = directory location where images are stored)
    ## > sh FILENAME \$1
    ##############################################################################
    ## THIS SCRIPT RENAMES MULTIPLE RECIPE IMAGE FILES FROM SPECIFIED TAGS
    ## It expects a command line input arguement, which is the directory location
    ## where the images to be renamed are stored.
    ##############################################################################
    ## Coded on: Friday March 17, 2017
    ## By: Pali
    ##############################################################################
EOF

echo ">>>> Present working directory: $(pwd)" ;

## User confirmation to continue
read -p "If PWD is correct, please press ENTER to continue ..." ;
echo ">>>>>>>>>>>>>>>>> GOOD TO GO ... >>>>>>>>>>>>>>>>>>>>" ;

## Defining main function; will be called at the end
rename_recipe_images_here () {

  if [[ "$1" == "" ]] ; then
    echo "ARGUMENT ERROR: You forgot to supply the folder location as argument. Please provide."
  fi

  ## Defining variabless
  THISFOLDERNAME=`basename $1` ## Removes all the slashes from $1 and gives out only the folder name.
  RENAME_DIR="$1/_renamed_files_DELETE_LATER"
  LOGFILE="$RENAME_DIR/_TMP_LOGFILE.TXT"

  ## Defining PREFIX TAGS array, one by one (add more if needed):
  ImageTags[0]='food-photography-of'
  ImageTags[1]='food-styling-of'
  ImageTags[2]='recipe-of'

  ## Defining SUFFIX TAGS array, one by one (add more if needed) :
  suffixTags[0]='by-anupama-paliwal'
  suffixTags[1]='by-my-ginger-garlic-kitchen'


  echo "Created on : "`date` > $LOGFILE
  cd $1
  mkdir $RENAME_DIR

  echo "####################################################" >> $LOGFILE
  echo "## FILES IN DIR: "$1                                  >> $LOGFILE
  echo "####################################################" >> $LOGFILE

  ## Listing all image files to a tmp txt file
  ls -c *.{JPG,jpg,PNG,png} | nl >> $LOGFILE ## Putting all files in a temp logfile with line numbers
  echo "####################################################" >> $LOGFILE

  # Magic Begins
  echo '++++++++++++++++++++++++++++++++++++++++++++++++++'
  echo '===>>>>>>>> BEGINNING : RENAMING Recipe Images at : '$1


######################################################
####### DO NOT CHANGE ANYTHING BELOW #################

    ls -c *.{JPG,jpg,jpeg,PNG,png,gif,GIF} | cat -n | while read n file; do

        ## some more variables and their calculations
        prefix_index=`expr $n % ${#ImageTags[@]}` ## Remainder becomes prefix-index
        suffix_index=`expr $n % ${#suffixTags[@]}` ## Remainder becomes suffix-index
        n_new=$(printf "%02d" "$n") ## Formatting the line-number Adding leading zeros
        new_filename=$n_new'-'${ImageTags[$prefix_index]}'-'$THISFOLDERNAME'-'${suffixTags[$suffix_index]}

        echo "OLDNAME: $file"
        echo "NEWNAME: $new_filename ( PREFIX-INDEX: $prefix_index + SUFFIX-INDEX : $suffix_index )"

            ### Seperating filename from extension
            filename=$(basename "$file")
            extension="${filename##*.}"
            filename="${filename%.*}"

        ############ THE MAIN THING - THE CRUX ########
        cp "$file" "$RENAME_DIR/$new_filename.$extension"; ## copying with new name to $RENAME_DIR
        ####################################

        echo "RENAMED and COPIED : $file ===== TO ===> $RENAME_DIR/$new_filename.$extension" >> $LOGFILE

    done

  echo '===>>>>>>>> DONE : Renaming all image files at '$1

  ### Opening directory
  echo 'Opening directory : '$1
  open $1 # Works only on Mac
}

## Actual magic by calling the function with required directory as arguments
#rename_recipe_images_here $HOME/Desktop/_TMP_Automator_results_
rename_recipe_images_here `pwd`

##############################################################################
########################### PROGRAM ENDS #####################################
