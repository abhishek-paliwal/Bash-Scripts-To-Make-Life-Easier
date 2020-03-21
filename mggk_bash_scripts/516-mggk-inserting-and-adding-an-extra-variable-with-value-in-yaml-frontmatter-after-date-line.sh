#!/bin/bash
################################################################################
## THIS PROGRAM SHOULD NEVER BE RUN AGAIN, EVER. SO, DISPLAYING ERROR MESSAGE.
echo ">>>> THIS SCRIPT SHOULD NEVER BE RUN AGAIN, NOT EVEN BY MISTAKE. ITS JOB IS DONE." ;
echo ">>>> HENCE, THE PROGRAM WILL EXIT NOW."
exit 1;
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## This program adds (inserts) an extra yaml frontmatter variable of your choice, in markdown files.
  #### To do this, it first finds the 'date' frontmatter line using grep, and then replaces
  #### it with itself + one more yaml frontmatter variable at the end.
  #### This is to make sure that our newly added frontmatter variable always
  #### appears after the date frontmatter variable line.
  ###############################################################################
  ## CREATED ON: Thursday September 26, 2019
  ## CREATED BY: PALI
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


################################################################################
DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
################################################################################

## => md files with no featured_image
## Printing out all the filenames which don't have the 'featured_image' keyword in them
grep -irL 'featured_image' $DIR/** |grep '.md'

## Looping through all the interesting md files thus found
counter=0;
for x in $(grep -irL 'featured_image' $DIR/** |grep '.md');
do
((counter++))
#echo "$counter// $x"

## finding existing date var line
date_var=$(grep -i '^date:' $x) ;

## creating the new variable value to be inserted
image_var=$(grep -io 'src="https://www.myginger.*.jpg" ' $x | head -1 | sed -e 's/"//g' -e 's|src=https://www.mygingergarlickitchen.com||g' )

image_var_full="featured_image: $image_var" ;

## Only put the featured_image in yaml frontmatter if image_var is not empty
if [ -z "$image_var" ] ;
then
echo "image_var = EMPTY" ;
else

echo "image_var = NOT EMPTY" ;
echo "$image_var" ;

## IN-FILE REPLACEMENT // SED IN-FILE MULTILINE REPLACEMENT ON MAC OS
#### Interesting thing to note here is that you need to add \\ at the end of each line in sed -i
#### command on MAC OS version of sed, in order to add line breaks at certain places. Knowing this
#### is very important.
sed -i '' "s|$date_var|$date_var\\
$image_var_full\\
|" $x

fi

echo;
done
