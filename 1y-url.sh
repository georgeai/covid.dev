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
    url=$2
else
    read -p "Enter the url: " url
fi

# create url file
filename="$shorty.md"
touch $filename
echo "---" >> $filename
echo "url: ${url}" >> $filename
echo "---" >> $filename
echo "" >> $filename

# edit file
#vi $filename

# commit and publish
git add $filename
git commit -m "new 1y: $site/$shorty -> $url"
git push -u origin master


