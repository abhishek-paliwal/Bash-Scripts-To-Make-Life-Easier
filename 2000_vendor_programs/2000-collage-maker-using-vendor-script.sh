#/bin/bash
THIS_SCRIPT_NAME="2000-collage-maker-using-vendor-script.sh" ;
################################################################################
cat << EOF
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
EOF
################################################################################

CWD=$(pwd);
echo ">>>> COLLAGES WILL BE MADE FOR EACH OF THE FOLLOWING CHILD-DIRECTORIES IN THIS PARENT DIR => $CWD" ;
tree -d $CWD ;
read -p ">>>> If OKAY, press Enter key to contunue ... Else, press CTRL+C to abort." ;
echo ;

################################################################################
## LOOPTING THROUGH ALL CHILD DIRECTORIES
for DIRNAME in $(find $CWD -type d -depth 1) ; do
  cd $DIRNAME ;
  MYDIR=$(basename $DIRNAME);
  echo "##------------------------------------------------------------------------------" ;
  echo ">>>> Making 8k, 6k, 4k and 3k collages for photos in this dir => $MYDIR" ;
  echo ">>>> NOTE: Collages will be made in => $CWD" ;
  echo "##------------------------------------------------------------------------------" ;
  ######
  python3 $HOME/Github/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w 8000 -i 900 -o $CWD/$MYDIR-collage-8k.jpg ;
  ######
  python3 $HOME/Github/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w 6000 -i 1200 -o $CWD/$MYDIR-collage-6k.jpg
  ######
  python3 $HOME/Github/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w 4000 -i 1500 -o $CWD/$MYDIR-collage-4k.jpg
  ######
  python3 $HOME/Github/Bash-Scripts-To-Make-Life-Easier/2000_vendor_programs/2000-python_collage_maker.py -f $DIRNAME -w 3000 -i 600 -o $CWD/$MYDIR-collage-3k.jpg
  ######
  echo ">>>> THESE COLLAGES ARE CREATED:" ;
  ls -1 $CWD/$MYDIR-collage-*.jpg ;
  cd $CWD ;
  echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ;
done