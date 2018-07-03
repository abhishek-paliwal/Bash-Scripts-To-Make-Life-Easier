#!/bin/bash
## THIS SCRIPT USES IMAGEMAGICK AND FFMPEG TO CREATE A VIDEO slideshow ...
## ... from STILL IMAGES USING CONFIGURABLE PARAMETERS
PWD=`pwd`;
cd $PWD ; ## CD to present working directory

TIME_PER_IMAGE=3.5 ##TIME IN SECONDS PER SLIDE
AUDIOFADE_DURATION=10 ##TIME IN SECONDS FOR AUDIOFADE DURATION AT END

OUTPUT_DIR="_delete_this_folder"
mkdir $OUTPUT_DIR

AUDIO_FILE="$HOME/Desktop/audio.mp3"
TMP_OUTPUT_VIDEO="video_slideshow.mp4"
OUTPUT_VIDEO_FINAL="video_slideshow_with_audiofade.mp4"

###########################################
## THIS BLOCK CREATES TEMPORARY SYMLINKS TO ALL IMAGES AND
## ADDS COUNTERS TO THEIR NAMES
x=1;
for i in *jpg;
    do
        counter=$(printf %03d $x);
        ln "$i" $OUTPUT_DIR/image"$counter".jpg;
        x=$(($x+1));
    done
###########################################

cd $OUTPUT_DIR
## Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "ImageMagick resizing to HD working ...."
mogrify -resize 1920x1080 -background black -gravity center -extent 1920x1080 *
echo "ImageMagick resizing done ...."

## FFMPEG command to convert images to slideshow video with audio (-r 1/3 means 3 seconds per image)
echo "First FFMPEG encoding work begins ...."
ffmpeg -f image2 -framerate 24 -r 1/$TIME_PER_IMAGE -i image%03d.jpg -i $AUDIO_FILE -shortest -video_size 1920x1080 -c:v libx264 $TMP_OUTPUT_VIDEO
echo "First FFMPEG work ends ...."

## PROBING the length of the audio and video file in seconds
ffprobe -i $TMP_OUTPUT_VIDEO -show_entries stream=codec_type,duration -of compact=p=0:nk=1 | grep -i 'audio|' | sed 's/audio|//g' > _tmp.txt

AUDIO_LENGTH=`cut -d '.' -f 1 _tmp.txt` ## Extracting the first part before dot
AUDIO_LENGTH_INTEGER=`printf '%d\n' "$AUDIO_LENGTH"` ## Converting to Integer
AUDIO_LENGTH_MINUS_FADE=$(($AUDIO_LENGTH_INTEGER-10)) ## Reducing 10 seconds from full length

FINAL_VIDEO_FILENAME="$AUDIO_LENGTH_INTEGER""-sec-""$OUTPUT_VIDEO_FINAL"

## RE-ENCODING USING FFMPEG WITH AUDIO FADE
echo "RE-ENCODING WITH AUDIO FADE: FFMPEG work begins ...."
ffmpeg -f image2 -framerate 24 -r 1/$TIME_PER_IMAGE -i image%03d.jpg -i $AUDIO_FILE -shortest -video_size 1920x1080 -af "afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION" -c:v libx264 $FINAL_VIDEO_FILENAME
echo "RE-ENCODING WITH AUDIO FADE: FFMPEG work ends ...."

## Moving VIDEO file to parent directory
mv $FINAL_VIDEO_FILENAME ../
echo "DONE: Moving FINAL VIDEO file to original parent directory ...."

## WRITING IMPORTANT VARIABLES TO TMP TEXT FILES
touch _tmp_variables.txt ## Create an empty tmp file
rm _tmp_variables.txt ## Delete if file exists

echo "
\n OUTPUT_DIR: $OUTPUT_DIR
\n AUDIO_FILE: $AUDIO_FILE
\n TMP_OUTPUT_VIDEO: $TMP_OUTPUT_VIDEO
\n OUTPUT_VIDEO_FINAL: $OUTPUT_VIDEO_FINAL
\n TIME_PER_IMAGE: $TIME_PER_IMAGE
\n AUDIO_LENGTH: $AUDIO_LENGTH
\n AUDIO_LENGTH_INTEGER: $AUDIO_LENGTH_INTEGER
\n AUDIOFADE_DURATION=: $AUDIOFADE_DURATION
\n AUDIO_LENGTH_MINUS_FADE: $AUDIO_LENGTH_MINUS_FADE
\n FINAL_VIDEO_FILENAME: $FINAL_VIDEO_FILENAME
" > _tmp_variables.txt

## CLEANING UP AND REMOVING UNNECESSARY FILES
rm $TMP_OUTPUT_VIDEO

## Opening PWD
open $PWD
