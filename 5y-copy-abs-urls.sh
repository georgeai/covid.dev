#!/bin/bash

# short url manager: https://github.com/nhoizey/1y

# Copy absolute URLs from 1y -> 1y site

# from_site name = dir name
from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"

if [ -n "$1" ]
then
    shorty=$1
else
  read -p "Enter the shorty [abc,def,ghi]: " shorty
fi

if [ -n "$2" ]
then
    to_site=$2
else
    read -p "To site: " to_site
fi

#if [ -n "$3" ]
#then
#    from_site=$3
#fi
##else
##    read -p "From site: " from_site
##fi

echo
echo "Copy absolute URLs from 1y -> 1y site"
echo "---"
echo "From: $from_site/{$shorty}"
echo "To: $to_site/{$shorty}"
echo "---"
echo 
#set -x
press_base_dir="~/Downloads/src/press/1y"

# https://stackoverflow.com/questions/27702452/loop-through-a-comma-separated-shell-variable
#variable=abc,def,ghij
#for i in $(echo $variable | sed "s/,/ /g")
#do
    # call your procedure/other scripts here below
    #echo "$i"
#done


#for i in $(echo $shorty | sed "s/,/ /g")
for shorty_i in ${shorty//,/ }
do
  shorty_file="$shorty_i.md"
  shorty_file_path="urls/$shorty_i.md"
  rsync -avP --relative $shorty_file_path ../$to_site/
  #rsync --dry-run -avP --relative $shorty_file_path ../$to_site/
  # use awk to grab rel note url and append md.
  rel_note_url=`awk 'FNR==2{print $2}' $shorty_file_path`
  #rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
  #note_file="${rel_note_url:1}.md"
  #note_file_path="${rel_note_url:1}.md" # no need to add `notes/` already in shorty

  url=$rel_note_url
  #url="https://$to_site/notes/${rel_note_url:1}"
  shorty_url="https://$to_site/$shorty_i"
  echo 
  echo $shorty_url" -> "$url
  echo 
done

#set +x


while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) cd ../$to_site; git add urls; git commit -m "repost 1y urls from $from_site/{$shorty} to $to_site/{$shorty} "; git push -u origin master ; break ;;
        [Nn]* ) cd ../$to_site; git add urls; git commit -m "repost 1y urls from $from_site/{$shorty} to $to_site/{$shorty} "; git push -u origin master ; break ;;
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


