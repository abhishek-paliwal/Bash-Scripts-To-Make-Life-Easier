#!/bin/bash

################################################################################
## THIS PROGRAM DOWNLOADS THE AURORA IMAGE, THEN CALLS AN EXTERNAL PYTHON PROGRAM,
## WHICH CROPS IT AT CHOSEN COORDINATES,
## THEN OCR THE CROPPED IMAGE, THEN SENDS EMAIL WITH THE OCR TEXT RESULTS.
## NOTE: This program should only be run from digitalocean VPS because of hardcoded paths.
####
## DATE: 2024-09-02
## BY: PALI 
################################################################################

OUTDIR="/home/ubuntu/Desktop/Y" ; 
cd $OUTDIR ; 

URL_AURORA_IMAGE="https://cdn.fmi.fi/weather-observations/products/magnetic-disturbance-observations/map-latest-en.png" ; 
PROG_ROOTDIR="/home/GitHub/Bash-Scripts-To-Make-Life-Easier/9999-digitalocean-scripts/9993-digitalocean-aurora" ; 
PYTHON3_VENV_PATH="/home/GitHub/My-Pro-Python-Programs/my_python_virtual_environments/venv3/bin/python3" ; ## on digitalocean server
IMAGE_INPUT="$OUTDIR/9993-digitalocean-map-latest-en.png" ; 
IMAGE_CROPPED="$OUTDIR/9993-digitalocean-cropped_image_result.png" ; 
EMAIL_FROM="info@mygingergarlickitchen.com" ; 
EMAIL_TO="js3ump94@duck.com" ; 
TMPFILE="$OUTDIR/9993-tmpfile1.txt" ; 
TMPFILE_BASE="$OUTDIR/9993-tmpfile1" ; 

## image downloading
wget -O "$IMAGE_INPUT" "$URL_AURORA_IMAGE" ; 

## crop the image at following coordinates 
## x1, y1 = 0, 980
## x2, y2 = 742, 1143
/home/linuxbrew/.linuxbrew/bin/magick "$IMAGE_INPUT" -crop 742x163+0+980 "$IMAGE_CROPPED" ; 

## calling python program for cropping and ocr. Converting newlines to spaces
#$PYTHON3_VENV_PATH "$PROG_ROOTDIR/9993-02-digitalocean-crop-and-ocr-aurora-image.py" ;

## do the OCR in Finnish language
/home/linuxbrew/.linuxbrew/bin/tesseract "$IMAGE_CROPPED" "$TMPFILE_BASE" -l fin 

## create final message
myTextMessage=$(cat $TMPFILE | tr '\n' ' ') ; 

## sending email (use aws full path)
/home/linuxbrew/.linuxbrew/bin/aws ses send-email --from "$EMAIL_FROM" --to "$EMAIL_TO" --subject "$myTextMessage (AURORA) $(date)" --text "Aurora numbers / $myTextMessage" ;

## sending message to telegram bot
## get variable values from environment variables
curl -X POST -d "chat_id=${TELEGRAM_CHATID}" -d "text=${myTextMessage}" "https://api.telegram.org/bot${TELEGRAM_BOTTOKEN}/sendMessage"
