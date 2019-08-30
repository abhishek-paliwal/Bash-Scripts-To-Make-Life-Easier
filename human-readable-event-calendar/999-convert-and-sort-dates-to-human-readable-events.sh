#!/bin/bash
##########################################################

##########################################################
#prefix="swimming" ## for swimming
prefix="skating" ## for skating
##########################################################
echo;
input1="tmp.txt"
count=0;
echo "// formatting: list of $prefix dates below, relative time from today" ;
while IFS= read -r line
do
  (( count++ ))
  #echo $count

  var1="let date$prefix$count = moment(\""
  var2="\", \"YYYYMMDD h:mm:dd\").fromNow();"

  echo "$var1$line$var2" ;

done < "$input1"
############################################################

############################################################
echo;
input2="tmp2.txt"
count2=0;
echo "// formatting: list of $prefix dates below for displaying as plain text"
while IFS= read -r line
do
  (( count2++ ))
  #echo $count
  var0="plain"
  var1="let date$prefix$count2$var0 = moment(\""
  var2="\").format('[on] dddd - MMMM Do YYYY, [at] h:mm:ss a'); "

  echo "$var1$line$var2" ;

done < "$input2"
############################################################


#############################################################
#############################################################
## Depending upon the number of lines in tmp files, on the
## basis of count and count2++ variables, we will publish some more
## info onto the CLI
##############################################################
echo;
echo "<!-- $prefix: The DIVs will be printed below -->" ;
for x in $(seq 1 $count) ; do
  echo "<h2 style=\"color: deeppink;\" id=\"$prefix$x\"></h2> " ;
done
###############
echo;
echo "// $prefix: Getting the values for the DIVs from variables" ;
for x in $(seq 1 $count) ; do
  echo "document.getElementById(\"$prefix$x\").innerHTML = date$prefix$x + \"<br><span style='color:silver;'>(\" + date$prefix$x$var0 + \")</span>\" ; " ;
done
##############
