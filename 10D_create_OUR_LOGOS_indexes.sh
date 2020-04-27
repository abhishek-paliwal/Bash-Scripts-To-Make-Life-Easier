#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
## BOOTSTRAP FRAMEWORK : THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY + RECUSRSIVELY
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo "#################" #Blank line
ROOT="$HOME_WINDOWS/Dropbox/Public/_TO_SYNC_downloads.concepro.com/dropbox-public-files/logos"
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

FINALFILENAME="all-logos-index.html"
OUTPUT="$ROOT/$FINALFILENAME" ##Output filename
SITEURL="https://downloads.concepro.com/dropbox-public-files/logos/$FINALFILENAME"

##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<!DOCTYPE html>" > $OUTPUT ## FIRST OUTPUT LINE TO HTML FILE

echo "<html lang='en'><head>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src='https://www.googletagmanager.com/gtag/js?id=UA-48712319-6'></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-48712319-6');
</script>

<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>

    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <link rel='icon' href='https://downloads.concepro.com/favicon.ico'>

    <title>Index of All Our Logos // Concepro Agency</title>

    <!-- Bootstrap core CSS -->
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap.min.css' rel='stylesheet'>
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap-fullpage-cover.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/starter-template.css' rel='stylesheet'>


<style>

body {
  background-color: rgb(245,245,245) ;
}

.pali {
    height: 100%;
    padding: 5px;
    margin-bottom : 20px;
    text-align: left;
    background-color: white ;
    border : 1px solid white ;
		box-shadow: 0px 0px 5px #999 ;
		border-radius : 1px ;
    color : #999 ;
}

div.heading {
    display: block ;
    width: 100% ;
    padding: 20px;
    margin: 0px;
    margin-bottom : 20px ;
    height: auto;
    text-align: center;
    color : white;
    /* Concepro Colored Background Gradient */
    background : linear-gradient(180deg, rgba(255,255,100,0.7), rgba(255,0,0,0.7), rgba(0,0,255,0.7), rgba(100,255,255,0.7) ) ;
    border : 0px solid white ;
		box-shadow: 0px 0px 0px #999 ;
		border-radius : 0px ;
}

h1.heading {
   font-size: 100px ;
   font-weight: 900 ;
   letter-spacing: 5px ;
   line-height: 0.9 ;
   text-transform: uppercase ;
}

/* Using Media Queries for h1.heading Display on Mobiles */
      @media (max-width: 567px) {
          h1.heading {
              font-size: 60px;
              letter-spacing: 2px ;
              line-height: 1.0 ;
              text-transform: capitalize ;
          }
      }

h2.heading {
  font-weight: 100;
  font-size: 40px;
}

h1,h2,h3,h4,h5,h6 {
  text-align : center;
}

hr {
  width: 200px ;
  height: 10px ;
  border: 0px ;
  background-color: black ;
}

.thin {
  font-size: 0.8em ;
}

.toc {
  text-align: center ;
  font-size: 1.2em ;
  font-weight: 900 ;
}

.theEndFooter {
  padding: 10px ;
  background-color: #444;
  color: white;
  text-align: center ;
}

.p1 {background : linear-gradient(270deg, rgba(255,255,100,0.7), rgba(255,0,0,0.7), rgba(0,0,255,0.7), rgba(100,255,255,0.7) ) ; color: white ; text-transform: uppercase ; padding : 10px ; }

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body>" >> $OUTPUT

echo "<nav class='navbar navbar-toggleable-md navbar-inverse bg-inverse fixed-top'>
  <a class='navbar-brand' href='http://www.concepro.com'><span style='font-weight: 700; color: #3498db;'>concepro</span> | a digital marketing agency</a>
</nav>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]'`"

echo "<div class='site-wrapper'>
<div class='site-wrapper-inner'>

<!-- HEADING DIV STARTS --> <div class='heading'>
<!-- TOP LOGO --> <img src='https://downloads.concepro.com/dropbox-public-files/logos/4-logos-concepro/Concepro-Shadow.png' style='width: 300px; '>
<h1 class='heading'>Index of All Our Logos<br>&bull;&bull;&bull;&bull;&bull;</h1>

<h2 class='heading'>Designed by <a href='http://www.AnupamaPaliwal.com'>Anupama Paliwal</a> for <a href='http://www.concepro.com'>Concepro Digital Marketing Agency</a></h2>
<!-- HEADING DIV ENDS --> </div>

</div></div> <!-- site wrapper ends -->"  >> $OUTPUT


echo "<div class='container-fluid'>" >> $OUTPUT

echo "<h3 class='thin'>Total Images On This Page (Recursive) = $totalimagefiles</h3>" >> $OUTPUT
echo "<h3 class='thin'>Page last updated: "`date`"</h3>" >> $OUTPUT

##### CREATING THE HREF-NAME LINKS FOR ALL THE FOLDERS #####
echo "<hr>" >> $OUTPUT
echo "<div class='toc'>&bull; Table of Contents &bull;</div>" >> $OUTPUT

for foldername in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  folder=`basename "$foldername"`
  echo "<div class='toc'><a href='#$folder'> $folder</a></div> " >> $OUTPUT
done
#### Link Creation Ends #####

#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo " <hr> <h2 class='p1'> <a name='$path'>$path</a> <a href='#'>( &uarr; Back to top )</a></h2>" >> $OUTPUT

  echo "<div class='row'> <!-- ROW BEGINS --> " >> $OUTPUT

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
      echo "<div class='col-6 col-xs-6 col-sm-4 col-md-3 col-lg-2 col-xl-2'>" >> $OUTPUT
      echo "<div class='pali'><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%'></img><span class='thin'>$file</a></span><br><span class='thin'>$imagedimen</span></div>" >> $OUTPUT
      echo "</div>" >> $OUTPUT
    else
      echo "<div class='col-6 col-xs-6 col-sm-4 col-md-3 col-lg-2 col-xl-2'>" >> $OUTPUT
      echo "<div class='pali'><a href='$path/$file'><img class='lazy' data-src='$path/$file' width='100%'></img><span class='thin'>$file</span></a></div>" >> $OUTPUT
      echo "</div>" >> $OUTPUT
    fi

  done

  echo "</div> <!-- ROW DIV ENDS --> " >> $OUTPUT

done

#### Calculations end ####
echo "<footer class='theEndFooter'><p>&copy; Concepro Digital Marketing Agency 2017</p></footer>" >> $OUTPUT

echo "</div><!-- Container DIV ENDS -->" >> $OUTPUT

echo "<!-- Bootstrap core JavaScript ================================ -->
<!-- Placed at the end of the document so the pages load faster -->
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/jquery-3.1.1.slim.min.js' crossorigin='anonymous'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js' crossorigin='anonymous'></script>
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap.min.js'></script>

<!-- LAZY-LOADER OF IMAGES -  JQUERY Plugin -->
<script type='text/javascript' src='https://abhishek-paliwal.github.io/wallpaper_creators/js/JQUERY.LAZY.MIN.js'></script>

<script>
  \$(document).ready(function(){
          // ENABLING LAZY LOADING
          \$('.lazy').Lazy();
  });
</script>" >> $OUTPUT


echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## SM IMAGES Index Successfully created. ######### ";
echo "####### DONE! File will now be opened in SAFARI. ########"
open -a Safari $SITEURL
open -a Safari $OUTPUT
