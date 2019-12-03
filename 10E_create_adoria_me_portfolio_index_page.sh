#!/bin/bash
## BOOTSTRAP FRAMEWORK : THIS SCRIPT CREATES AN HTML FILE WITH...
## ...ALL THE IMAGES IN WORKING DIRECTORY + RECURSIVELY
echo "#################" #Blank line
DIRPATH="$HOME/Dropbox/Public/_TO_SYNC_adoria.me"
MAIN_IMAGES_FOLDER="drawings"
ROOT="$DIRPATH/$MAIN_IMAGES_FOLDER"

GTRACK_URL1="?utm_source=homepage&utm_medium=image_clicked"
GTRACK_URL2="?utm_source=homepage&utm_medium=enlarge_button_clicked"

cd $ROOT
echo "CURRENT WORKING DIRECTORY: " $ROOT ##check the present working directory
echo "#################" #Blank line

FINALFILENAME="index.html"
OUTPUT="$DIRPATH/$FINALFILENAME" ##Output filename
SITEURL="https://adoria.me/$FINALFILENAME"

##### UNCOMMENT the following three lines for custom image size #######
# echo -n "Enter the size of the DIV to use (300 works best) [ENTER]: "
# read imagesize
# imagesize+="px"; #Concatenating px at the end of the number

echo "<!DOCTYPE html>" > $OUTPUT ## FIRST OUTPUT LINE TO HTML FILE

echo "<html lang='en'>
<head>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src='https://www.googletagmanager.com/gtag/js?id=UA-48712319-9'></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-48712319-9');
</script>

<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>

    <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
    <link rel='icon' href='https://adoria.me/favicon.ico'>

    <title>Portfolio of Adoria's Drawings</title>

    <!-- Bootstrap core CSS -->
    <link href='./_static_code_files/bootstrap-alpha6-js-css/bootstrap.min.css' rel='stylesheet'>

    <!-- Custom styles for this template -->
    <link href='./_static_code_files/bootstrap-alpha6-js-css/starter-template.css' rel='stylesheet'>
    <link href='./_static_code_files/bootstrap-alpha6-js-css/bootstrap-fullpage-cover.css' rel='stylesheet'>

    <link href='https://fonts.googleapis.com/css?family=Roboto:300,400,400i,700,900' rel='stylesheet'>

    <style>

