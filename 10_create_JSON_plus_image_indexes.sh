#!/bin/bash
## THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES + JSON FILES IN WORKING DIRECTORY, RECUSRSIVELY.
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

#echo '========== So this is the filename order that you want: ========='
#ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber | nl

#echo -n "[REQUIRED FIELD] Enter the title for the HTML page; Spaces will be converted to hyphens; [ENTER]: "
#read titlename

titlename="json-file-index"

#ASSIGN FILENAME. AND NO SPACES BETWEEN VARNAME and '=' SIGN; else Bash throws error.
totalfiles="`ls -l *.{jpg,png,PNG,JPG} | wc -l | tr -d '[[:space:]]'`"
totalfiles+=" Images"
echo "$totalfiles"
echo "$titlename-$totalfiles.html" ##this output shows leading spaces, donno why. So SED is used below.

filenamex=`echo "$titlename.html" | sed -e 's/ /-/g'`

#echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
#read imagesize
#imagesize+="px"; #Concatenating px at the end of the number

echo "<html><head><title>$filenamex</title>" > $filenamex

echo "<link href='https://fonts.googleapis.com/css?family=Raleway:400,700' rel='stylesheet'>
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
    font-family: 'Raleway', sans-serif;
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
  font-family: 'Raleway', sans-serif;
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
  font-family: 'Raleway', sans-serif;
	text-align: center;
	font-size: 16px;
  font-weight:700;
	line-height:1.3;
}


hr {clear:both;}
</style>" >> $filenamex

echo "</head><body>" >> $filenamex

echo "<h1>$titlename<br>(Total Image Files In This Folder (NON-RECURSIVE) = $totalfiles)</h1>" >> $filenamex

echo "<h3>Only JPG / jpg / PNG / png files are included below.<br>If you don't see your desired file below, try changing its extension to these.</h3>" >> $filenamex

for x in `ls *.{jpg,png,PNG,JPG} | sort -n -k1.$sortnumber`
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

#for x in `find . -type f | egrep -i '\.(jpg|png|PNG|JPG)$' | sort -n -k1.$sortnumber`
#  do
#  	echo "<div><a href='$x'><img src='$x' width='100%' align='top'></img><br><br>$x</a></div>" >> $filenamex
#  done;
##### OPTIONAL SECTION ENDS #####
############################################################


############################################################
#### OPTIONAL SECTION: Findind and listing Photoshop files ####
#totalcustomfiles="`find . -type f | egrep -i '\.(psd|ai|svg|eps|key|pages|numbers)$' | wc -l | tr -d '[[:space:]]'`"

#echo "<hr><br><h1>Downloadable Psd, Ai, Svg, Eps, Pages, Numbers, Keynote Files (RECURSIVE) = $totalcustomfiles</h1>" >> $filenamex

#for y in `find . -type f | egrep -i '\.(psd|ai|svg|eps|key|pages|numbers)$'`
#  do
#  	echo "<div class='colored'><a href='$y'>DOWNLOAD<br>$y</a></div>" >> $filenamex
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
