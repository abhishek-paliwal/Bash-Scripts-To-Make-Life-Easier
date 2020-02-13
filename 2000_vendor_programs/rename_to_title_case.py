import os
import sys
import shutil

directory = sys.argv[1]
print("\n########################################################################")
print(">>>> Files and folders will be renamed in this directory: " + directory)
print(">>>> NOTE: Files and directories will only be renamed if they atleast have one other joining characters between filename words, OTHER THAN HYPHENS.")
print(">>>> It means if the filenames contains only hyphens between words, they will not be renamed to title case.")
print("------------------------------------------------------------------------\n")

skip = ["a", "an", "the", "and", "but", "or", "nor", "at", "by", "for", "from", "in", "into", "of", "off", "on", "onto", "out", "over", "to", "up", "with", "as"]
## REPLACE UNWANTED CHARACTERS WITH HYPHENS
#replace = [ ["(", "["], [")", "]"], ["{", "["], ["}", "]"], [" ","-"], ["_","-"] ]
replace = [ ["-","_"], ["(", "-"], [")", "-"], ["(", "-"], [")", "-"], ["{", "-"], ["}", "-"], ["[","-"],["]","-"] ,[" ","-"], ["_","-"], ["--","-"] ]

def exclude_words(name):
    for item in skip:
        name = name.replace(" "+item.title()+" ", " "+item.lower()+" ")
    # on request of OP, added a replace option for parethesis etc.
    for item in replace:
        name = name.replace(item[0], item[1])
    return name

for root, dirs, files in os.walk(directory):
    for f in files:
        split = f.find(".")
        if split not in (0, -1):
            name = ("").join((f[:split].lower().title(), f[split:].lower()))
        else:
            name = f.lower().title()
        name = exclude_words(name)
        shutil.move(root+"/"+f, root+"/"+name)
        print(f + ' === FILE RENAMED TO ==> ' + name)

for root, dirs, files in os.walk(directory):
    for dr in dirs:
        name = dr.lower().title()
        name = exclude_words(name)
        shutil.move(root+"/"+dr, root+"/"+name)
        print(dr + ' === DIRECTORY RENAMED TO ==> ' + name)
