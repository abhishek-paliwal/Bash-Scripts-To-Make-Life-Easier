#!/bin/bash
## THIS PROGRAM USES FFMPEG TO CONVERT AUDIO FILE FROM OPUS FORMAT TO MP3
## DATE: Monday July 2, 2018
## By: Pali

OUTPUT_DIR="_ffmpeg_voice_output"
mkdir $OUTPUT_DIR

for x in *.opus
    do
        ## FOR SEPARATION OF FILENAME AND EXTENSION PART
        y=$(basename -- "$x")
        extension="${y##*.}"
        filename="${y%.*}"

        ## CONVERTING OPUS TO MP3
        ffmpeg -i $x -acodec libmp3lame $OUTPUT_DIR/$filename.mp3
    done
