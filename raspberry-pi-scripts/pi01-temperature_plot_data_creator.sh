#!/bin/bash
# Purpose: Writes the ARM CPU and GPU temperatures to a CSV file
# Created on: Monday January 13, 2020
#############################################################################

TODAY=$(date +%Y%m%dT%H:%M:%S) ;

FILE_DATE=$(date +%Y%m%d) ;
OUTPUT_CSVFILE="/home/pi/pali_personal/my-pi-scripts/_output_data_from_scripts/${FILE_DATE}-pi01-data_temperature_output.csv" ;

## GETTING THE TEMPERATURE OF PI BOARD
TEMP=$(/opt/vc/bin/vcgencmd measure_temp) ;

## Printing and writing to csvfile
echo "$TODAY,$TEMP" | sed -e 's/temp=//g' -e "s/'C//g" ;
echo "$TODAY,$TEMP" | sed -e 's/temp=//g' -e "s/'C//g"  >> $OUTPUT_CSVFILE ;
echo ">>>> DATAPOINT APPENDED TO THIS CSV FILE => $OUTPUT_CSVFILE" ;

## Adding column names as by replacing the first line
COLNAMES="DATETIME,TEMPERATURE" ;
sed -i "1s/.*/$COLNAMES/" $OUTPUT_CSVFILE ;