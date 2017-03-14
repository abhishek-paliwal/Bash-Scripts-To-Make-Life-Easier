#!/bin/bash
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES + JSON FILES IN WORKING DIRECTORY, RECUSRSIVELY.
ROOT="$HOME/GitHub/abhishek-paliwal.github.io/wallpaper_creators/JSON-templates-for-design"
OUTPUT="$ROOT/Index-of-all-JSON-files.html"
cd $ROOT ;

echo #Blank line
pwd ##check the present working directory
echo #Blank line

echo '======== Current filename order ========'
ls -1 *.{jpg,png,PNG,JPG} | nl ##sort output as 1 column

echo '==================='
echo `ls -1 *.{jpg,png,PNG,JPG} | head -1 | wc -m`
echo "= Character length including file extension (jpg/JPG or png/PNG)"
echo "So sort number to be used below could be this number minus 5 (or 6)."
echo '==================='

#echo -n "Sort filenames at which character number (Enter '1' if you're not sure) [ENTER]:"
#read sortnumber

sortnumber="1" # This will be used somewhere below, as a FAILSAFE.

echo '========== So this is the filename order that you want: ========='
ls -r *.{jpg,png,PNG,JPG} | nl

titlename=$OUTPUT ;

#ASSIGN FILENAME. AND NO SPACES BETWEEN VARNAME and '=' SIGN; else Bash throws error.
totalfiles="`ls -rl *.{jpg,png,PNG,JPG} | wc -l | tr -d '[[:space:]]'`"
totalfiles+=" Images"
echo "$totalfiles"
#echo "$titlename-$totalfiles.html" ##this output shows leading spaces, donno why. So SED is used below.

filenamex=`echo "$titlename" | sed -e 's/ /-/g'`

#echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
#read imagesize
#imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>Index - JSON files</title>" > $filenamex

echo "<link href='https://fonts.googleapis.com/css?family=Roboto:300,400,400i,700,900' rel='stylesheet'>

<style>

body {
  background: rgba(245,245,245,1) ;
}
div {
    float:left;
    width: 220px ;
    /* height: 220px ;  */
    /* padding: 5px; */
    margin: 5px;
    color: black;
    background-color : white ;
    font-family: 'Roboto', sans-serif;
    text-align: center;
    font-size: 15px;
    line-height:1;
    /* text-transform: lowercase; */
    border : 10px solid white ;
    box-shadow: 0px 0px 5px #aaa ;
    border-radius : 2px ;
}

    /*** for 2 adjacent divs ***/
    div + div{
    margin-left : 10px;
    }

.colored {
  background-color:#00FF00;
  color:white;
  padding: 20px;
  font-weight:700;
}

h1 , h2 {
  display : block ;
  padding : 10px ;
  background : linear-gradient(-45deg, hsla(300,100%, 50%, 1), hsla(10,100%, 50%, 1) ) ;
  color : white ;
  font-family: 'Roboto', sans-serif;
	text-align: center;
	font-size: 20px;
  font-weight:700;
	line-height:1.3;
	text-transform: capitalize;
}

h3 {
  display : block ;
  padding : 10px ;
  background-color : rgb(50,50,50) ;
  color : #c0c0c0 ;
  font-family: 'Roboto', sans-serif;
	text-align: center;
	font-size: 16px;
  font-weight:700;
	line-height:1.3;
}


hr {clear:both;}
</style>" >> $filenamex

echo "</head><body>" >> $filenamex

echo "<h1>Index of all JSON files<br>// Total Image Files In This Folder (Non-Recursive) = $totalfiles //</h1>" >> $filenamex

echo "<h3>Only JPG / jpg / PNG / png files are included below.<br>If you don't see your desired file below, try changing its extension to these.</h3>" >> $filenamex

#for x in `ls -r *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
for x in `ls -r *.{jpg,png,PNG,JPG}` # ls reverse sorting

	do
    # Getting substring from the end without the file extension
    file_without_extension=`echo ${x%.*}`
    file_without_extension+=".json"

		echo "<div><a href='$x'><img src='$x' width='100%' align='top'></img><br><br>$x</a><br><br><strong><a href='$file_without_extension'>Get JSON</a></strong></div>" >> $filenamex
	done;

############################################################
#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
#totalimagefiles="`find . -type f | egrep -i '\.(jpg|png|PNG|JPG)$' | wc -l | tr -d '[[:space:]]'`"

#echo "<hr><br><h1>Total Image Files In This Folder + SubFolders (RECURSIVE) = $totalimagefiles)</h1>" >> $filenamex

#for x in `find . -type f | egrep -i '\.(jpg|png|PNG|JPG)$'`
#  do
#  	echo "<div><a href='$x'><img src='$x' width='100%' align='top'></img><br><br>$x</a></div>" >> $filenamex
#  done;
##### OPTIONAL SECTION ENDS #####
############################################################

echo "<hr>" >> $filenamex

createdOn=`date` ;
echo "<h2>File auto-created on : $createdOn // by <a href='http://www.AbhishekPaliwal.com'>Abhishek Paliwal</a></h2>" >> $filenamex

echo "</body></html>" >> $filenamex

#Open the newly created file in browser
echo "DONE! File will now be opened in SAFARI."
open -a Safari $filenamex
