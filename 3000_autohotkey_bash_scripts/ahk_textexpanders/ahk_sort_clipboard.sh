#!/bin/bash
# This script sorts the clipboard content passed as a file
clipboard_file=$1
if [ -f "$clipboard_file" ]; then
    sort "$clipboard_file" > "/mnt/c/Users/abhip/Desktop/Y/1.txt" 
    cat "/mnt/c/Users/abhip/Desktop/Y/1.txt" 
    date
else
    echo "CLI argument File not found!"
fi
