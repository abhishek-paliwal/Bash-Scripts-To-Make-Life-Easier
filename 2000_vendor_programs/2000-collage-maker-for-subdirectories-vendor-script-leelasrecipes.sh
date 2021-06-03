#/bin/bash
THIS_SCRIPT_NAME="2000-collage-maker-using-vendor-script-leelasrecipes.sh" ;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ################################################################################
  ## THIS SCRIPT MAKES COLLAGES WITH VARIOUS RESOLUTIONS USING VENDOR PYTHON COLLAGE MAKER.
  ## THIS SCRIPT MAKES COLLAGES FOR RECIPE STEPS IMAGES FOR LEELASRECIPES.
  ## >>>> NOTE: THIS SCRIPT SHOULD BE RUN FROM A DIRECTORY WHERE MANY FOLDERS ARE PRESENT, EACH
  ## >>>> CONTAINING SOME IMAGES.
  ################################################################################
  ## USAGE: bash $THIS_SCRIPT_NAME
  ################################################################################
  ## MADE BY: PALI
  ## MADE ON: Thursday May 28, 2021
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
## ALL FUNCTION DEFINITIONS
################################################################################
################################################################################
function FUNC_CREATE_COLLAGE_WITH_GIVEN_COMBINATION_OF_DIMENSIIONS {
  CWD="$1"
  ## LOOPTING THROUGH ALL CHILD DIRECTORIES
  for DIRNAME in $(find "$CWD" -maxdepth 1 -type d) ; do
    cd $DIRNAME ;
    MYDIR=$(basename $DIRNAME);
    echo ">> CURRENT SUBDIRECTORY => $MYDIR" ;
    # DECLARING TWO ARRAYS FOR VARIOUS HEIGHTS AND WIDTHS
    #list_widths=(800 1000 1280 1500 1920 2000 3000 4000 6000 8000) ;
    #list_heights=(500 600 720 800 1000 1080 1200 1500 1600 1800 2000) ;
    list_widths=(1280 1920) ;
    list_heights=(720 1080) ;
    ####
    for my_width in "${list_widths[@]}" ; do
      for my_height in "${list_heights[@]}" ; do
        echo ">> CURRENTLY RUN DIMENSIONS => $my_width X $my_height" ;
        sep="x" ;
        python3 $REPO_SCRIPTS/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w $my_width -i $my_height -o $CWD/$my_width$sep$my_height-collage-DIR-$MYDIR.jpg ;
      done
    done
    ####
    ## MAKING VERTICAL AND HORIZONTAL COLLAGES WITH ALL IMAGES IN DIRNAME
    python3 $REPO_SCRIPTS/2000_vendor_programs/2000-python_collage_maker_vertical_and_horizontal_grid.py $DIRNAME $CWD ;
    ####
  done
}

function FUNC_CREATE_COLLAGE_IN_GRID {
  ## THIS FUNCTION CREATES VARIOUS COLLAGES FOR EACH SUBDIRECTORY 
  #### IN GRIDS WITH DIFFERENT NUMBER OF IMAGES PER ROW
  CWD="$1"
  ## LOOPTING THROUGH ALL CHILD DIRECTORIES
  for DIRNAME in $(find "$CWD" -maxdepth 1 -type d) ; do
    cd $DIRNAME ;
    MYDIR=$(basename $DIRNAME);
    ## MAKING VERTICAL AND HORIZONTAL COLLAGES WITH ALL IMAGES IN DIRNAME
    python3 $REPO_SCRIPTS/2000_vendor_programs/2000-python_collage_maker_vertical_and_horizontal_grid.py $DIRNAME $CWD ;
    ####
  done
}
################################################################################
################################################################################

CWD=$(pwd);
echo ">>>> COLLAGES WILL BE MADE FOR EACH OF THE FOLLOWING CHILD-DIRECTORIES IN THIS PARENT DIR => $CWD" ;
tree -d $CWD ;
read -p ">>>> If OKAY, press Enter key to contunue ... Else, press CTRL+C to abort." ;
echo ;

## CALLING COLLAGE MAKING FUNCTIONS
FUNC_CREATE_COLLAGE_WITH_GIVEN_COMBINATION_OF_DIMENSIIONS "$CWD"
FUNC_CREATE_COLLAGE_IN_GRID "$CWD"

echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
echo ">>>> THESE COLLAGES ARE CREATED:" ;
ls -1 $CWD/*collage*.jpg ;
cd $CWD ;
echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
