#!/bin/bash
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY
echo "#################" #Blank line
ROOT="$HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/logos"
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

FINALFILENAME="all-logos-index.html"
OUTPUT="$ROOT/$FINALFILENAME" ##Output filename
SITEURL="https://downloads.concepro.com/dropbox-public-files/logos/$FINALFILENAME"

##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>$FINALFILENAME</title>" > $OUTPUT


echo "<link href='https://fonts.googleapis.com/css?family=Oswald' rel='stylesheet'>

<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js'></script>

<!-- LAZY-LOADER OF IMAGES -  JQUERY Plugin -->
<script type='text/javascript' src='https://abhishek-paliwal.github.io/wallpaper_creators/js/JQUERY.LAZY.MIN.js'></script>

<script>

  \$(document).ready(function(){
        // ENABLING LAZY LOADING
        \$('.lazy').Lazy();
  });

</script>

<style>
div {
    float:left;
    /* width: $imagesize; */
    /* height: $imagesize; */
    width: 200px;
    padding: 5px;
    margin: 5px;
    color: black;
    font-family: 'Oswald', sans-serif;
    text-align: center;
    font-size: 15px;
    line-height:1.5;
    /* text-transform: lowercase; */
    background-color: rgb(245,245,245) ;
    border : 2px solid white ;
		box-shadow: 0px 0px 5px #999 ;
		border-radius : 2px ;
}

.colored {
  background-color:#00FFFF;
  color:white;
  padding: 20px;
  font-weight:700;
}

h1 {
  font-family: 'Oswald', sans-serif;
	text-align: center;
	font-size: 25px;
  font-weight:700;
	line-height:1;
	text-transform: capitalize;
}

h2, h3 {
  font-family: 'Oswald', sans-serif;
  text-align: center;
  color: #000000;
  font-size: 15px;
}

.p1 {background-color:rgba(`jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 1 1`); color:#fff; text-transform: uppercase; padding:10px;}

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body  style='background-color: rgb(220,220,220) ;'>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]'`"

echo "<h1>Index of All Our Logos // by Abhishek Paliwal</h1>" >> $OUTPUT
echo "<h1>Total Image Files In This Folder (Recursive) = $totalimagefiles</h1>" >> $OUTPUT
echo "<h2>Page last updated: "`date`"</h2>" >> $OUTPUT

##### CREATING THE HREF-NAME LINKS FOR ALL THE FOLDERS #####
echo "<hr>" >> $OUTPUT
echo "<h1>- Table of Contents -</h1>" >> $OUTPUT

for foldername in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  folder=`basename "$foldername"`
  echo "<h2 style='font-family: Times, Serif; text-transform: uppercase; letter-spacing: 2px;'><a href='#$folder'> $folder</a><h2> " >> $OUTPUT
done
#### Link Creation Ends #####

#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo " <hr> <h1 class='p1'> <a name='$path'>$path</a> <a href='#'>(>Back to top)</a></h1>" >> $OUTPUT

  for x in `find "$filepath" -type f| sort | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$'`; do
    file=`basename "$x"`

    ## Finding the image dimensions using ImageMagick's identify command.
    imagedimen="`identify $ROOT/$path/$file | awk '{FS=" "; print "WxH= " $3 " - " $7 ;}'`";

    ## Finding the FileType for the current file.
    filetype="`file $ROOT/$path/$file | awk '{FS=" "; print $2}'`";
    echo $filetype " - " $ROOT/$path/$file "............DONE!";
    echo "IMAGE-DIMENSIONS - " $imagedimen "\n";

## Printing the image dimensions for everything, except GIFs because they produce LOOOOONG outputs for all GIF frames. ##
    if [ "$filetype" != 'GIF' ]; then
      echo "<div><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%' align='top'></img><br><br>$file</a><br> $imagedimen </div>" >> $OUTPUT
    else
      echo "<div><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%' align='top'></img><br><br>$file</a></div>" >> $OUTPUT
    fi

  done
done

#### Calculations end ####
echo "<hr>" >> $OUTPUT
echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## LOGOS Index Successfully created. ######### ";
echo "####### DONE! File will now be opened in SAFARI. ########"
open -a Safari $OUTPUT
open -a Safari $SITEURL