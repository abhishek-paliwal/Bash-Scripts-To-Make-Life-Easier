#!/bin/bash
###############################################################################

##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## CREATING SCRIPT USAGE FUNCION AND CALLING IT VIA '--help'
usage()
{
cat <<EOM
USAGE: $(basename $0)
  ###############################################################################
  ## THIS SCRIPT CHECKS BROKEN HYPERLINKS IN ANY GIVEN SITE.
  ## THIS SCRIPT USES DOCKER. SO, RUN DOCKER BEFORE RUNNING IT.
  ## GET HELP: https://github.com/linkchecker/linkchecker
  ###############################################################################
  ## USAGE (if run from command line interactive terminal):
  ## > docker run --rm -it -u \$(id -u):\$(id -g) -v "\$PWD":/mnt linkchecker/linkchecker --verbose --check-extern www.mygingergarlickitchen.com
  ## USAGE (if run from crontab by root):
  ## > docker run --rm -u \$(id -u):\$(id -g) -v "\$PWD":/mnt linkchecker/linkchecker --verbose --check-extern www.mygingergarlickitchen.com
  ###############################################################################
  ## CODED ON: Wednesday April 24, 2019
  ## BY: PALI
  ###############################################################################
  ## FOR HELP WITH LINKCHECKER PROGRAM: RUN THE FOLLOWING COMMAND:
  ## >>>>>>>>> PRINTS HELP MESSAGE ABOUT HOW TO RUN THIS IMAGE <<<<<<<<<<<
  ## docker run --rm -it -u \$(id -u):\$(id -g) -v "\$PWD":/mnt linkchecker/linkchecker --help
  ###############################################################################
EOM

exit 0 ## EXITING IF ONLY USAGE IS NEEDED
}
## Calling the usage function
if [ "$1" == "--help" ] ; then usage ; fi
##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


###############################################################################
## VARIABLES
MY_SITE="https://www.mygingergarlickitchen.com" ;

PWD=$(pwd) ;
echo; echo "Current working directory: $PWD" ; echo;

###############################################################################
## USER CONFIRMATION
echo "You are about to run the following command. It will create an HTML file in $PWD." ;

echo ">>>>> COMMAND >>>>> docker run --rm -it -u \$(id -u):\$(id -g) -v '\$PWD\':/mnt linkchecker/linkchecker --verbose --check-extern -F html $MY_SITE" ;

#read -p ">>>>>> If your sure sure, press ENTER key ..." ;
echo ;

###############################################################################

## RUNS THE ACTUAL COMMAND FOR \$MY_SITE (r0 = link recursion depth)
#### Running from the interactive shell via terminal application, CLI version
sudo docker run --rm -it -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --verbose --check-extern -F html $MY_SITE
#### Running from the crontab by root (Don't forget to remove -it from the docker command )
#sudo docker run --rm -u $(id -u):$(id -g) -v "$PWD":/mnt linkchecker/linkchecker --verbose --check-extern -F html $MY_SITE


###############################################################################
###############################################################################
