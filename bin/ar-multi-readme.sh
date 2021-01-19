#!/bin/bash

# Use repo README.md as blog, by prepending (latest) posts to README.md
# Can do multiple file prepends a once (for same repo) 
# Defaults to README.md

# Publish immediately -- no [skip ci]                                
# multi shorty -> multi file prepend (eg, README.md)

# works with and without curly braces around short and sites (files)

# from repo root, run using relative path of urls files

# bin/ar-multi-readme.sh urls/lucky-six-eve.md,urls/soaring-stars.md,urls/finite-friday.md README.md,blog.md

# - or - just use url shortcut without file extensions

# bin/ar-multi-readme.sh lucky-six-eve,soaring-stars,finite-friday README.md,blog.md

# works with shorty names `lucky-six-eve` 
# works with filenames with path `urls/lucky-six-eve.md`

# github / gitea username
git_username="george"
git_branch_src="src/branch/master"
git_branch_raw="raw/branch/master"
git_remote_orgin_url=$(git config --get remote.origin.url)

# from_site name = dir name
from_site_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"
from_site=$(pwd | sed 's#.*/##')

# from_site entire path
from_site_pwd=$(pwd)

if [ -n "$1" ]
then
    shorty_files=$1
else
    read -p "Enter the shorty: " shorty_files
fi

if [ -n "$2" ]
then
    to_sites=$2 # to_sites = files to prepend with notes / posts
else
    #read -p "To site: " to_sites
    to_sites="README.md" # default 
fi

# trim white space and remove curly braces if exists
shorty_file_list=$(echo "$shorty_files" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed 's/[{}]//g')
to_sites_list=$(echo "$to_sites" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed 's/[{}]//g')

echo
echo "1: $1"
echo "2: $2"
echo "3: $3"
#echo "from_site: $from_site"
echo "git username: $git_username"
echo "git remote origin url: $git_remote_orgin_url"
echo "from_site: $from_site"
echo "from_site_pwd: $from_site_pwd"
echo "short arg: $shorty_files"
echo "short list: $shorty_file_list"
echo "to_sites (files to prepend) arg: $to_sites"
echo "to_sites (files to prepend) list: $to_sites_list"
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
  # NEW - use awk to grab rel note url and append md.
  rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
  # OLD - use awk to grab rel note url and append md.
  #rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty_i}.md`
  note_file_path="${rel_note_url:1}.md" # no need to add `notes/` already in shorty
  shorty_file_path="urls/$shorty_i.md"

  url="https://$to_sites_i/${rel_note_url:1}"
  shorty_url="https://$to_sites_i/$shorty_i"
  #echo
  #echo "<< PREPEND $to_sites_i >>"
  #echo "---"
  #echo $note_file_path" -> "$to_sites_i
  #echo "---"

  echo
  echo ">> prepend $note_file_path -> $to_sites_i using sed"
  #echo "$git_remote_orgin_url"
  echo "/$git_username/$from_site/$git_branch_src/$note_file_path"
  echo "/$git_username/$from_site/$git_branch_raw/$note_file_path"
  echo
  #sed -i.old -e '1r2021-01-18-sunday-gitea.md' -e '1{h;d}' -e '2{x;G}' README.md
  #sed -i.old -e "1i## $note_file_path" -e "1r$note_file_path" -e '1{h;d}' -e '2{x;G}' $to_sites_i
  #sed -i.old -e "1i## :bookmark:" -e "1i \`$note_file_path\`" -e "1r$note_file_path" -e '1{h;d}' -e '2{x;G}' $to_sites_i
  #sed -i.old -e "1i### :bookmark: \`$note_file_path\`" -e "1r$note_file_path" -e '1{h;d}' -e '2{x;G}' $to_sites_i
  sed -i.old -e "1i#### :bookmark: [\`$note_file_path\`](/$git_username/$from_site/$git_branch_src/$note_file_path) / :nut_and_bolt: [[Raw](/$git_username/$from_site/$git_branch_raw/$note_file_path)]" -e "1r$note_file_path" -e '1{h;d}' -e '2{x;G}' $to_sites_i

  ##echo ">> rsync files $shorty_file_path $note_file_path $press_base_dir/$to_sites_i/"
  ##echo
  ##rsync -avP --relative $shorty_file_path $note_file_path $press_base_dir/$to_sites_i/

done
  ##cd $press_base_dir/$to_sites_i 
  echo
  echo ">> pwd git add begin: $(pwd)"
  git add $to_sites_i
  ##git add $note_file_path $shorty_file_path
  ##cd ../$from_site
  ##cd $from_site_pwd
  echo
  echo ">> pwd git add end: $(pwd)"

done

#cd $press_base_dir/$to_sites_i 
echo
echo ">> pwd git commit and push begin: $(pwd)"
echo
git commit -m "PREPEND: {$shorty} / TO: {$to_sites_i} [skip ci]"
git push -u origin master
##cd ../$from_site
##cd $from_site_pwd
echo
echo ">> pwd git commit and push end: $(pwd)"

