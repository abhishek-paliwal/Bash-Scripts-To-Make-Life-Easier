# TUTORIAL FOR USING THE COMMAND => oh-my-zsh Plugins (usage)

-------

> Plugins + Easy tutorials link: <https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins>

---------

## copybuffer 

This plugin adds the `ctrl-o` keyboard shortcut to copy the current text in the command line to the system clipboard. 
This is useful if you type a command - and before you hit enter to execute it - want to copy it maybe so you can paste it into a script, gist or whatnot.


## copyfile 

Puts the contents of a file in your system clipboard so you can paste it anywhere.
```
copyfile <filename> 
```

## copypath 

Copies the path of given directory or file to the system clipboard.
```
copypath ## copies the absolute path of the current directory.
copypath <file_or_directory> ## copies the absolute path of the given file.
```

## extract

Extracts the archive file you pass it, and it supports a wide variety of archive filetypes. (zip, 7z, tar, tar.gz, etc.)
```
extract <archive_filename>
```

## history 

Provides a couple of convenient aliases for using the history command to examine your command line history.
```
h	## history	         // Prints your command history
hl	## history | less	 // Pipe history output to less to search and navigate it easily
hs	## history | grep	 // Use grep to search your command history
hsi	## history | grep -i // Use grep to do a case-insensitive search of your command history
```

## jsontools 

Handy command line tools for dealing with json data.
Usage is simple... just take your json data and pipe it into the appropriate jsontool:
```
pp_json        ## pretty prints json.
is_json        ## returns true if valid json; false otherwise.
urlencode_json ## returns a url encoded string for the given json.
urldecode_json ## returns decoded json for the given url encoded string.
## Examples
# curl json data and pretty print the results
curl https://coderwall.com/bobwilliams.json | pp_json
# curl json data and verify that result is valid json
curl https://coderwall.com/bobwilliams.json | is_json
```

## web-search

This plugin adds aliases for searching with Google, Wiki, Bing, YouTube and other popular services.
```
$ web_search <context> <term> [more terms if you want]
$ web_search google oh-my-zsh
##
$ youtube "videos about programming python"
$ google oh-my-zsh
$ ddg oh-my-zsh
$ duckduckgo oh-my-zsh
$ bing oh-my-zsh
```

## z (jump around)

This plugin defines the z command that tracks your most visited directories and allows you to access them with very few keystrokes.
```
z test_dir_partial_name
```