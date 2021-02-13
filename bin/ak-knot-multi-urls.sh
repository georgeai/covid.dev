#!/bin/bash

# Publish immediately -- no [skip ci]                                
# multi shorty -> knot (collection of urls)

# works with and without curly braces around short and sites
# ./ak-knot-multi-urls.sh <title> <note> <url> '{urls/lucky-six-eve.md,urls/soaring-stars.md,urls/finite-friday.md}' 

# works with shorty names `lucky-six-eve` 
# works with filenames with path `urls/lucky-six-eve.md`

# short url manager: https://github.com/nhoizey/1y

# from_site name = dir name
#from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"
#from_site=$(basename "`pwd`")
from_site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
from_site_pwd=$(pwd)

if [ -n "$1" ]
then
    title=$1
else
    read -p "Title: " title
fi

if [ -n "$2" ]
then
    knot_note=$2
else
    read -p "Note: " knot_note
fi

if [ -n "$3" ]
then
    knot_shorty=$3
else
    read -p "Shorty: " knot_shorty
fi

if [ -n "$4" ]
then
    shorty_files=$4
else
    read -p "URL list: " shorty_files
fi

if [ -n "$5" ]
then
    bgimg=$5
else
    bgimg=""
fi

#if [[ $imgurl == random* ]] ; # if random, then use unsplash as background
#if [[ $imgurl == none* ]] ; # if not none, then use unsplash as background
if [[ $imgurl == http* ]] ; # use image url
then 
  imgurl=$bgimg
else # else use $bgimg=$5 keyword for unsplash; if $bgimg="" then random
  imgurl="https://source.unsplash.com/random/1000/?$bgimg"
  # can't get the replace to work -- replaces quotes to html &quot
  #imgurl="https://source.unsplash.com/random/600/?{{ page.fileSlug | replace('-'', ','') }}"
fi

# remove curly braces if exists
shorty_file_list=$(echo "$shorty_files" | sed 's/[{}]//g')
#to_sites_list=$(echo "$to_sites" | sed 's/[{}]//g')

echo
echo "[Debug Info]"
echo "1: $1"
echo "2: $2"
echo "3: $3"
echo "4: $4"
echo "from_site: $from_site"
echo "from_site_pwd: $from_site_pwd"
echo "short arg: $shorty_files"
echo "short list: $shorty_file_list"
echo "to_sites arg: $to_sites"
echo "to_sites list: $to_sites_list"
echo

