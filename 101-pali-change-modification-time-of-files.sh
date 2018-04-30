#!/bin/bash
## CREATED by Pali on Friday April 6, 2018 - 6:10 PM

## THIS PROGRAM CHANGES THE CREATION/MODIFICATION TIME OF ANY FILE WHOSE NAME MATCHES ##
## THE NAMING AS yyyymmdd-filename-is-anything.fileextension, such as 20180401-video-file.mp4, etc. ##

PWD=`pwd`;
cd $PWD ; ## CD to present working directory

for filename in *.* ;
do
  echo "\n"; ## Inserts blank line

  ## Cuts the filename text with first 8 characters, and assigns that as a variable
  new_time=`echo "$filename" | cut -c 1-8` ;

  echo "CURRENT FILE: "$filename ;
  echo "NEW-TIME: "$new_time ;

      ## IF the new variable is only digits, such as date, etc. then do following:
      if [[ $new_time =~ ^[0-9]+$ ]]
          then
              echo "COMMENT: FILENAME OK. Starts with a number. So CREATION TIME changed." ;
              ## Now modifying the creation time
              touch -t $new_time"1234" $filename
          else
              echo "COMMENT: FILENAME NOT OK. Does not start with a number. So CREATION TIME NOT changed." ;
      fi

done

## FINALLY OPEN pwd
open $PWD ;
