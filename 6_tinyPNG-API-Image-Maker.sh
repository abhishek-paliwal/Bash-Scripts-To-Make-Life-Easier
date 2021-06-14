#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
#############################################################################
## Using tinyPNG/tinyJPG server API to create compressed images. AWESOME!!!
## Created by: Pali
## Created on: Thursday January 5, 2017
#########################################
## STEPS:
## >> Open the Terminal. Go to desired directory. Run this bash script.
## >> Run on CLI as > bash $0
#############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## Getting tinyPNG API KEY: #####
## Reading the private CONFIG Key locally ####
echo; echo ">> Getting tinyPNG API KEY: PARSING API KEY ..." ;
API_KEY="$API_KEY_TINYPNG" ; ## taken from env variable
echo ">> API KEY PARSED AS => $API_KEY" ;

## DEFINING VARIABLES:
PWD=$(pwd);
OUTPUT_FOLDER="_tinyPNG-API-output-folder";

## Show begins:
echo; 
echo "-->> What do you want to do, choose option #:
      ==================
      1 = NORMAL Compression (output as original dimesions). THIS IS DEFAULT.
      2 = RESIZING & compression (to desired dimensions)
      3 = SQUARE Automatic Cropping with Compression
      =================="

echo "Enter your choice = 1, 2, or 3: ";
read whichOption;
echo "==================";

##### Setting Defaults
if [ "$whichOption" == "" ] ; then whichOption = "1"; fi
#####

if [ "$whichOption" == "2" ] ; then
      echo "Enter OUTPUT_IMAGE_WIDTH in pixels; DEFAULT IS 800 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_WIDTH;
      if [ "$OUTPUT_IMAGE_WIDTH" == "" ] ; then  OUTPUT_IMAGE_WIDTH=800; fi

      echo "Enter OUTPUT_IMAGE_HEIGHT in pixels; DEFAULT IS 1200 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_HEIGHT;
      if [ "$OUTPUT_IMAGE_HEIGHT" == "" ] ; then  OUTPUT_IMAGE_HEIGHT=1200; fi

      echo "Output WIDTH X HEIGHT = $OUTPUT_IMAGE_WIDTH X $OUTPUT_IMAGE_HEIGHT " ;
      echo "" ;
fi

if [ "$whichOption" == "3" ] ; then
      echo "Enter OUTPUT_IMAGE_WIDTH/HEIGHT in pixels; DEFAULT IS 800 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_DIMEN;
      if [ "$OUTPUT_IMAGE_DIMEN" == "" ] ; then  OUTPUT_IMAGE_DIMEN="800"; fi

      echo "Output WIDTH X HEIGHT = $OUTPUT_IMAGE_DIMEN X $OUTPUT_IMAGE_DIMEN "
      echo ""
fi


## Creating folder and removing any unnecessary/redundant files:
mkdir $OUTPUT_FOLDER
## Removing any existing TMP files.
rm $PWD/_tmp_TinyPNG*

## Now looping over all the image files ##
echo; echo "## Now looping over all the image files ##" ;
for i in `find . -maxdepth 1 -type f | sort | egrep -i '\.(jpg|png|PNG|JPG)$' | sed 's/\.\///g' `; do

      echo; echo "------------> CURRENT FILE: $i <----------------"

      ## Uploading to tinyPNG server for compression
      echo ">> Uploading to tinyPNG server for compression ..." ;
      curl https://api.tinify.com/shrink \
           --user api:$API_KEY \
           --data-binary @$i \
           --dump-header _tmp_TinyPNG0.txt

      echo ">> Uploading done..." ;

      ## Extracting the file URL from TEXT output
      ## Then, downloading from the so obtained URL to desired output folder
      
      cat _tmp_TinyPNG0.txt | grep -i 'location' | sed 's/location: //ig' | tr -d '\r\n' > _tmp_TinyPNG1.txt

      ## Finally Downloading through CURL
      if [ "$whichOption" == "1" ] ; then
            ## COMPRESSING WITH ORIGINAL DIMENSIONS:
            echo ">> COMPRESSING WITH ORIGINAL DIMENSIONS and downloading via curl command ..." ;
            curl `cat _tmp_TinyPNG1.txt` \
            --user api:$API_KEY \
            --output $OUTPUT_FOLDER/normalTiny_$i
            echo "=====>> Regular compression and download done."
      fi

      if [ "$whichOption" == "2" ] ; then
            ## RESIZING TO GIVEN DIMENSIONS:
            echo; 
            echo ">> RESIZING TO GIVEN DIMENSIONS [ $OUTPUT_IMAGE_WIDTH x $OUTPUT_IMAGE_HEIGHT ] and downloading via curl command ..." ;

            MYCOMMAND="curl '$(cat _tmp_TinyPNG1.txt|head -1)' --user api:$API_KEY --header \"Content-Type: application/json\" --data '{ \"resize\": { \"method\": \"cover\", \"width\": $OUTPUT_IMAGE_WIDTH, \"height\": $OUTPUT_IMAGE_HEIGHT } }' --dump-header /dev/stdout --silent --output $OUTPUT_FOLDER/resizedTiny_$i " ;

            echo ">> Running this command => " ;
            echo "$MYCOMMAND" ;
            eval "${MYCOMMAND}" ;      

            echo "=====>> Compression & resizing to dimensions - done."
      fi

      if [ "$whichOption" == "3" ] ; then
            ## SQUARE CROPPING
            echo ">> SQUARE CROPPING and downloading via curl command ..." ;
             curl `cat _tmp_TinyPNG1.txt` \
              --user api:$API_KEY \
              --header "Content-Type: application/json" \
              --data '{ "resize": { "method": "cover", "width": '$OUTPUT_IMAGE_DIMEN', "height": '$OUTPUT_IMAGE_DIMEN' } }' \
              --dump-header /dev/stdout --silent \
              --output $OUTPUT_FOLDER/squaredTiny_$i
              echo "=====>> Square compression & cropping - done."
      fi

      ###############################################################################
      ## Printing all the outputs to a log file for final error checking manually. ##
      echo "===================" >> _tmp_TinyPNG_final.txt
      ls $i  >> _tmp_TinyPNG_final.txt
      echo "===================" >> _tmp_TinyPNG_final.txt
      cat _tmp_TinyPNG0.txt _tmp_TinyPNG1.txt >> _tmp_TinyPNG_final.txt
      echo >> _tmp_TinyPNG_final.txt ;
      echo "##########################################" >> _tmp_TinyPNG_final.txt
done

#############################################################################
## Opening the output directory through Finder on Mac.
if [ "$(uname)" == "Darwin" ] ; then
      open $OUTPUT_FOLDER ; 
else
      echo "Output has been saved in: $OUTPUT_FOLDER" ;
fi
