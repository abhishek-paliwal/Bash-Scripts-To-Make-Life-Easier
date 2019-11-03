#!/bin/bash
## THIS SCRIPT USES IMAGEMAGICK AND FFMPEG TO CREATE A VIDEO slideshow ...
## ... from STILL IMAGES USING CONFIGURABLE PARAMETERS
## IMPORTANT NOTE: Make sure that all the images used by FFMPEG are PNGs, and not JPGs.
## TUTORIAL LINK: https://trac.ffmpeg.org/wiki/Slideshow#Colorspaceconversionandchromasub-sampling
###############################################
###############################################

PWD=`pwd`;
cd $PWD ; ## CD to present working directory

######################################################################
## Check if PWD is not $HOME . Only then, it will run.
if [ "$PWD" == "$HOME" ];
then
    echo "PWD is $PWD . Thus, this script will not run in this directory. " ;
    exit 1 ;
fi
######################################################################

## RENAME ALL FILE NAMES TO LOWERCASE, BY RUNNING the following COMMAND
for f in * ; do mv -- "$f" "$(tr "[:upper:]" "[:lower:]" <<< "$f")" ; done ;
echo "=======> ALL FILENAMES + EXTENSIONS RENAMED TO LOWERCASE. <========== " ; echo ;

## Change the following directory to choose your own songs, per project basis

#MY_SONG_DIR="$HOME/Desktop/_TMP_SONGS_" ;
#MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE_MUSIC/bollywood-music"
#MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE_MUSIC/royalty-free-music"

echo "Select the Song directory =======>
a) Desktop/_TMP_SONGS_
b) bollywood-music
c) royalty-free-music
d) mggk-royalty-free-music-from-youtube
" ;

echo "Enter your choice (a/b/c/d): " ;
read song_dir

case $song_dir in
    a) MY_SONG_DIR="$HOME/Desktop/_TMP_SONGS_" ;;
    b) MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE_MUSIC/bollywood-music" ;;
    c) MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE_MUSIC/royalty-free-music" ;;
    c) MY_SONG_DIR="$HOME/Dropbox/__MGGK-Dropbox-Files/mggk-dropbox-09-video/Royalty_Free_Music/_AUDIOJUNGLE_MUSIC/mggk-royalty-free-music-from-youtube" ;;
    *) echo "Invalid option $song_dir" ;;
esac

echo "Chosen MY_SONG_DIR is: $MY_SONG_DIR " ; echo;

## THIS FILE HAS TO BE PRESENT FOR FIRST TMP VIDEO
DEMO_AUDIO_FILE="$HOME/GitHub/Bash-Scripts-To-Make-Life-Easier/ffmpeg-commands/00_ffmpeg_demo_audio.mp3"

## NOW PRINTING THE DIMENSIONS OF ALL IMAGES WITH HOW MANY IMAGES THEY CORRESPOND
echo; echo "Now printing the dimensions of all images with how many images they correspond to: ";
identify -format "%wx%h\n" *.* | sort -n > _TMP_LIST.TXT ;
cat _TMP_LIST.TXT | sort -n | uniq -c | sort -k2nr ;

################################################
## Change these durations below as desired
TIME_PER_IMAGE=2.5 ##TIME IN SECONDS PER SLIDE
AUDIOFADE_DURATION=15 ##TIME IN SECONDS FOR AUDIO-FADE DURATION AT END
################################################

################################################
## CHOOSING THE VIDEO RESOLUTION FROM OPTIONS
echo "Select the Video Resolution =======>
1) 3840x2160
2) 2560x1440
3) 1920x1200
4) 1920x1080
5) 1280x720
6) 800x600
7) 640x480
" ;

echo "Enter your VIDEO RESOLUTION choice (as option number): " ;
read v_resolution

case $v_resolution in
    1) VIDEO_RES="3840x2160" ;; ## 16:9
    2) VIDEO_RES="2560x1440" ;; ## 16:9
    3) VIDEO_RES="1920x1200" ;; ## 16:10
    4) VIDEO_RES="1920x1080" ;; ## 16:9 Full HD
    5) VIDEO_RES="1280x720" ;; ## 16:9 HD
    6) VIDEO_RES="800x600" ;; ## 4:3
    7) VIDEO_RES="640x480" ;; ## 4:3 VGA
    *) echo "Invalid option $v_resolution" ;;
esac

