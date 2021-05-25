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
  ## >>>> NOTE: THIS SCRIPT SHOULD BE RUN FROM A DIRECTORY WHERE MANY FOLDERS ARE PRESENT, EACH
  ## >>>> CONTAINING SOME IMAGES.
  ################################################################################
  ## USAGE: bash $THIS_SCRIPT_NAME
  ################################################################################
  ## MADE BY: PALI
  ## MADE ON: Thursday January 23, 2020
  ################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################

CWD=$(pwd);
echo ">>>> COLLAGES WILL BE MADE FOR EACH OF THE FOLLOWING CHILD-DIRECTORIES IN THIS PARENT DIR => $CWD" ;
tree -d $CWD ;
read -p ">>>> If OKAY, press Enter key to contunue ... Else, press CTRL+C to abort." ;
echo ;

################################################################################
## LOOPTING THROUGH ALL CHILD DIRECTORIES
MY_DIR_GITHUB="/home/ubuntu/GitHub" ;
for DIRNAME in $(find "$CWD" -maxdepth 1 -type d) ; do
  cd $DIRNAME ;
  MYDIR=$(basename $DIRNAME);
  echo "##------------------------------------------------------------------------------" ;
  echo ">>>> Making collages for photos in this dir => $MYDIR" ;
  echo ">>>> NOTE: Collages will be made in => $CWD" ;
  echo "##------------------------------------------------------------------------------" ;
  ####
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
      python3 $MY_DIR_GITHUB/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w $my_width -i $my_height -o $CWD/$MYDIR-collage-$my_width$sep$my_height.jpg ;
    done
  done
  ####
  echo ">>>> THESE COLLAGES ARE CREATED:" ;
  ls -1 $CWD/$MYDIR-collage-*.jpg ;
  cd $CWD ;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
done