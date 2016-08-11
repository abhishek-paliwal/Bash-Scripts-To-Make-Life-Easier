#!/bin/bash
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY
echo "#################" #Blank line
# ROOT=`pwd`
ROOT="/Users/abhishek/Dropbox/Public/logos"
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

OUTPUT="all-logos-index.html" ##Output filename

echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
read imagesize
imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>$OUTPUT</title>" > $OUTPUT


echo "<link href='https://fonts.googleapis.com/css?family=Raleway:400,700' rel='stylesheet'>
<style>
div {
    float:left;
    width: $imagesize;
    /* height: $imagesize; */
    padding: 5px;
    margin: 5px;
    color: black;
    font-family: 'Raleway', sans-serif;
    text-align: center;
    font-size: 15px;
    line-height:1;
    /* text-transform: lowercase; */
}

.colored {
  background-color:#00FFFF;
  color:white;
  padding: 20px;
  font-weight:700;
}

h1 {
  font-family: 'Raleway', sans-serif;
	text-align: center;
	font-size: 25px;
  font-weight:700;
	line-height:1;
	text-transform: capitalize;
}

h2, h3 {
  font-family: 'Raleway', sans-serif;
  text-align: center;
  color: #000000;
  font-size: 15px;
}

#p1 {background-color:rgba(`jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 1 1`); color:#fff}

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body bgcolor='#e0e0e0'>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]'`"

echo "<h1>Index of All Our Logos // by Abhishek Paliwal</h1>" >> $OUTPUT
echo "<h1>Total Image Files In This Folder (Recursive) = $totalimagefiles</h1>" >> $OUTPUT
echo "<h2>Page last updated: "`date`"</h2>" >> $OUTPUT


#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo " <hr> <h1 id='p1'> $path</h1>" >> $OUTPUT

  for x in `find "$filepath" -type f| sort | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$'`; do
    file=`basename "$x"`

    ## Finding the image dimensions using ImageMagick's identify command.
    imagedimen="`identify $path/$file | awk '{FS=" "; print "WxH (px)= " $3;}'`";

    ## Finding the FileType for the current file.
    filetype="`file $path/$file | awk '{FS=" "; print $2}'`";
    echo $filetype " - " $path/$file "............DONE!";

## Printing the image dimensions for everything, except GIFs because they produce LOOOOONG outputs for all GIF frames. ##
    if [ "$filetype" != 'GIF' ]; then
      echo "<div><a href='$path/$file'><img src='$path/$file' width='100%' align='top'></img><br><br>$file</a><br> $imagedimen </div>" >> $OUTPUT
    else
      echo "<div><a href='$path/$file'><img src='$path/$file' width='100%' align='top'></img><br><br>$file</a></div>" >> $OUTPUT
    fi

  done
done

#### Calculations end ####
echo "<hr>" >> $OUTPUT
echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## LOGOS Index Successfully created. ######### ";
echo "####### DONE! File will now be opened in FIREFOX. ########"
open -a firefox $OUTPUT
