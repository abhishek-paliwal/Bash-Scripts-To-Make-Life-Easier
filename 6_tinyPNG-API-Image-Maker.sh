#!/bin/bash

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
#############################################################################
## Using tinyPNG/tinyJPG server API to create compressed images. AWESOME!!!
## Created by: Abhishek Paliwal on Thursday January 5, 2017
## STEPS: Open the Terminal. Go to desired directory. Run this bash script.
## Run as > /PATH/TO/FILE/sh _tinyPNG-Image-Maker.sh
#############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



## Getting tinyPNG API KEY: #####
## Reading a private CONFIG Key JSON file locally, through Python Version 2: ####
export PYTHONIOENCODING=utf8
API_KEY=`cat $HOME/Dropbox/_by_ABHISHEK/__palis_private_keys_and_configs/1_palis-personal-private-API-keys.json | python -c "import sys, json; print json.load(sys.stdin)['tinyPNG_API_key_apxapx']"`
##### PYTHON block ends ######

## DEFINING VARIABLES:
PWD=`pwd`
OUTPUT_FOLDER="_tinyPNG-API-output-folder";

## Show begins:
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
if [[ "$whichOption" == "" ]] ; then $whichOption = "1"; fi
#####

if [[ "$whichOption" == "2" ]] ; then
      echo "Enter OUTPUT_IMAGE_WIDTH in pixels; DEFAULT IS 800 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_WIDTH;
      if [[ "$OUTPUT_IMAGE_WIDTH" == "" ]] ; then  OUTPUT_IMAGE_WIDTH=800; fi

      echo "Enter OUTPUT_IMAGE_HEIGHT in pixels; DEFAULT IS 1200 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_HEIGHT;
      if [[ "$OUTPUT_IMAGE_HEIGHT" == "" ]] ; then  OUTPUT_IMAGE_HEIGHT=1200; fi

      echo "Output WIDTH X HEIGHT = $OUTPUT_IMAGE_WIDTH X $OUTPUT_IMAGE_HEIGHT "
      echo ""
fi

if [[ "$whichOption" == "3" ]] ; then
      echo "Enter OUTPUT_IMAGE_WIDTH/HEIGHT in pixels; DEFAULT IS 800 [simply press ENTER to use defaults]: ";
      read OUTPUT_IMAGE_DIMEN;
      if [[ "$OUTPUT_IMAGE_DIMEN" == "" ]] ; then  OUTPUT_IMAGE_DIMEN="800"; fi

      echo "Output WIDTH X HEIGHT = $OUTPUT_IMAGE_DIMEN X $OUTPUT_IMAGE_DIMEN "
      echo ""
fi


## Creating folder and removing any unnecessary/redundant files:
mkdir $OUTPUT_FOLDER
## Removing any existing TMP files.
rm $PWD/_tmp_TinyPNG*

## Now looping over all the image files ##
for i in `find . -maxdepth 1 -type f | sort | egrep -i '\.(jpg|png|PNG|JPG)$' | sed 's/\.\///g' `; do

      echo "------------> CURRENT FILE: $i <----------------"

      ## Uploading to tinyPNG server for compression
      curl https://api.tinify.com/shrink \
           --user api:$API_KEY \
           --data-binary @$i \
           --dump-header _tmp_TinyPNG0.txt

      ## Extracting the file URL from TEXT output
      ## Then, downloading from the so obtained URL to desired output folder
      cat _tmp_TinyPNG0.txt | grep -i 'Location' | sed 's/Location: //g' | tr -d '\r\n' > _tmp_TinyPNG1.txt

      ## Finally Downloading through CURL
      if [[ "$whichOption" == "1" ]] ; then
            ## COMPRESSING WITH ORIGINAL DIMENSIONS:
            curl `cat _tmp_TinyPNG1.txt` \
            --user api:$API_KEY \
            --output $OUTPUT_FOLDER/normalTiny_$i
            echo "=====>> Regular compression and download done."
      fi

      if [[ "$whichOption" == "2" ]] ; then
            ## RESIZING TO GIVEN DIMENSIONS:
            curl `cat _tmp_TinyPNG1.txt` \
            --user api:$API_KEY \
            --header "Content-Type: application/json" \
            --data '{ "resize": { "method": "cover", "width": '$OUTPUT_IMAGE_WIDTH', "height": '$OUTPUT_IMAGE_HEIGHT' } }' \
            --dump-header /dev/stdout --silent \
            --output $OUTPUT_FOLDER/resizedTiny_$i
            echo "=====>> Compression & resizing to dimensions - done."
      fi

      if [[ "$whichOption" == "3" ]] ; then
            ## SQUARE CROPPING
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
      echo "##########################################" >> _tmp_TinyPNG_final.txt
done

#############################################################################
## Opening the output directory through Finder
open $OUTPUT_FOLDER
