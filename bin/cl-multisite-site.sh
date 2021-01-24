#!/bin/bash

# Publish immediately -- no [skip ci]                                
# clone posts from one or more sites to current site 
# from_site: receives all post from to_sites

# works with and without curly braces around sites
# bin/cl-multisite-site.sh '{pega.sus.codes,libra.waif.dev,san.jiao.ai,swerve.veer.fun}'

# works with shorty names `lucky-six-eve` 
# works with filenames with path `urls/lucky-six-eve.md`

# short url manager: https://github.com/nhoizey/1y

# from_site name = dir name
from_site=$(pwd | awk -F/ '{print $(NF)}') # now launched from repo root
#from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"
from_site_pwd=$(pwd)

if [ -n "$1" ]
then
    to_sites=$1
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
#echo "DEST:site: $site"
echo "DEST:from_site: $from_site"
echo "DEST: from_site_pwd: $from_site_pwd"
#echo "short arg: $shorty_files"
#echo "short list: $shorty_file_list"
echo "SRC: to_sites arg: $to_sites"
echo "SRC: to_sites list: $to_sites_list"
echo


from_site_dir=`pwd`

dest=$from_site
src_list=$to_sites_list


echo
echo "Copy all urls and notes from multiple 1y sites -> current 1y site"
echo "---"
echo "From: {$src_list}"
echo "To: $dest"
echo "---"
echo 

#set -x
#set +x
#press_base_dir="/home/george/Downloads/src/press/1y"
press_base_dir=".."

for to_sites_i in ${src_list//,/ }
do

  src_site_path=$press_base_dir/$to_sites_i
  dest_site_path=$press_base_dir/$dest
  echo
  echo "<< $to_sites_i >>"
  echo "---"
  echo
  echo ">> rsync files from $to_sites_i to $dest/{urls,notes}"
  echo
  cd $src_site_path
  rsync -avP --relative {notes,urls} $dest_site_path
  echo
  echo ">> pwd git add begin: $(pwd)"
  cd $dest_site_path
  git add notes/ urls/
  echo
  echo ">> pwd git add end: $(pwd)"
done

#echo "From: $from_site/{$shorty}"
#echo "To: {$to_sites}/{$shorty}"

cd $dest_site_path
echo
echo ">> pwd git commit and push begin: $(pwd)"
echo
git commit -m "From: {$src_list}/{notes,urls} / To: {$dest}/{notes,urls}"
git push -u origin master
echo
echo ">> pwd git commit and push end: $(pwd)"


