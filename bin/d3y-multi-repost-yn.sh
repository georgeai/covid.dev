#!/bin/bash

# short url manager: https://github.com/nhoizey/1y

# from_site name = dir name
from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"

if [ -n "$1" ]
then
    shorty_file=$1
else
    read -p "Enter the shorty: " shorty
fi

if [ -n "$2" ]
then
    to_sites=$2
else
    read -p "To site: " to_sites
fi

#if [ -n "$3" ]
#then
#    from_site=$3
#fi
##else
##    read -p "From site: " from_site
##fi

#shorty=${shorty_file%.md}
shorty=$(basename $shorty_file .md)

echo
echo "Copy one note from 1y -> multiple 1y sites"
echo "---"
echo "From: $from_site/$shorty"
echo "To: {$to_sites}/$shorty"
echo "---"
echo 

#set -x
#set +x
press_base_dir="~/Downloads/src/press/1y"

# NEW - use awk to grab rel note url and append md.
rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty}.md`
# OLD - use awk to grab rel note url and append md.
#rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty}.md`
note_file_path="${rel_note_url:1}.md" # no need to add `notes/` already in shorty
#shorty_file="$shorty.md"
shorty_file_path="urls/$shorty.md"

for to_sites_i in ${to_sites//,/ }
do
  rsync -avP --relative $shorty_file_path $note_file_path ../$to_sites_i/

  url="https://$to_sites_i/${rel_note_url:1}"
  shorty_url="https://$to_sites_i/$shorty"
  echo 
  echo $shorty_url" -> "$url
  echo 

  while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) cd ../$to_sites_i; git add $note_file_path $shorty_file_path ; git commit -m "repost 1y note from $from_site : $url and repost 1y shorty: $shorty_url"; git push -u origin master ; break ;;
        [Nn]* ) cd ../$to_sites_i; git add $note_file_path $shorty_file_path ; git commit -m "repost 1y note  from $from_site: $url and repost 1y shorty: $shorty_url [skip ci]" ; git push -u origin master ; break ;;
        * ) echo "Please answer yes or no.";;
    esac
  done
done

## pause before add, commit, publish
#echo "Press <enter> to publish"
#read
## commit and publish
#git add $filename
#git commit -m "new 1y note: $site/$shorty -> $note"
#git push -u origin master


