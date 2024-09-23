################################################################################
## THIS PROGRAM PARSES THE YOUTUBE RSS FEED FOR PARTICULAR CHANNEL(S), GIVEN CHANNEL ID
## THIS PROGRAM WORKS ON MAC and LINUX.
## DATE: 2024-09-23
## BY: PALI
################################################################################

#!/bin/bash

# YouTube Channel RSS URL (replace CHANNEL_ID with the actual ID)
CHANNEL_ID="UCRyPPlAalIpnYtj8ONdN_4w"  # MGGK channel ID
RSS_URL="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"

# Fetch RSS feed
rss_feed=$(curl -s "$RSS_URL")

# Parse video titles, links, and upload dates from the RSS feed
echo "Latest videos from the YouTube channel:"
echo

# Extract title, link, and upload date
titles=$(echo "$rss_feed" | sed -n 's:.*<title>\(.*\)</title>:\1:p' | tail -n +2)  # Skip the first title (channel name)
links=$(echo "$rss_feed" | sed -n 's:.*<link rel="alternate" href="\([^"]*\)".*:\1:p')
dates=$(echo "$rss_feed" | sed -n 's:.*<published>\(.*\)</published>:\1:p')

# Combine the extracted data
paste <(echo "$titles") <(echo "$links") <(echo "$dates") | while IFS=$'\t' read -r title link date
do
    echo "Title: $title"
    echo "URL: $link"
    echo "Upload Date: $date"
    echo
done

