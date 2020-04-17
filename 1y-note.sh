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

Title=`echo $shorty | tr -d '[:punct:]' | tr 'A-Z' 'a-z'`
for word in $Title
do
  dashedTitle=${dashedTitle}-${word}
done
# create note file
filename="`date +%Y-%m-%d`${dashedTitle}.md"
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


