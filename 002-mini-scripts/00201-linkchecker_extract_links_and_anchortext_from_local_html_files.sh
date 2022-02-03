#/bin/bash

for x in *.html ; do 
    linkchecker -o csv -v $x | awk 'FS=";" {print "TRAVEL;"$8";"$11}' | sed 's/http:/https:/ig' | sort > $x.csv ;
done
