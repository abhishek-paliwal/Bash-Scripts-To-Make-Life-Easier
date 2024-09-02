#!/bin/bash

################################################################################
## THIS PROGRAM DOWNLOADS THE AURORA IMAGE, THEN CALLS AN EXTERNAL PYTHON PROGRAM,
## WHICH CROPS IT AT CHOSEN COORDINATES,
## THEN OCR THE CROPPED IMAGE, THEN SENDS EMAIL WITH THE OCR TEXT RESULTS.
## DATE: 2024-09-02
## BY: PALI 
################################################################################

URL_AURORA_IMAGE="https://cdn.fmi.fi/weather-observations/products/magnetic-disturbance-observations/map-latest-en.png" ; 
PROG_ROOTDIR="$REPO_SCRIPTS/9999-digitalocean-scripts/9993-digitalocean-aurora" ; 
PYTHON3_VENV_PATH="/Users/abhishek/GitHub/My-Pro-Python-Programs/my_python_virtual_environments/venv3/bin/python3" ; 
OUTDIR="$DIR_Y" ; 
IMAGE_INPUT="$OUTDIR/9993-digitalocean-map-latest-en.png" ; 
IMAGE_CROPPED="$OUTDIR/9993-digitalocean-cropped_image_result.png" ; 
EMAIL_FROM="info@mygingergarlickitchen.com" ; 
EMAIL_TO="js3ump94@duck.com" ; 

TMPFILE="$OUTDIR/_tmpfile1.txt" ; 

## image downloading
wget -O "$IMAGE_INPUT" "$URL_AURORA_IMAGE" ; 

## calling python program for cropping and ocr. Converting newlines to spaces
$PYTHON3_VENV_PATH "$PROG_ROOTDIR/9993-02-digitalocean-crop-and-ocr-aurora-image.py" "$IMAGE_INPUT" "$IMAGE_CROPPED" | tr '\n'  ' ' > $TMPFILE ; 

## sending email
aws ses send-email --from "$EMAIL_FROM" --to "$EMAIL_TO" --subject "AURORA - $(cat $TMPFILE) // $(date)" --text "Aurora numbers // $(cat $TMPFILE)" ;