echo "Chosen VIDEO_RES is: $VIDEO_RES " ; echo;
################################################

OUTPUT_DIR="_delete_this_folder"
mkdir $OUTPUT_DIR

TMP_OUTPUT_VIDEO="video_slideshow.mp4"
OUTPUT_VIDEO_FINAL="video_slideshow_with_audiofade.mp4"

###########################################
## NOW, WE'LL DUPLICATE THE FIRST IMAGE, AND THEN CREATE A COVER IMAGE FROM IT
## DUPLICATION (COPYING ONLY THE FIRST FILE, THEN BREAK THE LOOP):
COVER_IMAGE="0_cover_tmp.jpg" ;
NEW_COVER_IMAGE="0_cover_final.jpg" ;

for f in *.jpg ; do cp "$f" $COVER_IMAGE ; break ; done

# resizing the cover image to full HD
mogrify -resize $VIDEO_RES -background black -gravity center -extent $VIDEO_RES $COVER_IMAGE ;

## CREATING COVER IMAGE FROM THAT DUPLICATED IMAGE:
## first, finding the width of the image for text writing
width=`identify -format %w $COVER_IMAGE`;

## finding the number of jpg files in PWD
NUM_FILES=`ls -1 *.jpg | wc -l | sed 's/ //g'` ;
LENGTH_OF_SLIDESHOW=`echo "scale=0; ($TIME_PER_IMAGE * $NUM_FILES)/1" | bc -l` ; ## scale=2 means how many digits after decimal, for bc -l calculations

## Converting to Integer, then to minutes and seconds
LENGTH_OF_SLIDESHOW=`printf '%d\n' "$LENGTH_OF_SLIDESHOW"` ;
LENGTH_OF_SLIDESHOW_IN_MINUTES=`printf '%02dm-%02ds\n' $(($LENGTH_OF_SLIDESHOW/60)) $(($LENGTH_OF_SLIDESHOW%60))`

echo "LENGTH_OF_SLIDESHOW : $LENGTH_OF_SLIDESHOW " ;

