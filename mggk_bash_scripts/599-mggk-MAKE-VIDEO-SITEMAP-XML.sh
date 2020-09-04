#/bin/bash
################################################################################
THIS_SCRIPT_FILE="599-mggk-MAKE-VIDEO-SITEMAP-XML.sh"
################################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
	################################################################################
	## THIS SCRIPT CREATES VIDEO SITEMAP XML FILE FROM ALL THE MD FILES WHICH CONTAIN
	## youtube_video_id TAG IN YAML FRONTMATTER.
	## IT THEN SAVES IT IN HUGO STATIC DIRECTORY AS video-sitemap.xml
	############################################
	## USAGE: bash $THIS_SCRIPT_FILE
	############################################
	## CREATED ON: Thursday November 28, 2019
	## CREATED BY: PALI
	################################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

################################################################################
HUGO_CONTENT_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/content"
XML_OUTFILE="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/video-sitemap.xml" ;
HUGO_CURRENT_YOUTUBE_IMAGE_COVERS_DIR="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/wp-content/youtube_video_cover_images" ;
CURRENT_VIDEO_COVER_IMAGES_TXTFILE="$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/video-cover-images-current.txt"
TMPDIR="$HOME/Desktop/Y"
################################################################################

## LISTING AND SAVING ALL CURRENTLY EXISTING YOUTUBE COVER IMAGES
for myImage in $(ls $HUGO_CURRENT_YOUTUBE_IMAGE_COVERS_DIR/*.jpg | sort) ; do echo "$(basename $myImage)" ; done > $CURRENT_VIDEO_COVER_IMAGES_TXTFILE 
## Printing
echo; echo ">>>> LISTING CURRENT IMAGES IN: $HUGO_CURRENT_YOUTUBE_IMAGE_COVERS_DIR" ;
cat $CURRENT_VIDEO_COVER_IMAGES_TXTFILE | nl ;
echo; 
################################################################################

##################################################################################
############ PART 1 = FINDING WHICH IMAGES ARE NOT PRESENT IN VIDEO SITEMAP AND DOWNLOADING THEM
##################################################################################
## GETTING ALL THE IMAGES FOR LIVE VIDEO SITEMAP
wget -qO- https://www.mygingergarlickitchen.com/video-sitemap.xml | grep '<video:thumbnail_loc>' | sed 's!<video:thumbnail_loc>https://www.mygingergarlickitchen.com/wp-content/youtube_video_cover_images/!!ig' | sed 's!.jpg</video:thumbnail_loc>!!ig' | tr -d "[:blank:]" | sort > $TMPDIR/_tmp_599_sorted_youtube_id_from_video_sitemap.txt

## GETTING ALL THE IMAGES FOR CURRENT YOUTUBE VIDEO COVER IMAGES PRESENT LOCALLY
cat "$HOME/GitHub/2019-HUGO-MGGK-WEBSITE-OFFICIAL/static/video-cover-images-current.txt" | sed 's/.jpg//ig' | tr -d "[:blank:]" | sort > $TMPDIR/_tmp_599_sorted_youtube_covers_currently_present.txt

## PRINTING ONLY THE DIFFERENCES BETWEEN THE TWO
comm -23 $TMPDIR/_tmp_599_sorted_youtube_id_from_video_sitemap.txt $TMPDIR/_tmp_599_sorted_youtube_covers_currently_present.txt > $TMPDIR/_tmp_599_final_images_to_download_from_youtube.txt

## WHICH IMAGES WILL BE DOWNLOADED 
echo;echo ">>>> THESE IMAGES WILL BE DOWNLOADED (FOR THE FOLLOWING YOUTUBE VIDEO IDs):" ;
cat "$TMPDIR/_tmp_599_final_images_to_download_from_youtube.txt" | sort | nl ;
##################################################################################

##------------------------------------------------------------------------------
######### FUNCTION DEFINITION #########
######### BEGIN: FUNCTION - DOWNLOADING THE COVER IMAGE FROM YOUTUBE AND SAVING TO LOCAL DIR ##########
FUNCTION_DOWNLOAD_COVER_IMAGE_FROM_YOUTUBE () {
	video_youtube_id=$1 ; ## $1= current value of youtube_video_id
	echo "	>> DOWNLOADING THE COVER IMAGE FROM YOUTUBE AND SAVING TO LOCAL DIR" ;
	COVER_IMAGE_DOWNLOAD_DIR="$(pwd)/_TMP_599_DOWNLOADED_COVER_IMAGES" ;
	mkdir $COVER_IMAGE_DOWNLOAD_DIR ;
	wget "https://i.ytimg.com/vi/$video_youtube_id/maxresdefault.jpg" -O "$COVER_IMAGE_DOWNLOAD_DIR/$video_youtube_id.jpg" ;
}
######### END: FUNCTION - DOWNLOADING THE COVER IMAGE FROM YOUTUBE AND SAVING TO LOCAL DIR ##########

## DOWNLOADING EACH MISSING IMAGE FILE FROM YOUTUBE
while IFS= read -r line
do
    echo "== $line"
    ## CALLING THE FUNCTION TO DOWNLOAD ALL COVER IMAGES FROM YOUTUBE
    FUNCTION_DOWNLOAD_COVER_IMAGE_FROM_YOUTUBE "$line" ;
done < "$TMPDIR/_tmp_599_final_images_to_download_from_youtube.txt"
##------------------------------------------------------------------------------

## WRITING FIRST LINE IN VIDEO SITEMAP XML_OUTFILE
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"https://www.mygingergarlickitchen.com/video-sitemap-mggk.xsl\"?>
<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" xmlns:video=\"http://www.google.com/schemas/sitemap-video/1.1\">" > $XML_OUTFILE

##------------------------------------------------------------------------------
## BEGIN: LOOPING THROUGH ALL MD FILES CONTAINING youtube_video_id
TOTAL_VALID_FILES=$(grep -irl 'youtube_video_id:' $HUGO_CONTENT_DIR/* | wc -l)
COUNT=0;
for mdfile in $(grep -irl 'youtube_video_id:' $HUGO_CONTENT_DIR/*) ; do
	(( COUNT++ ))
	echo ">> Currently processing File = $COUNT of $TOTAL_VALID_FILES" ;

	## GETTING ALL VARIABLE VALUES + TRIMMING ALL LEADING + TRAILING WHITESPACES
	video_title=$(grep -irh '^title:' $mdfile | sed -e 's/title: //g' -e 's/"//g' -e 's/&/and/g' | awk '{$1=$1;print}')
	video_post_url=$(grep -irh '^url:' $mdfile | sed -e 's/url: //g' -e 's/"//g' | awk '{$1=$1;print}')
	video_youtube_id=$(grep -irh 'youtube_video_id:' $mdfile | sed -e 's/youtube_video_id: //g' -e 's/"//g' | awk '{$1=$1;print}')
	video_description=$(grep -irh 'yoast_description:' $mdfile | sed -e 's/yoast_description: //g' -e 's/"//g' -e 's/&/and/g' | awk '{$1=$1;print}')
	video_cover_image=$(grep -irh '^featured_image:' $mdfile | sed -e 's/featured_image: //g' -e 's/"//g' | awk '{$1=$1;print}')
	video_cover_image_official="https://www.mygingergarlickitchen.com/wp-content/youtube_video_cover_images/$video_youtube_id.jpg"
	video_author=$(grep -irh '^author:' $mdfile | sed -e 's/author: //g' -e 's/"//g' | awk '{$1=$1;print}')
	video_date=$(grep -irh '^date:' $mdfile | sed -e 's/date: //g' -e 's/"//g' -e 's/+00:00//g' | awk '{$1=$1;print}')

	## WRITING ALL VALUES IN XML OUTPUT FILE
	echo "	<url>
			<loc>https://www.mygingergarlickitchen.com$video_post_url</loc>
			<video:video>
				<video:title>$video_title</video:title>
				<video:publication_date>$video_date+00:00</video:publication_date>
				<video:description>$video_description</video:description>
				<video:player_loc allow_embed=\"yes\">https://www.youtube.com/embed/$video_youtube_id</video:player_loc>
				<video:thumbnail_loc>$video_cover_image_official</video:thumbnail_loc>
	      <video:width>1920</video:width>
				<video:height>1080</video:height>
				<video:family_friendly>yes</video:family_friendly>
				<video:uploader info='https://www.mygingergarlickitchen.com/'>$video_author</video:uploader>
			</video:video>
	</url>" >> $XML_OUTFILE ;

	## CALLING THE FUNCTION TO DOWNLOAD ALL COVER IMAGES FROM YOUTUBE
	#FUNCTION_DOWNLOAD_COVER_IMAGE_FROM_YOUTUBE "$video_youtube_id" ;

done
## END: LOOPING THROUGH ALL MD FILES CONTAINING youtube_video_id
##------------------------------------------------------------------------------

echo "</urlset>" >> $XML_OUTFILE
################################################################################
## SUMMARY
echo; echo "VIDEO-SITEMAP.XML FILE SAVED AT=> $XML_OUTFILE"
