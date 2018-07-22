#!/bin/bash
## THIS SCRIPT USES IMAGEMAGICK AND FFMPEG TO CREATE A VIDEO slideshow ...
## ... from STILL IMAGES USING CONFIGURABLE PARAMETERS
## IMPORTANT NOTE: Make sure that all the images used by FFMPEG are PNGs, and not JPGs.
## TUTORIAL LINK: https://trac.ffmpeg.org/wiki/Slideshow#Colorspaceconversionandchromasub-sampling
###############################################
###############################################

PWD=`pwd`;
cd $PWD ; ## CD to present working directory

## RENAME ALL FILE NAMES TO LOWERCASE, BY RUNNING the following COMMAND
for f in * ; do mv -- "$f" "$(tr "[:upper:]" "[:lower:]" <<< "$f")" ; done ;
echo "=======> ALL FILENAMES + EXTENSIONS RENAMED TO LOWERCASE. <========== " ; echo ;

## Change the following directory to choose your own songs, per project basis
MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE+ROYALTY_FREE_MUSIC"

## THIS FILE HAS TO BE PRESENT FOR FIRST TMP VIDEO
DEMO_AUDIO_FILE="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/ffmpeg-commands/00_ffmpeg_demo_audio.mp3"

################################################
## Change these durations below as desired
TIME_PER_IMAGE=2.5 ##TIME IN SECONDS PER SLIDE
AUDIOFADE_DURATION=15 ##TIME IN SECONDS FOR AUDIO-FADE DURATION AT END
################################################

OUTPUT_DIR="_delete_this_folder"
mkdir $OUTPUT_DIR

TMP_OUTPUT_VIDEO="video_slideshow.mp4"
OUTPUT_VIDEO_FINAL="video_slideshow_with_audiofade.mp4"

###########################################
## THIS BLOCK CREATES TEMPORARY SYMLINKS TO ALL IMAGES AND
## ADDS COUNTERS TO THEIR NAMES
x=1;
for i in *jpg;
    do
        counter=$(printf %03d $x);
        # echo "Creating symlinks numerically ... $i" ;
        # ln "$i" $OUTPUT_DIR/image"$counter".jpg;
        echo "Copying + Renaming Image files numerically ... $i" ;
        cp "$i" $OUTPUT_DIR/image"$counter".jpg;
        x=$(($x+1));
    done
###########################################

cd $OUTPUT_DIR
## Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "=======> ImageMagick resizing to HD working ...."
mogrify -resize 1920x1080 -background black -gravity center -extent 1920x1080 *
echo "=======> ImageMagick resizing done ...."


## FORMAT CHANGE: This quickly converts all JPGs to PNGs, which then will be used by FFMPEG
echo "=======> Conversion from JPGs to PNGs begins ... " ;
mogrify -format png *.jpg ;

## SOME PNG transitions behave odd with ffmpeg (from grayscale frame to color frame and vice-versa).
## Hence, we are forcing all PNGs to be made up only of RGB pixes, and not grayscale pixels (so that it does not skip those frames in the final video)
for pic in *.png ;
    do
    ## By default, imagemagick makes PNGs with reduced sizes from grayscale JPGs
    ## Hence, we are converting all PNGs (grayscale or not) to intend that each pixel is made up of R,G,B colors, and not grayscale
    ## See more here: http://www.libpng.org/pub/png/spec/1.1/PNG-Chunks.html
    convert $pic -define png:color-type=2 $pic ;
    echo "Image converted to profile 2; $pic" ;
    done

echo "=======> Conversion from JPGs to PNGs ends ... " ;


## FFMPEG command to convert images to slideshow video with audio (-r 1/3 means 3 seconds per image)
echo "=======> First FFMPEG encoding work begins ...."
## OLD COMMAND
#ffmpeg -f image2 -framerate 24 -r 1/$TIME_PER_IMAGE -i image%03d.jpg -i $DEMO_AUDIO_FILE -shortest -video_size 1920x1080 -c:v libx264 -pix_fmt yuv420p $TMP_OUTPUT_VIDEO
## NEW COMMAND
ffmpeg -thread_queue_size 512 -framerate 1/$TIME_PER_IMAGE -i image%03d.png -s:v 1920x1080 -c:v libx264 -vf "fps=25,format=yuv420p" $TMP_OUTPUT_VIDEO

echo "=======> First FFMPEG work ends ...."

## PROBING the length of the audio and video file in seconds
ffprobe -i $TMP_OUTPUT_VIDEO -show_entries stream=codec_type,duration -of compact=p=0:nk=1 | grep -i 'video|' | sed 's/video|//g' > _tmp.txt

AUDIO_LENGTH=`cut -d '.' -f 1 _tmp.txt` ## Extracting the first part before dot
AUDIO_LENGTH_INTEGER=`printf '%d\n' "$AUDIO_LENGTH"` ## Converting to Integer
AUDIO_LENGTH_MINUS_FADE=$(($AUDIO_LENGTH_INTEGER-$AUDIOFADE_DURATION)) ## Reducing FADE seconds from full length

FINAL_VIDEO_FILENAME="$AUDIO_LENGTH_INTEGER""-sec-""$OUTPUT_VIDEO_FINAL"

#############################################################################
## Choose a random audio file which has a duration longer than the video itself
## First, run the script to sort the audio files based on duration
## this will create a tmp txt file. That file will be used below with gshuf
sh $HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/ffmpeg-commands/201_sorting_mp3_files_by_duration.sh "$AUDIO_LENGTH_INTEGER" "$MY_SONG_DIR"
AUDIO_FILE=`gshuf -n 1 $MY_SONG_DIR/_tmp_chosen_sorted.txt`
echo; echo "(REAL) Chosen random file: "$AUDIO_FILE ; echo ;
#############################################################################

## RE-ENCODING USING FFMPEG WITH AUDIO FADE
echo "=======> RE-ENCODING WITH AUDIO FADE: FFMPEG work begins ...."
## OLD COMMAND
#ffmpeg -f image2 -framerate 24 -r 1/$TIME_PER_IMAGE -i image%03d.jpg -i $MY_SONG_DIR/$AUDIO_FILE -shortest -video_size 1920x1080 -af "afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION" -c:v libx264 -pix_fmt yuv420p $FINAL_VIDEO_FILENAME
## NEW COMMAND
ffmpeg -thread_queue_size 512 -framerate 1/$TIME_PER_IMAGE -i image%03d.png -i $MY_SONG_DIR/$AUDIO_FILE -shortest -s:v 1920x1080 -af "afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION" -c:v libx264 -vf "fps=25,format=yuv420p" $FINAL_VIDEO_FILENAME

echo "=======> RE-ENCODING WITH AUDIO FADE: FFMPEG work ends ...."

## Moving VIDEO file to parent directory
mv $FINAL_VIDEO_FILENAME ../
echo "=======> DONE: Moving FINAL VIDEO file to original parent directory ...."

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
#rm $TMP_OUTPUT_VIDEO

## ECHO if there's blank video at the ends
echo "=====================================================" ;
echo "=====================================================" ;
echo "IMPORTANT NOTE: If the resulting video is blank slides (meaning all black) with music, try compressing the image files using IMAGEOPTIM, and also optionally change the image file permissions to chmod 777. Additionally make sure that the images used are in PNG format. Else, convert them from JPGs to PNGs." ;
echo "=====================================================" ;
echo "=====================================================" ;

## Opening PWD
open -j $PWD
