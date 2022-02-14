#/bin/bash
##################################################################################
## FUNCTION DEFINITIONS
##################################################################################
function step0_gops_choose_final_video_dimensions () {
    ##
    bash $REPO_SCRIPTS/002-mini-scripts/00208_pali_print_video_and_image_dimensions_using_ffprobe.sh ; 
    ##
    echo "ENTER width ="; 
    read width ; 
    echo "ENTER height =" ; 
    read height ; 
    echo ">>>> POSSIBLE DIMENSIONS (choose where width is around 640px): "; 
    for x in $(seq 1 0.5 15) ; do 
        w=$(echo $width/$x | bc) ;  
        h=$(echo $height/$x | bc) ; 
        echo "$x times smaller => $w x $h"; 
    done
}
#########################
function step1_gops_convert_mp4_mkv_to_CUSTOM_WIDTH_ffmpeg () {
    ##
    bash $REPO_SCRIPTS/002-mini-scripts/00208_pali_print_video_and_image_dimensions_using_ffprobe.sh ; 
    ##
    printf "%s " ">>Press ENTER key to continue ..." ; 
    read ; 
    echo "ENTER width ="; 
    read width ; 
    for myfile in $(fd -e mp4 -e mkv --search-path=$(pwd)); do 
        x=$(basename $myfile) ;
        echo; echo; echo "=====================" ; 
        time ffmpeg -i $x -c:v libx264 -c:a copy -vf scale=$width:-2 OUTPUT-$width-px-$x ; 
    done
    ## 
    echo "##------------" ; 
    du -skh * ; 
    ring_terminal_bell_5_times ;
}
#########################
function step2_gops_extract_video_screenshots_every_4_mins () {
    count=1; 
    for x in $(fd "OUTPUT-" -t f -e mp4 -e mkv) ; do 
        my_dir="video_screenshot-dir-${count}" ; 
        mkdir $my_dir ; 
        ffmpeg -i $x -vf fps=1/240 $my_dir/${count}_thumb%5d.jpg ; 
        ((count++)) ; 
    done
    ## create collage
    bash $REPO_SCRIPTS/2000_vendor_programs/2000-collage-maker-for-subdirectories-vendor-script-leelasrecipes.sh ; 
    ##
}
#########################
function step3_gops_copy_all_files_n_folders_to_pi_server () {
    pi_basedir="pi:/media/usb/pi_plex_movies/gops" ;
    rclone mkdir $pi_basedir ;
    for x in $(fd -t d) ; do 
        rclone -P copy $x $pi_basedir/$x ; 
        rclone lsl $pi_basedir/$x ; 
    done ; 
    ##
    for y in $(fd -d 1 -t f) ; do 
        rclone -P copy $y $pi_basedir/ ; 
    done; 
    echo ; 
    echo ">> LISTING FILES + DIRECTORIES =>" ; 
    rclone lsl $pi_basedir/ ; 
}
#########################
function step4_gops_create_html_file_for_7z_files_dreamobjects () {
    HTML_FILE="tmp_g.html" ; 
    echo "HTML File created on $(date)" > $HTML_FILE ; 
    for x in *.7z ; do 
        LINK="http://public-palibucket.objects-us-east-1.dream.io/g/$x" ;
        file_size=$(du -skh $x | awk '{print $1}' ) ; 
        qr "$LINK" > qrcode_$x.png ; 
        echo ">> QR Code created for $x" ; 
        echo "<h2>FILE SIZE: $file_size // <a href='$LINK'>$LINK</a></h2><img src='qrcode_$x.png'></img><hr>" >> $HTML_FILE ;
    done
    ## 
    echo ">> HTML FILE created => $HTML_FILE" ;
}
#########################
function step5_gops_copy_7z_files_to_dreamobjects () {
    dreamobj_basedir="dreamobjects:public-palibucket/g" ;
    #rclone mkdir $dreamobj_basedir ;
    for myfile in $(fd -t f -e 7z -e png -e html --search-path=$(pwd)) ; do 
        x=$(basename $myfile) ;
        echo ">> DREAMOBJECTS COPYING FILE: $x ..." ; 
        rclone -P copy $x $dreamobj_basedir/ ; 
        echo "LINK = http://public-palibucket.objects-us-east-1.dream.io/g/$x" ; 
    done ; 
    echo ">> LISTING FROM THE SERVER => $dreamobj_basedir/" ; 
    rclone ls $dreamobj_basedir/ ; 
}
#########################
function ring_terminal_bell_5_times () {
    for x in $(seq 1 1 5); do 
        tput bel ; sleep 3 ; 
    done
}
##################################################################################
##################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CALLING FUNCTIONS SEQUENTIALLY (comment/uncomment as needed)
step0_gops_choose_final_video_dimensions ;
step1_gops_convert_mp4_mkv_to_CUSTOM_WIDTH_ffmpeg ;
step2_gops_extract_video_screenshots_every_4_mins ;
#step3_gops_copy_all_files_n_folders_to_pi_server ;
step4_gops_create_html_file_for_7z_files_dreamobjects ;
step5_gops_copy_7z_files_to_dreamobjects ;
ring_terminal_bell_5_times ;
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
