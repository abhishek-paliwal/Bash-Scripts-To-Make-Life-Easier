#!/bin/bash
###############################################################################
THIS_SCRIPT_NAME="597a-mggk-INSERTING-first_published_on_VARIABLE-IN-YAML-FRONTMATTER-AFTER-DATE-LINE.sh"
###############################################################################

cat << EOF
  ###############################################################################
  ## This program adds (inserts) an extra yaml frontmatter
  ## variable => first_published_on, in all markdown files.
  ####
  #### To do this, it first finds the 'date' frontmatter line using grep, and then
  #### replaces it with itself + our yaml frontmatter variable at the end.
  #### This is to make sure that our newly added frontmatter variable always
  #### appears after the date frontmatter variable line.
  ################################################################################
  ## USAGE:
  ## bash $THIS_SCRIPT_NAME
  ###############################################################################
  ## CREATED ON: Monday December 2, 2019
  ## CREATED BY: PALI
  ###############################################################################
EOF

################################################################################
DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
################################################################################

## => MD FILES WITH NO first_published_on FRONTMATTER TAG
echo; echo ">>>> PRINTING OUT ALL THE FILENAMES WHICH DON'T HAVE first_published_on YAML FRONTMATTER TAG:" ;
grep -irL 'first_published_on' $DIR/** |grep '.md'
## COUNTING THEM
echo "$(grep -irL 'first_published_on' $DIR/** |grep '.md'|wc -l) = VALID FILES FOUND."

## Looping through all these md files which don't have our chosen fronmatter tag
counter=0;
for x in $(grep -irL 'first_published_on' $DIR/** |grep '.md');
do
  ((counter++))
  echo "$counter// $x"
  ## finding existing date var line
  date_var=$(grep -i '^date:' $x) ;
  date_value=$(echo "$date_var" | sed -e 's/ //g' -e 's/date://g' ) ;

  ## creating the new variable value to be inserted
  OUR_NEW_VAR="first_published_on: $date_value"

  ## Only put the first_published_on in yaml frontmatter if OUR_NEW_VAR is not empty
  if [ -z "$OUR_NEW_VAR" ] ; then
    echo "OUR_NEW_VAR = EMPTY" ;
  else
    echo "OUR_NEW_VAR = NOT EMPTY" ;
    echo "$OUR_NEW_VAR" ;
    ## IN-FILE REPLACEMENT // SED IN-FILE MULTILINE REPLACEMENT ON MAC OS
    #### Interesting thing to note here is that you need to add \\ at the end of each line in sed -i
    #### command on MAC OS version of sed, in order to add line breaks at certain places. Knowing this
    #### is very important.
sed -i '' "s|$date_var|$date_var\\
$OUR_NEW_VAR\\
|" $x

fi

echo;
done
