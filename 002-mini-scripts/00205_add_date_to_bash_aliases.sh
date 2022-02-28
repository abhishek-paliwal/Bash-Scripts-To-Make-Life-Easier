#/bin/bash

func_add_date_to_BA () {
    myTMPFILE="/tmp/tmp1.txt" ;     
    BA_FILE="$HOME/.bash_aliases" ;     
    BACKUP_BA_FILE="$HOME/.bash_aliases.BACKUP" ;     
    echo "###### FILE LAST EDITED: $(date) ######" > $myTMPFILE  ;     
    cat $myTMPFILE $BA_FILE > $BACKUP_BA_FILE ;     
    rm $BA_FILE ;     
    cp $BACKUP_BA_FILE $BA_FILE ;    
    echo "BA_FILE = $BA_FILE // BACKUP = $BACKUP_BA_FILE" ; 
} ; 
    
func_add_date_to_BA ; 