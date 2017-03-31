#!/bin/bash
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY + RECUSRSIVELY
echo "#################" #Blank line
ROOT="$HOME/Dropbox/Public/_TO_SYNC_downloads.concepro.com/_BRAND-CONCEPRO/concepro-08-social/sharing"
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

FINALFILENAME="Index-of-SocialMedia-files.html"
OUTPUT="$ROOT/$FINALFILENAME" ##Output filename
SITEURL="https://downloads.concepro.com/_BRAND-CONCEPRO/concepro-08-social/sharing/$FINALFILENAME"

##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>Library of Social Media Images // Concepro Agency</title>" > $OUTPUT

echo "<link href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,700,900' rel='stylesheet'>

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
    font-family: 'Roboto', sans-serif;
    text-align: center;
    font-size: 15px;
    line-height:1.5;
    /* text-transform: lowercase; */
    background-color: rgb(245,245,245) ;
    border : 2px solid white ;
		box-shadow: 0px 0px 5px #999 ;
		border-radius : 2px ;
}

div.heading {
    display: block ;
    padding: 0px;
    margin: 0px;
    margin-bottom : 20px ;
    clear: both ;  /* Clearing floats if any */
    width: 100% ;
    height: auto;
    /* Concepro Colored Background Gradient */
    background : linear-gradient( 45deg, #007fff, #ff8700 ) ;
    border : 0px solid white ;
		box-shadow: 0px 0px 0px #999 ;
		border-radius : 0px ;
}

.colored {
  background-color:#00FFFF;
  color:white;
  padding: 20px;
  font-weight:700;
}

h1 {
  display : block ;
  padding : 10px ;
  color : white ;
  font-family: 'Roboto', sans-serif;
	text-align: center;
	font-size: 30px;
  font-weight: 100;
	line-height: 1.3;
	/* text-transform: uppercase ; */
}

h1.heading {
   font-size: 100px ;
   font-weight: 900 ;
   letter-spacing: 5px ;
   line-height: 0.9 ;
   text-transform: uppercase ;
}

h2 {
  font-family: 'Roboto', sans-serif;
  text-align: center;
  color: black ;
  font-weight: 700;
  font-size: 22px;
}

h2.heading {
  font-weight: 100;
  font-size: 40px;
}

h3 {
  font-family: 'Roboto', sans-serif;
  text-align: center;
  color: #999 ;
  font-weight: 900;
  font-size: 16px;
}

hr {
  width: 200px ;
  height: 10px ;
  border: 0px ;
  background-color: black ;
}

.thin {
  font-weight : 300 ;
}

.p1 {background : linear-gradient( 45deg, #3498db, #ff8700 ) ; color: white ; text-transform: uppercase ; padding : 10px ; }

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body style='background-color: rgb(230,230,230) ;'>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]'`"

echo "<!-- HEADING DIV STARTS --> <div class='heading'>"  >> $OUTPUT

echo "<!-- TOP LOGO --> <img src='http://downloads.concepro.com/dropbox-public-files/logos/4-logos-concepro/Concepro-Shadow.png' style='width: 300px; '>" >> $OUTPUT

echo "<h1 class='heading'>Full Library Of All Social Media Images</h1>" >> $OUTPUT

echo "<hr>" >> $OUTPUT

echo "<h2 class='heading'>Designed by <a href='http://www.AbhishekPaliwal.com'>Abhishek Paliwal</a> for <a href='http://www.concepro.com'>Concepro Digital Marketing Agency</a></h2>" >> $OUTPUT

echo "<!-- HEADING DIV ENDS --> </div>"  >> $OUTPUT

echo "<h2 class='thin'>Total Images On This Page (Recursive) = $totalimagefiles</h2>" >> $OUTPUT
echo "<h3 class='thin'>Page last updated: "`date`"</h3>" >> $OUTPUT

##### CREATING THE HREF-NAME LINKS FOR ALL THE FOLDERS #####
echo "<hr>" >> $OUTPUT
echo "<h2 style='padding: 10px; border: 2px solid #000 ;'>&bull; Table of Contents &bull;</h2>" >> $OUTPUT

for foldername in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  folder=`basename "$foldername"`
  echo "<h2 style='text-transform: uppercase; letter-spacing: 2px;'><a href='#$folder'> $folder</a><h2> " >> $OUTPUT
done
#### Link Creation Ends #####

#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo " <hr> <h2 class='p1'> <a name='$path'>$path</a> <a href='#'>( &uarr; Back to top )</a></h2>" >> $OUTPUT

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
      echo "<div><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%' align='top'></img><br><br><span class='thin'>$file</a></span><br>$imagedimen</div>" >> $OUTPUT
    else
      echo "<div><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%' align='top'></img><br><br><span class='thin'>$file</span></a></div>" >> $OUTPUT
    fi

  done
done

#### Calculations end ####
echo "<hr>" >> $OUTPUT
echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## LOGOS Index Successfully created. ######### ";
echo "####### DONE! File will now be opened in SAFARI. ########"
open -a Safari $SITEURL
open -a Safari $OUTPUT
