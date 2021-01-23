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

#notes_dir="notes"
urls_dir="urls"

# create url file
filename="$urls_dir/$shorty.md"
touch $filename
echo "---" > $filename
echo "url: ${url}" >> $filename
echo "---" >> $filename
echo "" >> $filename

# edit file
#vi $filename

# site name = dir name
# site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"
# site=$(basename "`pwd`") -- works only in root directory and execting bin/
# site=$(pwd | awk -F/ '{print $(NF-1)}')
site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
echo
echo "site: $site"

#url="https://"$site"/notes/"$dateDashedTitle
shorty_url="https://$site/$shorty"
echo 
echo "$shorty_url -> $url"
echo 

# Publish? N to add [skip ci] in git commit message, so it won't deploy

while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) git add $filename; git commit -m "new 1y shorty: $shorty_url"; git push -u origin master ; break ;;
        [Nn]* ) git add $filename; git commit -m "new 1y shorty: $shorty_url [skip ci]" ; git push -u origin master ; break ;;
        #[Yy]* ) git add $filename ; git commit -m "new 1y url: /$shorty -> $url" ; git push -u origin master ; break ;;
        #[Nn]* ) git add $filename ; git commit -m "new 1y url: /$shorty -> $url [skip ci]" ; git push -u origin master ; break ;;
        * ) echo "Please answer yes or no.";;
    esac
done

## pause before add, commit, publish
# commit and publish
#git add $filename
#git commit -m "new 1y: $site/$shorty -> $url"
#git push -u origin master