# create a list of comma separated shorty(s)
shorty=""
for shorty_file_i in ${shorty_file_list//,/ }
do
  shorty_file_i_basename=$(basename $shorty_file_i .md)
  shorty="$shorty,$shorty_file_i_basename"
  echo $shorty_file_i_basename
done
# remove initial comma from shorty
shorty=`echo $shorty | cut -c 2-`

# OLD - single shorty
#shorty=${shorty_file%.md}
#shorty=$(basename $shorty_file .md)

from_site_dir=`pwd`

echo
echo "Multiple existing urls from 1y -> knots (group of urls in a note)"
echo "---"
echo "From: $from_site/{$shorty}"
echo "To: $from_site/{$knot_shorty}"
echo "---"
echo 

#set -x
#set +x
press_base_dir="/home/george/Downloads/src/press/1y"
notes_dir="knots"
urls_dir="urls"

#for to_sites_i in ${to_sites_list//,/ }
#do

# Create dashedTitle from Title
Title=`echo $title | tr '[:punct:]' ' ' | awk '{$1=$1};1' | tr '[:blank:]' '-' | tr -s '-' | tr 'A-Z' 'a-z'`
for word in $Title
do
  dashedTitle=${dashedTitle}-${word}
done
dateDashedTitle="`date +%Y-%m-%d`${dashedTitle}"
filename=$notes_dir/$dateDashedTitle".md"
touch $filename
echo "---" > $filename
echo "title: ${title}" >> $filename
echo "note: ${knot_note}" >> $filename
echo "imgurl: ${imgurl}" >> $filename
echo "---" >> $filename
echo "" >> $filename
echo "" >> $filename

i=0 # count of urlts

for shorty_i in ${shorty//,/ }
do
  i=$((i+1))
  echo "## $i" >> $filename
  echo "" >> $filename
  shorty_file="$shorty_i.md"
  shorty_file_path="urls/$shorty_i.md"

  # use awk to grab rel note url and append md
  note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
  #rel_note_url=`awk 'FNR==2{print $2}' $shorty_file_path`
  #url="https://$to_sites_i/${rel_note_url:1}"
  url=$note_url
  shorty_url="https://$from_site/$shorty_i"
  # debug echo
  echo
  #echo "<< $to_sites_i >>"
  echo "---"
  echo $shorty_url" -> "$url
  echo $note_url
  echo "---"
  
  # write shorty and long url to knots file
  #echo "[$shorty_i]($shorty_url)" >> $filename
  echo "<p class='smallcapsurl'>" >> $filename
  echo "<a href='$shorty_url' target='_blank'>$shorty_i</a>" >> $filename
  echo "</p>" >> $filename
  echo "<p class='tiny'>" >> $filename
  #if [[ $note_url =~ ^\/* ]] ; # rel url, add https://site/$note_url
  if [[ $note_url == /* ]] ; # rel url, add https://site/$note_url
  then
    #echo "`https://$from_site/$note_url`" >> $filename
    echo "<a href='$note_url' target='_blank'>https://$from_site$note_url</a>" >> $filename
  else # abs url, just use the url
    #echo "`$note_url`" >> $filename
    echo "<a href='$note_url' target='_blank'>$note_url</a>" >> $filename
  fi
  #echo "[$url]($url)" >> $filename
  echo "</p>" >> $filename
  echo "" >> $filename
  
  #echo
  #echo ">> rsync files $shorty_file_path $press_base_dir/$to_sites_i/"
  #echo
  #set -x
  #rsync -avP --relative $shorty_file_path $press_base_dir/$to_sites_i/
done

vi +9 $filename

knot_site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
knot_url="https://$knot_site/$notes_dir/$dateDashedTitle"
knot_rel_url="/$notes_dir/$dateDashedTitle" # relative url -- for 1y site
knot_shorty_url="https://$knot_site/$knot_shorty"
echo
echo "New Knot: "$knot_shorty_url" -> "$knot_rel_url
echo

# create url file
knot_shorty_filename="$knot_shorty.md"
urls_filename=$urls_dir/$knot_shorty_filename
touch $urls_filename
echo "---" > $urls_filename
echo "url: ${knot_rel_url}" >> $urls_filename
#echo "url: ${url}" >> $urls_filename
echo "---" >> $urls_filename
echo "" >> $urls_filename

#echo "From: $from_site/{$shorty}"
#echo "To: {$to_sites}/{$shorty}"

# Publish? N to add [skip ci] in git commit message, so it won't deploy

while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) git add $filename $urls_filename; git commit -m "new 1y knot : $knot_url -> $knot_note and new 1y knot shorty: $knot_shorty_url"; git push -u origin master ; break ;;
        [Nn]* ) git add $filename $urls_filename; git commit -m "new 1y knot : $knot_url -> $knot_note and new 1y knot shorty: $knot_shorty_url [skip ci]" ; git push -u origin master ; break ;;
        * ) echo "Please answer yes or no.";;
    esac
done

#cd $press_base_dir/$to_sites_i 
#echo
#echo ">> pwd git commit and push begin: $(pwd)"
#echo
#git commit -m "From: $from_site/{$shorty} / To: {$to_sites}/{$shorty}"
#git push -u origin master
##cd ../$from_site
#cd $from_site_pwd
#echo
#echo ">> pwd git commit and push end: $(pwd)"

#done #to_sites for loop

## pause before add, commit, publish
#echo "Press <enter> to publish"
#read
## commit and publish
#git add $filename
#git commit -m "new 1y note: $site/$shorty -> $note"
#git push -u origin master


