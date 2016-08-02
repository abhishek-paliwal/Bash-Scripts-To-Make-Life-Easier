#!/bin/bash

ROOT=/Users/abhishek/Dropbox/Public/0000-WORDS-OF-WISDOM-WITH-MARKDOWN
HTTP="https://dl.dropboxusercontent.com/u/6378027/0000-WORDS-OF-WISDOM-WITH-MARKDOWN/"
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
  font-size: 20px;
}

#p1 {background-color:rgba(`jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 1 1`);}
#t1 {color:rgba(`jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 0 255`, `jot -r 1 1 1`);}

</style>
</head>
<body>
EOM

echo "<h1>Index of Books Created by Markdown // by Abhishek Paliwal</h1>" >> $OUTPUT
echo "<h2>Page last updated: "`date`"</h2>" >> $OUTPUT

#### Calculations begin ####
i=0
echo "<OL>" >> $OUTPUT
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <div id='p1'><i class='fa fa-book fa-1x'></i> $path</div>" >> $OUTPUT
  echo "  <OL>" >> $OUTPUT
  for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort | grep -i '.html'`; do
    file=`basename "$i"`
    echo "    <LI id='t1'><a href=\"$HTTP/$path/$file\">$file</a></LI>" >> $OUTPUT
  done
  echo "  </OL>" >> $OUTPUT
done
echo "</OL>" >> $OUTPUT

#### Calculations end ####

echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## Index Successfully created. ######### ";
