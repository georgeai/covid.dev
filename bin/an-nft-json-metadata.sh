#!/bin/bash

# an-nft-json-metadata.sh

# Creates post with json representation of NFT metadata
# in /nfts

# ref: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
# ref: https://forum.openzeppelin.com/t/create-an-nft-and-deploy-to-a-public-testnet-using-truffle/2961
# example:  http://my-json-server.typicode.com/abcoathup/samplenft/tokens/0

# {
#  "id": 0,
#  "description": "My NFT",
#  "external_url": "https://forum.openzeppelin.com/t/create-an-nft-and-deploy-to-a-public-testnet-using-truffle/2961",
#  "image": "https://twemoji.maxcdn.com/svg/1f40e.svg",
#  "name": "My NFT 0"
#}

# Uses $knot_shorty instead for external_url

# ---

from_site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
from_site_pwd=$(pwd)

if [ -n "$1" ]
then
    nft_name=$1
else
    read -p "name: " nft_name
fi

if [ -n "$2" ]
then
    description=$2
else
    read -p "description: " description
fi

if [ -n "$3" ]
then
    nft_image=$3
else
    read -p "nft_image: " nft_image
fi

if [ -n "$4" ]
then
    nft_id=$4
else
    read -p "nft_id: " nft_id
fi

if [ -n "$5" ]
then
    knot_shorty=$5
else
    read -p "external_url: " knot_shorty
fi

if [ -n "$6" ]
then
    bgimg=$6
else
    bgimg=""
fi

if [[ $bgimg =~ ^(http) ]] ; # use image url if given; otherwise use keyword
then 
  imgurl=$bgimg
#else # else use $bgimg=$5 keyword for unsplash; if $bgimg="" then random
elif [[ $bgimg =~ ^(random|Random|RANDOM)$ ]]; then
  imgurl="https://source.unsplash.com/random/1000/?"
else
  imgurl="https://source.unsplash.com/random/1000/?$bgimg"
fi

if [ -n "$7" ]
then
    shorty_files=$7
else
    shorty_files="NONE" # allow for no shortys
    #read -p "URL list: " shorty_files
fi

if [ -n "$8" ]
then
    category=$8
else
    category="nfts"
    #category="messages"
    #category="diagrams"
    #category="knots"
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
echo "5: $5"
echo "6: $6"
echo "7: $7"
echo "8: $8"
echo "from_site: $from_site"
echo "from_site_pwd: $from_site_pwd"
echo "short arg: $shorty_files"
echo "short list: $shorty_file_list"
echo "to_sites arg: $to_sites"
echo "to_sites list: $to_sites_list"
echo

if [[ ! $shorty_files =~ ^(NONE|none|NA|na)$ ]] ; # if shortys are added
then
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
  
  from_site_dir=`pwd`
  
  echo
  echo "Multiple existing urls from 1y -> knots (group of urls in a note)"
  echo "---"
  echo "From: $from_site/{$shorty}"
  echo "To: $from_site/{$knot_shorty}"
  echo "---"
  echo 
fi

#set -x
#set +x
#press_base_dir="/home/george/Downloads/src/press/1y"
notes_dir=$category
urls_dir="urls"

#for to_sites_i in ${to_sites_list//,/ }
#do

# Create dashedTitle from Title
Title=`echo $nft_name | tr '[:punct:]' ' ' | awk '{$1=$1};1' | tr '[:blank:]' '-' | tr -s '-' | tr 'A-Z' 'a-z'`
for word in $Title
do
  dashedTitle=${dashedTitle}-${word}
done
dateDashedTitle="`date +%Y-%m-%d`${dashedTitle}"
filename=$notes_dir/$dateDashedTitle".md"
touch $filename
echo "---" > $filename
echo "title: ${nft_name}" >> $filename
echo "note: ${description}" >> $filename
echo "imgurl: ${nft_image}" >> $filename
echo "id: ${nft_id}" >> $filename
knot_site=$(pwd | awk -F/ '{print $(NF)}') # repo root
knot_shorty_url="https://$knot_site/$knot_shorty"
echo "external_url: ${knot_shorty_url}" >> $filename
echo "---" >> $filename
#echo "" >> $filename

JSON_FMT='{\n"name": "%s",\n"description": "%s",\n"image": "%s",\n"id" :"%s",\n"external_url": "%s"\n}\n'
printf "$JSON_FMT" "${nft_name}" "${description}" "${nft_image}" "${nft_id}" "${knot_shorty_url}" >> $filename

if [[ ! $category =~ ^(hippos) ]] ; # always include for any category for now
then
  #. $(dirname "$0")/genchart.sh # include default mermaid chart 
  echo ""
  echo ""
fi

if [[ ! $knot_shorty =~ ^(NONE|none|NA|na)$ ]] ; # if shortys are added
then
  i=0 # count of urls
  
  for shorty_i in ${shorty//,/ }
  do
    i=$((i+1))
    echo "## $i" >> $filename
    echo "" >> $filename
    shorty_file="$shorty_i.md"
    shorty_file_path="$urls_dir/$shorty_i.md"
  
    # use awk to grab rel note url and append md
    note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
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
      echo "<a href='$note_url' target='_blank'>$note_url</a>" >> $filename
    fi
    echo "</p>" >> $filename
    echo "" >> $filename
    
  done
fi

vi +19 $filename

knot_site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
knot_url="https://$knot_site/$notes_dir/$dateDashedTitle"
knot_rel_url="/$notes_dir/$dateDashedTitle" # relative url -- for 1y site
knot_shorty_url="https://$knot_site/$knot_shorty"
echo
echo "New $category: "$knot_shorty_url" -> "$knot_rel_url
echo

# create url file
knot_shorty_filename="$knot_shorty.md"
urls_filename=$urls_dir/$knot_shorty_filename
touch $urls_filename
echo "---" > $urls_filename
echo "url: ${knot_rel_url}" >> $urls_filename
echo "---" >> $urls_filename
echo "" >> $urls_filename

while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) git add $filename $urls_filename; git commit -m "new 1y knot : $knot_url -> $description and new 1y knot shorty: $knot_shorty_url"; git push -u origin master ; break ;;
        [Nn]* ) git add $filename $urls_filename; git commit -m "new 1y knot : $knot_url -> $description and new 1y knot shorty: $knot_shorty_url [skip ci]" ; git push -u origin master ; break ;;
        * ) echo "Please answer yes or no.";;
    esac
done



