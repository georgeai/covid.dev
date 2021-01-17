#!/bin/bash

# Publish immediately -- no [skip ci]                                
# multi shorty -> multi site repost

# works with and without curly braces around short and sites
# ./e3y-multi-repost.sh '{urls/lucky-six-eve.md,urls/soaring-stars.md,urls/finite-friday.md}' '{pega.sus.codes,libra.waif.dev,san.jiao.ai,swerve.veer.fun}'

# works with shorty names `lucky-six-eve` 
# works with filenames with path `urls/lucky-six-eve.md`

# short url manager: https://github.com/nhoizey/1y

# from_site name = dir name
#from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"
from_site=$(basename "`pwd`")
from_site_pwd=$(pwd)

if [ -n "$1" ]
then
    shorty_files=$1
else
    read -p "Enter the shorty: " shorty_files
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

# remove curly braces if exists
shorty_file_list=$(echo "$shorty_files" | sed 's/[{}]//g')
to_sites_list=$(echo "$to_sites" | sed 's/[{}]//g')

echo
echo "1: $1"
echo "2: $2"
echo "3: $3"
#echo "from_site: $from_site"
echo "from_site_pwd: $from_site_pwd"
echo "short arg: $shorty_files"
echo "short list: $shorty_file_list"
echo "to_sites arg: $to_sites"
echo "to_sites list: $to_sites_list"
echo

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
echo "Copy one note from 1y -> multiple 1y sites"
echo "---"
echo "From: $from_site/{$shorty}"
echo "To: {$to_sites_list}/{$shorty}"
echo "---"
echo 

#set -x
#set +x
press_base_dir="/home/george/Downloads/src/press/1y"

for to_sites_i in ${to_sites_list//,/ }
do

for shorty_i in ${shorty//,/ }
do
  shorty_file="$shorty_i.md"
  shorty_file_path="urls/$shorty_i.md"
  #rsync -avP --relative $shorty_file_path ../$to_site_i/

#  # NEW - use awk to grab rel note url and append md.
#  rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
#  # OLD - use awk to grab rel note url and append md.
#  #rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
#  note_file_path="${rel_note_url:1}.md" # no need to add `notes/` already in shorty
#  shorty_file_path="urls/$shorty_i.md"

  # absolute urls, not relative urls
  note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
  #rel_note_url=`awk 'FNR==2{print $2}' $shorty_file_path`
  #url="https://$to_sites_i/${rel_note_url:1}"
  url=$note_url
  shorty_url="https://$to_sites_i/$shorty_i"
  echo
  echo "<< $to_sites_i >>"
  echo "---"
  echo $shorty_url" -> "$url
  echo "---"

  echo
  echo ">> rsync files $shorty_file_path $press_base_dir/$to_sites_i/"
  echo
  
  #set -x
  rsync -avP --relative $shorty_file_path $press_base_dir/$to_sites_i/

  cd $press_base_dir/$to_sites_i 
  echo
  echo ">> pwd git add begin: $(pwd)"
  git add $shorty_file_path
  #cd ../$from_site
  cd $from_site_pwd
  echo
  echo ">> pwd git add end: $(pwd)"
  #set +x
done

#echo "From: $from_site/{$shorty}"
#echo "To: {$to_sites}/{$shorty}"

cd $press_base_dir/$to_sites_i 
echo
echo ">> pwd git commit and push begin: $(pwd)"
echo
git commit -m "From: $from_site/{$shorty} / To: {$to_sites}/{$shorty}"
git push -u origin master
#cd ../$from_site
cd $from_site_pwd
echo
echo ">> pwd git commit and push end: $(pwd)"

done

## pause before add, commit, publish
#echo "Press <enter> to publish"
#read
## commit and publish
#git add $filename
#git commit -m "new 1y note: $site/$shorty -> $note"
#git push -u origin master


