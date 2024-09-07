#!/bin/bash

### RUN THIS BASH SCRIPT AFTER RUNNING STEP 1 PROGRAM

# Create the HTML file
MYDIR_PROJECT="$REPO_SCRIPTS/2000_vendor_programs/2003_find_similar_images" ;
step1_result_txtfile="$MYDIR_PROJECT/_tmp_step1_result_file.txt" ; 
html_file="$MYDIR_PROJECT/_tmp_result_image_pairs.html"
touch "$html_file"

# Write the HTML header and table start
echo "<html>" > "$html_file"
echo "<head><title>Image Pairs</title></head>" >> "$html_file"
echo "<body><h1>Comparison of images</h1><h2>Created date: $(date)</h2>" >> "$html_file"
echo "<table border='1'>" >> "$html_file"

# Read the text file line by line
while read line; do
    # Extract the image paths
    image1=$(echo "$line" | cut -d "'" -f 2)
    image2=$(echo "$line" | cut -d "'" -f 4)

    # Get the image names
    image1_name=$(basename "$image1")
    image2_name=$(basename "$image2")

    # Get the image sizes in kilobytes
    image1_size=$(stat -c '%s' "$image1")
    image1_kb=$(bc <<< "scale=2; $image1_size / 1024")
    image2_size=$(stat -c '%s' "$image2")
    image2_kb=$(bc <<< "scale=2; $image2_size / 1024")

    # Create a table row with two columns
    echo "<tr>" >> "$html_file"
    echo "<td> <img width=\"300px\" src=\"$image1\" alt=\"$image1_name\"> <p>$image1_name ($image1_kb KB)</p> </td>" >> "$html_file"
    echo "<td> <img width=\"300px\" src=\"$image2\" alt=\"$image2_name\"> <p>$image2_name ($image2_kb KB)</p> </td>" >> "$html_file"
    echo "</tr>" >> "$html_file"
done < "$step1_result_txtfile"

# Write the HTML footer and table end
echo "</table>" >> "$html_file"
echo "</body></html>" >> "$html_file"

###################################################################
echo ">> HTML image comparison file created at $html_file" ; 
echo ">> Opening HTML file ..." ; 
open "$html_file" ;