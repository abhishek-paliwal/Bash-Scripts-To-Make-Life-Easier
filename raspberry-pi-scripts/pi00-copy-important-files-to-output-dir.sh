#!/bin/bash
# Purpose: Copies some important files to script output directory
# Created on : Monday January 13, 2020
#############################################################################

OUTPUT_FILE="/home/pi/pali_personal/my-pi-scripts/_output_data_from_scripts/crontab_backup_for_user.txt" ;

echo "## THIS FILE CREATED AT: $(date) by this script => pi00-copy-important-files-to-output-dir.sh " > $OUTPUT_FILE  ;
echo "###########################################" >> $OUTPUT_FILE ;
crontab -l >> $OUTPUT_FILE  ;


  