tmp_varname=${PWD##*/} ;
BASENAME_FOLDER=`echo $tmp_varname | sed 's/\ /-/g' | sed 's/-/ /g' | sed 's/_/ /g' ` ;


## collecting all variables to a final caption
FULL_COVER_TEXT="$BASENAME_FOLDER\n$NUM_FILES photos // $LENGTH_OF_SLIDESHOW_IN_MINUTES // $VIDEO_RES" ;
echo "FULL COVER TEXT: $FULL_COVER_TEXT" ;

## now writing text onto the image using imagemagick composite
## get list of font names by running: convert -list font | grep "Font:"
convert -background '#00000085' -fill white -font /Users/abhishek/Library/Fonts/BebasNeue\ Regular.ttf -gravity center -size ${width}x360 caption:"$FULL_COVER_TEXT" $COVER_IMAGE +swap -gravity south -composite $NEW_COVER_IMAGE ;

echo "========> DONE: TEXT WRITTEN TO COVER IMAGE." ;
rm $COVER_IMAGE ; #delete old and unnecessary cover image tmp file#

###############################################################
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
################################################################

cd $OUTPUT_DIR
## Using IMAGEMAGICK to resize ALL images to Full-HD with padding to keep FULL-HD aspect ratio
echo "=======> ImageMagick resizing to $VIDEO_RES working ...."
mogrify -resize $VIDEO_RES -background black -gravity center -extent $VIDEO_RES *
echo "=======> ImageMagick resizing done ...."


## FORMAT CHANGE: This quickly converts all JPGs to PNGs, which then will be used by FFMPEG
echo "=======> Conversion from JPGs to PNGs begins ... " ;
mogrify -format png *.jpg ;
echo "=======> Conversion from JPGs to PNGs ends ... " ;

##################################################
## SOME PNG transitions behave odd with ffmpeg (from grayscale frame to color frame and vice-versa).
## Hence, we are forcing all PNGs to be made up only of RGB pixes, and not grayscale pixels (so that it does not skip those frames in the final video)
for pic in *.png ;
    do
    ## By default, imagemagick makes PNGs with reduced sizes from grayscale JPGs
    ## Hence, we are converting all PNGs (grayscale or not) to intend that each pixel is made up of R,G,B colors, and not grayscale
    ## See more here: http://www.libpng.org/pub/png/spec/1.1/PNG-Chunks.html

    ## Writing filename to the bottom-right of each PNG image
    PICNAME=`echo "$pic" | cut -d '.' -f1` ; ## removing file extension

    convert $pic -fill white -undercolor '#111111' -pointsize 16 -gravity Southeast -annotate +0+5 "\  $PICNAME " $pic
    echo "PNG Image file stamped with file-name-number: $pic" ;

    convert $pic -define png:color-type=2 $pic ;
    echo "PNG Image converted to profile 2: $pic" ;
    done

echo "=======> Conversion from JPGs to PNGs ends ... " ;
#################################################

## FFMPEG command to convert images to slideshow video with audio (-r 1/3 means 3 seconds per image)
echo "=======> First FFMPEG encoding work begins ...."
## NEW COMMAND
#ffmpeg -thread_queue_size 512 -framerate 1/$TIME_PER_IMAGE -i image%03d.png -s:v $VIDEO_RES -c:v libx264 -vf "fps=25,format=yuv420p" $TMP_OUTPUT_VIDEO

echo "=======> First FFMPEG work ends ...."

## PROBING the length of the audio and video file in seconds
#ffprobe -i $TMP_OUTPUT_VIDEO -show_entries stream=codec_type,duration -of compact=p=0:nk=1 | grep -i 'video|' | sed 's/video|//g' > _tmp.txt

#AUDIO_LENGTH=`cut -d '.' -f 1 _tmp.txt` ## Extracting the first part before dot
AUDIO_LENGTH=$LENGTH_OF_SLIDESHOW ;
AUDIO_LENGTH_INTEGER=`printf '%d\n' "$AUDIO_LENGTH"` ## Converting to Integer

AUDIO_LENGTH_MINUS_FADE=$(($AUDIO_LENGTH_INTEGER-$AUDIOFADE_DURATION)) ## Reducing FADE seconds from full length

FINAL_VIDEO_FILENAME="$AUDIO_LENGTH_INTEGER""-sec-""$OUTPUT_VIDEO_FINAL" ;

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
#ffmpeg -f image2 -framerate 24 -r 1/$TIME_PER_IMAGE -i image%03d.jpg -i $MY_SONG_DIR/$AUDIO_FILE -shortest -video_size $VIDEO_RES -af "afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION" -c:v libx264 -pix_fmt yuv420p $FINAL_VIDEO_FILENAME
## NEW COMMAND
ffmpeg -thread_queue_size 512 -framerate 1/$TIME_PER_IMAGE -i image%03d.png -i $MY_SONG_DIR/$AUDIO_FILE -shortest -s:v $VIDEO_RES -af "afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION" -c:v libx264 -vf "fps=25,format=yuv420p" $FINAL_VIDEO_FILENAME

echo; echo "FOLLOWING COMMAND IS USED FOR FFMPED ENCODING:" ; echo;
echo "ffmpeg -thread_queue_size 512 -framerate 1/$TIME_PER_IMAGE -i image%03d.png -i $MY_SONG_DIR/$AUDIO_FILE -shortest -s:v $VIDEO_RES -af \"afade=t=out:st=$AUDIO_LENGTH_MINUS_FADE:d=$AUDIOFADE_DURATION\" -c:v libx264 -vf \"fps=25,format=yuv420p\" $FINAL_VIDEO_FILENAME " ;

echo ; echo "=======> RE-ENCODING WITH AUDIO FADE: FFMPEG work ends ...."

## Moving VIDEO file to parent directory
BASENAME_FOLDER_NEW=`echo $tmp_varname | sed 's/\ /-/g' | sed 's/_/-/g' ` ;

FINAL_VIDEO_FILENAME_NEW="$BASENAME_FOLDER_NEW-$NUM_FILES-photos-$LENGTH_OF_SLIDESHOW_IN_MINUTES.mp4" ;
echo "FINAL_VIDEO_FILENAME_NEW: $FINAL_VIDEO_FILENAME_NEW" ;

cp $FINAL_VIDEO_FILENAME ../$FINAL_VIDEO_FILENAME_NEW ;
echo "=======> DONE: Moving FINAL VIDEO file to original parent directory ...." ;

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
\n FULL_COVER_TEXT: $FULL_COVER_TEXT
\n FINAL_VIDEO_FILENAME_NEW: $FINAL_VIDEO_FILENAME_NEW
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
say 'Video is done.' ;
