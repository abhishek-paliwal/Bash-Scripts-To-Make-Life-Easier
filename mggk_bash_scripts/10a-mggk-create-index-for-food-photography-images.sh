#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## BOOTSTRAP FRAMEWORK : THIS SCRIPT CREATES AN HTML FILE WITH
  ## ALL THE IMAGES IN WORKING DIRECTORY + NON-RECURSIVELY -> FOR FOOD PHOTOGRAPHY
  ## IMAGES
  ###############################################################################
  ## Coded by: PALI
  ## On: JULY 29, 2020
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##################################################################################

echo ">> Now creating index for all food photography images." ;
say "Now creating index for all food photography images." ;

echo "#################################################" #Blank line

CURRENT_YEAR="$(date +%Y)"
CURRENT_MONTH="$(date +%m)"
DIRPATH="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/food-photography"
URL_PREFIX="https://www.mygingergarlickitchen.com/food-photography"

MAIN_IMAGES_FOLDER="$DIRPATH" 

#ROOT="$DIRPATH/$MAIN_IMAGES_FOLDER"
ROOT="$DIRPATH"

## Changing all image permissions to be viewed by whole world.
chmod -R 644 $ROOT/**

FINALFILENAME="food-photography.html"
OUTPUT="$DIRPATH/$FINALFILENAME" ##Output filename
SITEURL="https://www.MyGingerGarlicKitchen.com/food-photography/$FINALFILENAME"

#####################
cd $ROOT
echo "CURRENT WORKING DIRECTORY [ROOT]: " $ROOT ##check the present working directory
echo "#################################################" #Blank line


##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<!DOCTYPE html>" > $OUTPUT ## FIRST OUTPUT LINE TO HTML FILE

echo "<html lang='en'>
<head>

<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>

    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <link rel='icon' href='https://www.MyGingerGarlicKitchen.com/favicon.ico'>

    <title>Food Photography | My Ginger Garlic Kitchen</title>

    <!-- Bootstrap core CSS -->
    <link href='https://adoria.xyz/_static_code_files/bootstrap-alpha6-js-css/bootstrap.min.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='https://adoria.xyz/_static_code_files/bootstrap-alpha6-js-css/starter-template.css' rel='stylesheet'>
    <link href='https://adoria.xyz/_static_code_files/bootstrap-alpha6-js-css/bootstrap-fullpage-cover.css' rel='stylesheet'>

    <link href='https://fonts.googleapis.com/css?family=Roboto:300,400,400i,700,900' rel='stylesheet'>

    <style>

/* PACKERY: 1 column layout*/
    .grid-item--width1 { width: 95%; border: 1px solid red ;}
    /* PACKERY: 2 columns layout*/
    .grid-item--width2 { width: 45%; border: 1px solid green ;}

    .grid-item {
        width: 16% ;
    }

    .grid {
      width: 99%; /* Can be anything, but has to be less than 100% */
      margin: 0 auto; /* Centers everything */
  }

  .pali {
    margin: 10px;
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

  /* Pali: Using Media Queries for Display on Mobiles */
      @media (max-width: 567px) {
          .grid-item {
              width: 48% ;
          }
          .pali {
            margin: 5px ;
            border : 5px solid white ;
          }
      }

      @media (min-width:568px) and (max-width:1199px) {
          .grid-item {
              width: 32% ;
          }
          .pali {
            margin: 7px ;
            border : 7px solid white ;
          }
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
    /* This website Colored Background Gradient */
    /* background : linear-gradient(0deg, rgba(220,30,100,1.0), rgba(220,30,100,0.2) ) ; */
    border : 0px solid white ;
		box-shadow: 0px 0px 0px #999 ;
		border-radius : 0px ;
}

h1.heading {
   font-size: 80px ;
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

.p1 { background : linear-gradient(0deg, rgba(220,30,100,1.0), rgba(220,30,100,0.2) ) ; color: white ; text-transform: uppercase ; padding : 10px ; }

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body>" >> $OUTPUT

## ADDING PINTEREST PINIT BUTTON ON EVERY IMAGE
echo "<script async defer data-pin-hover='true' data-pin-tall='true' data-pin-lang='en' data-pin-save='true' src='https://assets.pinterest.com/js/pinit.js'></script>" >> $OUTPUT


echo "<nav class='navbar navbar-toggleable-md navbar-inverse bg-inverse fixed-top'>
  <a class='navbar-brand' href='https://www.MyGingerGarlicKitchen.com'>
  <img src='https://www.mygingergarlickitchen.com/logos/mggk-new-logo-transparent-1000px.svg' alt='My Ginger Garlic Kitchen' width='50px'>
  <span style='font-weight: 700; color: #F81894;'>My Ginger Garlic Kitchen</span> | Food Photography Images
  </a>
</nav>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Non-Recursively. ####
#totalimagefiles=$(find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]')
totalimagefiles=$(ls -1 $ROOT | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]')

echo "<div class='site-wrapper'>
<div class='site-wrapper-inner'>

<!-- HEADING DIV STARTS --> <div class='heading'>
<!-- TOP LOGO --> 
<a href='https://www.MyGingerGarlicKitchen.com' target='_blank'> <img src='https://www.mygingergarlickitchen.com/logos/mggk-new-logo-transparent-1000px.svg' alt='My Ginger Garlic Kitchen' width='120px'> </a>

<!--
<h1 class='heading'>FOOD PHOTOGRAPHY IMAGES <br>&bull;&bull;&bull;&bull;&bull;</h1>
<h2 class='heading'><font color='#FFFF00'>Designed by</font> <a href='https://www.MyGingerGarlicKitchen.com'><font color='#50c878'>My Ginger Garlic Kitchen</font></a></h2>
-->

<!-- HEADING DIV ENDS --> </div>

</div></div> <!-- site wrapper ends -->"  >> $OUTPUT


echo "<div class='container-fluid'>" >> $OUTPUT

echo "<h1>Food Photography Images</h1>" >> $OUTPUT
echo "<h3 class='thin'>Total Images On This Page (Non-Recursive) = $totalimagefiles</h3>" >> $OUTPUT
echo "<h3 class='thin'>Page last updated: "$(date)"</h3>" >> $OUTPUT

#echo "<h3 style='color: #cd1c62;'>&bull; &bull; &bull;<br> IMAGES ARE SORTED BY LATEST FIRST <br>&bull; &bull; &bull;</h3>" >> $OUTPUT
#echo "<hr>" >> $OUTPUT


#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 0 -mindepth 0 -type d| sort -nr`; do
  path=`basename "$filepath"`

  echo ">>> FILEPATH = $filepath" ;
  echo ">>> PATH = BASENAME(FILEPATH) = $path" ;
  echo;

  #echo " <h2 class='p1'> <a name='$path'>MONTH: $path</a> <a href='#' style='color: lime ;'>( &uarr; Go to top )</a></h2>" >> $OUTPUT

  ## UNCOMMENT THE FOLLOWING LINE IF YOU WANT PACKERY TYPE LOADING OF IMAGES
  #### AND INSTEAD OF USING <div class='col-6 col-sm-2'> FOR INDIVIDUAL IMAGES,
  #### USE THIS: <div class='grid-item'>
  ####
  #echo "<!-- PACKERY MASONRY DIV BEGINS --> <div class='grid'> " >> $OUTPUT
  ####
  ## COMMENT THE FOLLOWING LINE IF YOU ARE USING THE PACKERY STYLE ABOVE
  echo "<!-- MAIN BOOTSTRAP DIV ROW BEGINS --> <div class='row'> " >> $OUTPUT

  ## IN THE FOLLOWING, THE LS COMMAND SORTS BY LAST MODIFICATION DATE (latest first)
  for x in $( ls -1t "$filepath"/*.* | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' ) ; do
    file=`basename "$x"`

    ## Finding the image dimensions using ImageMagick's identify command.
    
    #imagedimen="`identify $DIRPATH/$path/$file | awk '{FS=" "; print "WxH= " $3 " - " $7 ;}'`";
    imagedimen="`identify $DIRPATH/$file | awk '{FS=" "; print "WxH= " $3 " - " $7 ;}'`";

    ## Finding the FileType for the current file.
    filetype="`file $DIRPATH/$file | awk '{FS=" "; print $2}'`";
    echo $filetype " - " $DIRPATH/$file "............DONE!";
    echo "IMAGE-DIMENSIONS - " $imagedimen "\n";


    file_without_extension=`echo ${file%.*}`
    file_without_extension+=".json"

## Printing the image dimensions for everything, except GIFs because they produce LOOOOONG outputs for all GIF frames. ##
    if [ "$filetype" != 'gif' ]; then
      echo "<div class='col-6 col-sm-4 col-md-3 col-lg-2'><div class='pali'><a href='$file'><img src='$file' width='100%'></img><span class='thin'>$file</span></a><br><span class='thin'>$imagedimen</span><br><br></div></div>" >> $OUTPUT
      #echo "<div class='col-6 col-sm-4 col-md-3 col-lg-2'><div class='pali'><a href='$file'><img src='$file' width='100%'></img></a></div></div>" >> $OUTPUT
    else
      echo "<div class='col-6 col-sm-4 col-md-3 col-lg-2'><div class='pali'><a href='$file'><img src='$file' width='100%'></img><span class='thin'>$file</span></a><br><br><strong style='background-color: #cd1d62 ; padding: 5px ; '><a style='color: white ;' href='$file'>Enlarge</a></strong></div></div>" >> $OUTPUT
    fi

  done

  echo "</div> <!-- PACKERY MASONRY DIV ENDS -->" >> $OUTPUT

done

#### Calculations end ####
echo "<footer class='theEndFooter'><p>&copy; My Ginger Garlic Kitchen 2020</p></footer>" >> $OUTPUT

echo "</div><!-- Container DIV ENDS -->" >> $OUTPUT

echo "<!-- Bootstrap core JavaScript ================================ -->
<!-- Placed at the end of the document so the pages load faster -->
<script src='https://adoria.xyz/_static_code_files/bootstrap-alpha6-js-css/jquery-3.1.1.slim.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js'></script>
<script src='https://adoria.xyz/_static_code_files/bootstrap-alpha6-js-css/bootstrap.min.js'></script>

<!-- PACKERY - MASONRY JQuery core files -->
<script src='https://adoria.xyz/_static_code_files/js/PACKERY.pkgd.js'></script>
<script src='https://adoria.xyz/_static_code_files/js/IMAGESLOADED.pkgd.min.js'></script>


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

echo "Final website URL => $SITEURL"
open -a Safari $OUTPUT
open -a Safari $SITEURL

## EXTRA message, just in case this script needs a password after successful run
echo ">> Food photography index file has been created." ;
say "Food photography index file has been created." ;
