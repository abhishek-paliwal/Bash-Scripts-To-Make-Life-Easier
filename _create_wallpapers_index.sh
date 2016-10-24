#!/bin/bash

ROOT=/Users/abhishek/GitHub/abhishek-paliwal.github.io
HTTP="https://abhishek-paliwal.github.io"
OUTPUT="$ROOT/wallpapers-index.html"

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

#p1 {background-color:rgba(180,180,180,1);}
#t1 {color: rgba(180,180,180,1);}
#mggk {color: rgba(255,0,80,1);}
#concepro {color: #3498db;}


</style>
</head>
<body>
EOM

echo "<h1>Index of Javascript Wallpaper Creators // by Abhishek Paliwal</h1>" >> $OUTPUT
echo "<h2>Page last updated: "`date`"</h2>" >> $OUTPUT

#### Calculations begin ####
i=0
echo "<OL>" >> $OUTPUT
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <div id='p1'><i class='fa fa-book fa-1x'></i> $path</div>" >> $OUTPUT
  echo "  <OL>" >> $OUTPUT
  for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f | egrep -i '.html|.HTML' | sort -n`; do
    file=`basename "$i"`

    ## Finding out the proper CSS STYLE variable
    if [[ $file == *"MGGK"* ]] ;
        then id="mggk" ;
    elif [[ $file == *"CONCEPRO"* ]] ;
        then id="concepro" ;
    else id="t1" ;
    fi

    fontawesomeiconhtml="<i class='fa fa-html5 fa-2x'></i>  "

    echo "    <LI id='$id'>$fontawesomeiconhtml<a href=\"$HTTP/$path/$file\">$file</a></LI>" >> $OUTPUT
  done
  echo "  </OL>" >> $OUTPUT
done
echo "</OL>" >> $OUTPUT

#### Calculations end ####

echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

echo "######## WALLPAPER Index Successfully created. ######### ";
