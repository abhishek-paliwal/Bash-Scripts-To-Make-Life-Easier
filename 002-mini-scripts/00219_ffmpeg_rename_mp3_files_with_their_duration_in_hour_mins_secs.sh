#/bin/bash
## RENAME MP3 FILES WITH THEIR DURATION IN HOURS MINUTES

WORKDIR="$DIR_Y" ;
TMPDIR="$WORKDIR/_TMP_RENAMED" ; 
mkdir -p "$TMPDIR" ; 

for x in *.mp3 ; do  
    echo "##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" ; 
    TMPFILE="$WORKDIR/_tmp011.txt" ; 
    ffprobe -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$x" 2>/dev/null > "$TMPFILE" ;
    duration_in_secs="$(cat $TMPFILE | cut -d . -f1)" ;
    song_duration=$(gdate -d@${duration_in_secs} -u +%Hh-%Mm-%Ss) ;
    echo ">> ORIGINAL FILE => $x" ; 
    echo ">> song_duration in hours and mins => $song_duration" ;
    ##
    NEW_FILENAME="$TMPDIR/audiobook-$song_duration-$(basename $x)" ; 
    echo ">> COPYING THE RENAMED FILE => $NEW_FILENAME"  ; 
    cp "$x" "$NEW_FILENAME" ;
done

## PRINTING CURRENT FILE TREE
echo; echo "##------------------------------------------------------------------------------" ;
echo ">> PRINTING FILE TREE" ; 
tree $WORKDIR ; 
echo "##------------------------------------------------------------------------------" ; 


# alias 00219_ffmpeg_rename_mp3_files_with_their_duration_in_hour_mins_secs="bash $REPO_SCRIPTS_MINI/00219_ffmpeg_rename_mp3_files_with_their_duration_in_hour_mins_secs.sh"