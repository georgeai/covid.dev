#!/bin/bash

# short url manager: https://github.com/nhoizey/1y

site="site"

if [ -n "$1" ]
then
    shorty=$1
else
    read -p "Enter the shorty: " shorty
fi

if [ -n "$2" ]
then
    note=$2
else
    read -p "Enter the note: " note
fi

# create note file
filename="$shorty.md"
touch $filename
echo "---" >> $filename
echo "note: ${note}" >> $filename
echo "---" >> $filename
echo "" >> $filename

# edit file
vi $filename

# commit and publish
git add $filename
git commit -m "new 1y note: $site/$shorty -> $note"
git push -u origin master


