#!/bin/bash

ROOT="/Users/abhishek/Dropbox/Public/__To_Synchonize-With-Webserver/0000-WORDS-OF-WISDOM-WITH-MARKDOWN"
HTTP="http://downloads.concepro.com/dropbox-public-files/0000-WORDS-OF-WISDOM-WITH-MARKDOWN"
OUTPUT="$ROOT/Index-Of-All-Markdown-Books.html"

cat > $OUTPUT <<- EOM
<!DOCTYPE html>
<html>
<head>
<script src="https://use.fontawesome.com/8cd0876759.js"></script>
<link href="https://fonts.googleapis.com/css?family=Montserrat:700" rel="stylesheet">
<style>
div, ul, li {
    padding: 10px;
    margin: 10px;
    color: white;
    font-family: 'Montserrat', sans-serif;
    font-size: 18px;
    line-height:1;
}

h1 {
  font-family: 'Montserrat', sans-serif;
  color: black;
  font-size: 30px;
}

h2 {
  font-family: 'Montserrat', sans-serif;
  color: #c0c0c0;
  font-size: 15px;
}

#p1 {background-color:rgba(`jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 1 1`);}
#t1 {color:#FF0066;}

</style>
</head>
<body>
EOM

echo "<h1>Index of Books Created by Markdown // by Abhishek Paliwal</h1>" >> $OUTPUT
echo "<h2>Page last updated: "`date`"</h2>" >> $OUTPUT
echo "<h2>Reading times are approximated at 200 words per minute.</h2>" >> $OUTPUT

#### Calculations begin for HTML files ####
i=0
echo "<OL>" >> $OUTPUT
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <div id='p1'><i class='fa fa-book fa-1x'></i> $path</div>" >> $OUTPUT
  echo "  <OL>" >> $OUTPUT
  for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort | egrep -i '.html|.HTML'`; do
    file=`basename "$i"`

    filemd=`echo $file | cut -d "." -f 1`   ## Getting the MarkDown Filename without extension, from the HTML file.
    filemd+=".md"; ## Appending the .md extension at the end of the extracted filename.

    fontawesomeiconhtml="<i class='fa fa-html5 fa-2x'></i>  "
    fontawesomeiconmdcode="<i class='fa fa-file-code-o fa-lg'></i>  "

    echo "    <LI id='t1'>$fontawesomeiconhtml<a href=\"$HTTP/$path/$file\">$file</a> | $fontawesomeiconmdcode<a href=\"$HTTP/$path/$filemd\">Source MarkDown</a><br>( `wc -w $filepath/$filemd | awk 'BEGIN{FS=" "} {printf("%.0f %s\n", ($1/200), "minutes reading")}'` )</LI>" >> $OUTPUT
  done
  echo "  </OL>" >> $OUTPUT
done
echo "</OL>" >> $OUTPUT

#### Calculations end for HTML files ####

#### Calculations begin for PDF files ####
echo "<hr><h1>List of PDF + MP3/WAV + TXT files:</h1>" >> $OUTPUT
j=0
echo "<OL>" >> $OUTPUT
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <div id='p1'><i class='fa fa-book fa-1x'></i> $path</div>" >> $OUTPUT
  echo "  <OL>" >> $OUTPUT
  for j in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort | egrep -i '.pdf|.mp3|.wav|.txt'`; do
    file=`basename "$j"`

    extension=$([[ "$file" = *.* ]] && echo ".${file##*.}" || echo '')

## Removing the 'dot' from the extension and converting to uppercase
    extension=`echo $extension | tr '[a-z]' '[A-Z]' | sed 's/.//'`
    fontawesomeicon="<i class='fa fa-html5 fa-2x'></i> "

    if [ "$extension" == "PDF" ] ; then fontawesomeicon="<i class='fa fa-file-pdf-o fa-2x'></i>  " ; fi
    if [ "$extension" == "MP3" ] ; then fontawesomeicon="<i class='fa fa-music fa-2x'></i>  " ; fi
    if [ "$extension" == "WAV" ] ; then fontawesomeicon="<i class='fa fa-music fa-2x'></i>  " ; fi
    if [ "$extension" == "TXT" ] ; then fontawesomeicon="<i class='fa fa-file-text fa-2x'></i>  " ; fi

    echo "    <LI id='t1'>$fontawesomeicon<a href=\"$HTTP/$path/$file\">$file ($extension)</a></LI>" >> $OUTPUT
  done
  echo "  </OL>" >> $OUTPUT
done
echo "</OL>" >> $OUTPUT

#### Calculations end for PDF files ####



echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## Index Successfully created. ######### ";
