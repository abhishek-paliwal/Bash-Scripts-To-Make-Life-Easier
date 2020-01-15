#!/bin/bash

IN_DIR="/home/pi" ;
BACKUP_DIR='/home/00-BACKUPS' ;

date_prefix="$(date +%Y%m%d)" ;

zip -r $BACKUP_DIR/$date_prefix-RPI4-BACKUP.zip $IN_DIR ;

echo "####################################################" ;
echo ">>>> BACKUP Done ..." ;
echo ">>>> Backup ZIP file created = $BACKUP_DIR/$date_prefix-RPI-BACKUP.zip" ; 
echo "####################################################" ;
