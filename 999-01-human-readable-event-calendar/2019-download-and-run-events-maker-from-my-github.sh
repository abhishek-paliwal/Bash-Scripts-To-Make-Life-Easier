#/bin/bash
###############################################################################
## THIS SCRIPT SHOULD ONLY BE RUN FROM DIGITAL OCEAN VPS. IT IS NOT MEANT
## TO BE RUN LOCALLY, BECAUSE ALL THE PATHS WILL BREAK. 
###############################################################################
## This script downloads two files from my github account, and then runs them.
###############################################################################
## Created on: Wednesday September 4, 2019
## Created by: Pali
###############################################################################

## Set PWD as a chosen directory and CD to it:
PWD="$HOME/scripts-made-by-pali/our-human-readable-events-maker"
cd $PWD
echo "Present working directory: $PWD";
###############################################################################

## Downloading the main script to run
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/999-01-human-readable-event-calendar/999_01-convert-and-sort-dates-to-human-readable-events.sh

## Downloading required text file for the script
curl -O https://raw.githubusercontent.com/abhishek-paliwal/Bash-Scripts-To-Make-Life-Easier/master/999-01-human-readable-event-calendar/999_01-ONLY-EDIT-THIS-FILE-WITH-EVENT-NAMES-AND-DATES.txt

## Running the downloaded script (setup a cronjob to run this):
bash 999_01-convert-and-sort-dates-to-human-readable-events.sh

## Finally, copying the created HTML output to the www accessible folder
cp INDEX-OF-OUR-EVENTS.html /var/www/vps.abhishekpaliwal.com/html/our-human-readable-events/INDEX-OF-OUR-EVENTS.html

## Checking whether cronjob is running as intended (current cronjob runs every 30 mins):
dateVar="$(date +%Y%m%d-%H%M%S)" ;
#cp INDEX-OF-OUR-EVENTS.html /var/www/vps.abhishekpaliwal.com/html/our-human-readable-events/$dateVar-INDEX-OF-OUR-EVENTS.html

echo ">>>> Script last ran at: $dateVar" ;
