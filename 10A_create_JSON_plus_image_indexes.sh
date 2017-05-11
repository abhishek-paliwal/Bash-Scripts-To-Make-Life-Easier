#!/bin/bash
## BOOTSTRAP FRAMEWORK : THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY + RECURSIVELY
echo "#################" #Blank line
ROOT="$HOME/GitHub/abhishek-paliwal.github.io/wallpaper_creators/JSON-templates-for-design"
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

FINALFILENAME="Index-of-all-JSON-files.html"
OUTPUT="$ROOT/$FINALFILENAME" ##Output filename
#SITEURL="https://downloads.concepro.com/_BRAND-CONCEPRO/concepro-08-social/sharing/$FINALFILENAME"

##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<!DOCTYPE html>" > $OUTPUT ## FIRST OUTPUT LINE TO HTML FILE

echo "<html lang='en'><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>

    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <link rel='icon' href='https://downloads.concepro.com/favicon.ico'>

    <title>Library of JSON Templates // Concepro Agency</title>

    <!-- Bootstrap core CSS -->
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap.min.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/starter-template.css' rel='stylesheet'>
    <link href='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap-fullpage-cover.css' rel='stylesheet'>

    <link href='https://fonts.googleapis.com/css?family=Roboto:300,400,400i,700,900' rel='stylesheet'>

    <style>

/* PACKERY: 1 column layout*/
    .grid-item--width1 { width: 95%; border: 1px solid red ;}
    /* PACKERY: 2 columns layout*/
    .grid-item--width2 { width: 45%; border: 1px solid green ;}

    .grid-item {
        /* float:left; */
        width: 24% ;
        /* height: 220px ;  */
        /* padding: 5px; */
        /* margin: 0px; */
    }

    .grid {
      width: 96%; /* Can be anything, but has to be less than 100% */
      margin: 0 auto; /* Centers everything */
  }

  /* Pali: Using Media Queries for Display on Mobiles */
      @media (max-width: 567px) {
          .grid-item {
              width: 48% ;
          }
      }

      @media (min-width:568px) and (max-width:1199px) {
          .grid-item {
              width: 32% ;
          }
      }

.pali {
  margin: 15px;
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

/* PACKERY STYLES END */

body {
  background: rgba(245,245,245,1) ;
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
    background : linear-gradient(-45deg, hsla(300,100%, 50%, 1), hsla(10,100%, 50%, 1) ) ;
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

a.span {
    color: white ;
}

.p1 {background : linear-gradient(45deg, hsla(300,100%, 50%, 1), hsla(10,100%, 50%, 1) ) ; color: white ; text-transform: uppercase ; padding : 10px ; }

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
<h1 class='heading'>Library of All JSON Templates<br>&bull;&bull;&bull;&bull;&bull;</h1>

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

  echo "<div class='grid'> <!-- PACKERY MASONRY DIV BEGINS -->" >> $OUTPUT

  for x in `find "$filepath" -type f| sort | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$'`; do
    file=`basename "$x"`

    ## Finding the image dimensions using ImageMagick's identify command.
    imagedimen="`identify $ROOT/$path/$file | awk '{FS=" "; print "WxH= " $3 " - " $7 ;}'`";

    ## Finding the FileType for the current file.
    filetype="`file $ROOT/$path/$file | awk '{FS=" "; print $2}'`";
    echo $filetype " - " $ROOT/$path/$file "............DONE!";
    echo "IMAGE-DIMENSIONS - " $imagedimen "\n";


    file_without_extension=`echo ${file%.*}`
    file_without_extension+=".json"

## Printing the image dimensions for everything, except GIFs because they produce LOOOOONG outputs for all GIF frames. ##
    if [ "$filetype" != 'GIF' ]; then
      echo "<div class='grid-item'><div class='pali'><a href='$path/$file'><img src='$path/$file' width='100%'></img><span class='thin'>$file</span></a><br><span class='thin'>$imagedimen</span><br><br><strong style='background-color: #222; padding: 5px ; '><a style='color: white ;' href='$path/$file_without_extension'>Get JSON</a></strong></div></div>" >> $OUTPUT
    else
      echo "<div class='grid-item'><div class='pali'><a href='$path/$file'><img src='$path/$file' width='100%'></img><span class='thin'>$file</span></a><br><br><strong style='background-color: #222 ; padding: 5px ; '><a style='color: white ;' href='$path/$file_without_extension'>Get JSON</a></strong></div></div>" >> $OUTPUT
    fi

  done

  echo "</div> <!-- PACKERY MASONRY DIV ENDS -->" >> $OUTPUT

done

#### Calculations end ####
echo "<footer class='theEndFooter'><p>&copy; Concepro Digital Marketing Agency 2017</p></footer>" >> $OUTPUT

echo "</div><!-- Container DIV ENDS -->" >> $OUTPUT

echo "<!-- Bootstrap core JavaScript ================================ -->
<!-- Placed at the end of the document so the pages load faster -->
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/jquery-3.1.1.slim.min.js' crossorigin='anonymous'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js' crossorigin='anonymous'></script>
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/bootstrap-alpha6-js-css/bootstrap.min.js'></script>

<!-- PACKERY - MASONRY JQuery core files -->
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/js/PACKERY.pkgd.js'></script>
<script src='https://abhishek-paliwal.github.io/wallpaper_creators/js/IMAGESLOADED.pkgd.min.js'></script>


<script>
  \$(document).ready(function(){

        // init Packery
        var \$grid = \$('.grid').packery({
          // options...
            itemSelector: '.grid-item',
            gutter: 0
        });

        // layout Packery after each image loads
        \$grid.imagesLoaded().progress( function() {
          \$grid.packery();
        });

  });
</script>

<!-- THE END -->" >> $OUTPUT


echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## SM IMAGES Index Successfully created. ######### ";
echo "####### DONE! File will now be opened in SAFARI. ########"
open -a Safari $SITEURL
open -a Safari $OUTPUT
