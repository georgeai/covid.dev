#!/bin/bash

# short url manager: https://github.com/nhoizey/1y

site="site"

if [ -n "$1" ]
then
    title=$1
else
    read -p "Title: " title
fi

if [ -n "$2" ]
then
    note=$2
else
    read -p "Note: " note
fi

if [ -n "$3" ]
then
    shorty=$3
else
    read -p "Enter the shorty: " shorty
fi


#Title=`echo $shorty | tr -d '[:punct:]' | tr 'A-Z' 'a-z'`
#Title=`echo $shorty | tr '[:blank:]' '-' | tr -s '-' | tr 'A-Z' 'a-z'`
Title=`echo $title | tr '[:punct:]' ' ' | awk '{$1=$1};1' | tr '[:blank:]' '-' | tr -s '-' | tr 'A-Z' 'a-z'`
for word in $Title
do
  dashedTitle=${dashedTitle}-${word}
done
# create note file
dateDashedTitle="`date +%Y-%m-%d`${dashedTitle}"
filename=$dateDashedTitle".md"
#filename="`date +%Y-%m-%d`${dashedTitle}.md"
touch $filename
echo "---" >> $filename
echo "note: ${note}" >> $filename
echo "---" >> $filename
echo "" >> $filename

# edit file
vi $filename
# site name = dir name
site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"

url="https://"$site"/notes/"$dateDashedTitle
shorty_url="https://"$site"/"$shorty
echo "\n\n"
echo $shorty_url" -> "$url
echo "\n\n"

# Publish? N to add [skip ci] in git commit message, so it won't deploy

# create url file
shorty_filename="$shorty.md"
urls_filename=../urls/$shorty_filename
touch $urls_filename
echo "---" >> $urls_filename
echo "url: ${url}" >> $urls_filename
echo "---" >> $urls_filename
echo "" >> $urls_filename

while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) git add $filename $urls_filename; git commit -m "new 1y note + shorty: /$dateDashedTitle -> $note" ; git push -u origin master ; break ;;
        [Nn]* ) git add $filename $urls_filename; git commit -m "new 1y note + shorty: /$dateDashedTitle -> $note [skip ci]" ; git push -u origin master ; break ;;
        * ) echo "Please answer yes or no.";;
    esac
done

## pause before add, commit, publish
#echo "Press <enter> to publish"
#read
## commit and publish
#git add $filename
#git commit -m "new 1y note: $site/$shorty -> $note"
#git push -u origin master


