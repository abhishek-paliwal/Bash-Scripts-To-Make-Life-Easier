#!/bin/bash
################################################################################
# Bash script to generate an HTML file with image captions and textareas from a CSV file.
# Author: Your Name
# Date: January 2, 2024
#
# Description:
# This script takes optional command-line arguments for CSV, HTML, and text file names.
# If no arguments are provided, default names are used based on the current directory's basename.
# The HTML file includes an image and a textarea for each row in the CSV file.
# A "Download Textareas" button triggers the download of all textareas as a text file.
#
# Usage: bash script.sh [csv_file] [html_file] [text_file]
################################################################################

# Define default file names based on the current directory
csv_file=$(basename "$PWD")"_captions.csv"
html_file=$(basename "$PWD")"_output.html"
text_file=$(basename "$PWD")"_captions.txt"

# Use command line arguments if provided
if [ $# -ge 1 ]; then
    csv_file=$1
fi

if [ $# -ge 2 ]; then
    html_file=$2
fi

if [ $# -ge 3 ]; then
    text_file=$3
fi

# Check if the CSV file exists
if [ ! -f "$csv_file" ]; then
    echo "Error: CSV file '$csv_file' not found."
    exit 1
fi

# Start generating the HTML content
echo "<!DOCTYPE html>" > "$html_file"
echo "<html lang='en'>" >> "$html_file"
echo "<head>" >> "$html_file"
echo "    <meta charset='UTF-8'>" >> "$html_file"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" >> "$html_file"
echo "    <title>Image Captions</title>" >> "$html_file"
echo "</head>" >> "$html_file"
echo "<body>" >> "$html_file"

# Read the CSV file line by line
index=1
while IFS=',' read -r image_path caption; do
    # Print or process each line as needed
    echo "    <img src='$image_path' alt='Image'>" >> "$html_file"
    echo "    <textarea>$caption</textarea>" >> "$html_file"
    echo "" >> "$html_file"
    ((index++))
done < "$csv_file"

# Add the download button and script
echo "    <button onclick='downloadTextareas()'>Download Textareas</button>" >> "$html_file"
echo "    <script>" >> "$html_file"
echo "        function downloadTextareas() {" >> "$html_file"
echo "            var combinedText = '';" >> "$html_file"
echo "            var textareas = document.getElementsByTagName('textarea');" >> "$html_file"
echo "            for (var i = 0; i < textareas.length; i++) {" >> "$html_file"
echo "                combinedText += 'Image Caption ' + (i + 1) + ':\\n' + textareas[i].value + '\\n\\n';" >> "$html_file"
echo "            }" >> "$html_file"
echo "            var blob = new Blob([combinedText], { type: 'text/plain' });" >> "$html_file"
echo "            var a = document.createElement('a');" >> "$html_file"
echo "            a.href = window.URL.createObjectURL(blob);" >> "$html_file"
echo "            a.download = '$text_file';" >> "$html_file"
echo "            document.body.appendChild(a);" >> "$html_file"
echo "            a.click();" >> "$html_file"
echo "            document.body.removeChild(a);" >> "$html_file"
echo "        }" >> "$html_file"
echo "    </script>" >> "$html_file"

# End the HTML file
echo "</body>" >> "$html_file"
echo "</html>" >> "$html_file"

echo "HTML file generated: $html_file"