/* PACKERY: 1 column layout*/
    .grid-item--width1 { width: 95%; border: 1px solid red ;}
    /* PACKERY: 2 columns layout*/
    .grid-item--width2 { width: 45%; border: 1px solid green ;}

    .grid-item {
        /* float:left; */
        width: 25% ;
        /* height: 220px ;  */
        /* padding: 5px; */
        /* margin: 0px; */
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
    background : linear-gradient(235deg, rgba(255,255,100,0.7), rgba(255,0,0,0.7), rgba(0,0,255,0.7), rgba(100,255,255,0.7) ) ;
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

.p1 { background : linear-gradient(235deg, rgba(255,255,100,0.7), rgba(255,0,0,0.7), rgba(0,0,255,0.7), rgba(100,255,255,0.7) ) ; color: white ; text-transform: uppercase ; padding : 10px ; }

hr {clear:both;}
</style>" >> $OUTPUT

echo "</head><body>" >> $OUTPUT

echo "<nav class='navbar navbar-toggleable-md navbar-inverse bg-inverse fixed-top'>
  <a class='navbar-brand' href='https://adoria.me'>
  <img src='./drawings/0-logos/site-logo-transparent-1000px-lowres.png' style='width: 30px; '>
  <span style='font-weight: 700; color: #F81894;'>adoria</span> | a personal portfolio
  </a>
</nav>" >> $OUTPUT

#### OPTIONAL SECTION: Finding and listing all Image files Recursively. ####
totalimagefiles="`find $ROOT -type f | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$' | wc -l | tr -d '[[:space:]]'`"

echo "<div class='site-wrapper'>
<div class='site-wrapper-inner'>

<!-- HEADING DIV STARTS --> <div class='heading'>
<!-- TOP LOGO --> <img src='./drawings/0-logos/site-logo-transparent-1000px-lowres.png' style='width: 300px; '>
<h1 class='heading'>Personal Portfolio of Adoria's Drawings<br>&bull;&bull;&bull;&bull;&bull;</h1>

<h2 class='heading'><font color='#FFFF00'>Designed by</font> <a href='https://adoria.me'><font color='#50c878'>Adoria</font></a></h2>
<!-- HEADING DIV ENDS --> </div>

</div></div> <!-- site wrapper ends -->"  >> $OUTPUT


echo "<div class='container-fluid'>" >> $OUTPUT

echo "<h3 class='thin'>Total Images On This Page (Recursive) = $totalimagefiles</h3>" >> $OUTPUT
echo "<h3 class='thin'>Page last updated: "`date`"</h3>" >> $OUTPUT

##### CREATING THE HREF-NAME LINKS FOR ALL THE FOLDERS #####
echo "<hr>" >> $OUTPUT
echo "<div class='toc'>&bull; Table of Contents &bull;</div>" >> $OUTPUT

for foldername in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort -nr`; do
  folder=`basename "$foldername"`
  echo "<div class='toc'><a href='#$folder'> $folder</a></div> " >> $OUTPUT
done
#### Link Creation Ends #####

#### Calculations begin ####
x=0
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort -nr`; do
  path=`basename "$filepath"`
  echo " <hr> <h2 class='p1'> <a name='$path'>$path</a> <a href='#' style='color: lime ;'>( &uarr; Go to top )</a></h2>" >> $OUTPUT

  echo "<div class='grid'> <!-- PACKERY MASONRY DIV BEGINS -->" >> $OUTPUT

  for x in `find "$filepath" -type f| sort -nr | egrep -i '\.(jpg|png|PNG|JPG|gif|GIF)$'`; do
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
      echo "<div class='grid-item'><div class='pali'><a href='$MAIN_IMAGES_FOLDER/$path/$file$GTRACK_URL1'><img src='$MAIN_IMAGES_FOLDER/$path/$file' width='100%'></img><span class='thin'>$file</span></a><br><span class='thin'>$imagedimen</span><br><br><strong style='background-color: deeppink; padding: 5px ; '><a style='color: white ;' href='$MAIN_IMAGES_FOLDER/$path/$file$GTRACK_URL2'>Enlarge</a></strong></div></div>" >> $OUTPUT
    else
      echo "<div class='grid-item'><div class='pali'><a href='$MAIN_IMAGES_FOLDER/$path/$file$GTRACK_URL1'><img src='$MAIN_IMAGES_FOLDER/$path/$file' width='100%'></img><span class='thin'>$file</span></a><br><br><strong style='background-color: deeppink ; padding: 5px ; '><a style='color: white ;' href='$MAIN_IMAGES_FOLDER/$path/$file$GTRACK_URL2'>Enlarge</a></strong></div></div>" >> $OUTPUT
    fi

  done

  echo "</div> <!-- PACKERY MASONRY DIV ENDS -->" >> $OUTPUT

done

#### Calculations end ####
echo "<footer class='theEndFooter'><p>&copy; Adoria 2019</p></footer>" >> $OUTPUT

echo "</div><!-- Container DIV ENDS -->" >> $OUTPUT

echo "<!-- Bootstrap core JavaScript ================================ -->
<!-- Placed at the end of the document so the pages load faster -->
<script src='./_static_code_files/bootstrap-alpha6-js-css/jquery-3.1.1.slim.min.js'></script>
<script src='https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js'></script>
<script src='./_static_code_files/bootstrap-alpha6-js-css/bootstrap.min.js'></script>

<!-- PACKERY - MASONRY JQuery core files -->
<script src='./_static_code_files/js/PACKERY.pkgd.js'></script>
<script src='./_static_code_files/js/IMAGESLOADED.pkgd.min.js'></script>


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
open -a Safari $OUTPUT
open -a Safari $SITEURL

##------------------------------------------------------------------------------
## Getting all image names for creating wordcloud in python (through 603-mggk-script....sh)
WORDCLOUD_FILE="$DIRPATH/ADO_SITE_WORDCLOUD_for_using_with_603_mggk_script.csv"
echo "TITLE_TAG_VALUE" > $WORDCLOUD_FILE ## We need to have this line as the first line.
## The following command finds all files (case insensitive jpg, JPG, png, PNG)
basename $(find . -iname '*.png') | sed -e 's/-/ /g' -e 's/_/ /g' -e 's/\./ /g' >> $WORDCLOUD_FILE
basename $(find . -iname '*.jpg') | sed -e 's/-/ /g' -e 's/_/ /g' -e 's/\./ /g' >> $WORDCLOUD_FILE
echo; echo ">> THIS WORDCLOUD FILE CREATED (use it with 603-mggk-wordcloud...sh script) => $WORDCLOUD_FILE" ;
echo;
##------------------------------------------------------------------------------
