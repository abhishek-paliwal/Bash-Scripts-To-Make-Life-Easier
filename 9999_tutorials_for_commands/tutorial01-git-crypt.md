# TUTORIAL FOR USING THE COMMAND => git-crypt

-------

> Easy tutorial link: <https://dev.to/heroku/how-to-manage-your-secrets-with-git-crypt-56ih>
> 
> Git-Crypt project main page: <https://github.com/AGWA/git-crypt>

---------

1. Install git-crypt
```
$ brew install git-crypt
```

2. Create a new git repository or Enter into an existing git repository
```
$ cd YOUR_REPO
```

3. Set up the repository to use git-crypt
```
$ git-crypt init 
## you'll see the output > Generating key...
```

4. Before we do anything else, please run the following command to export the generated git-crypt key to the parent directory. This is done so that we can re-use the same key across multiple git repositories.
```
$ git-crypt export-key ../git-crypt-key
```

5. Tell git-crypt which files to encrypt. To do this create a `.gitattributes` file (if not present already). Edit it and add one line per file which you want to encrypt ...
```
## Add this => 
$ YOUR_FILEPATH filter=git-crypt diff=git-crypt
##
## OR For adding all matching files, add this => 
$ **/*.YOUR_FILE_EXTENSION filter=git-crypt diff=git-crypt
##
## IMPORTANT NOTE => NEVER EVER encrypt the .gitattributes file itself. Thus, don't add a simple ** which will inturn encrypt all files in this repo. To prevent this, you may add this line to .gitattributes file:
$ .gitattributes !filter !diff
```

6. Check which files will be encrypted
```
$ git-crypt status
```

7. To actuall encrypt the files to save from general public, you will need to atleast add and commit those changes before git-crypt will do its thing. Else, you will see error.

8. Please know that git-crypt automatically does its thing. You will see the files normally. However, if you want to see how these files look to general public, you will need to lock it first.
```
$ git-crypt lock
```

9. Then, after making sure that the files have indeed been encrypted, unlock them using the same git-crypt key generated and saved before.
```
$ git-crypt unlock ../git-crypt-key
```

10. Re-using Your git-crypt Key File for another repo. For this, rather than using git-crypt init command, you'll need to use the unlock command using the same key generated and saved before
```
$ cd YOUR_ANOTHER_REPO
$ git-crypt unlock ../git-crypt-key
```
