#!/bin/bash

# short url manager: https://github.com/nhoizey/1y

# from_site name = dir name
from_site="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd | sed 's#.*/##')"

if [ -n "$1" ]
then
    shorty=$1
else
    read -p "Enter the shorty: " shorty
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

set -x
press_base_dir="~/Downloads/src/press/1y"

#rsync -avP "$press_base_dir"/"$from_site"/urls/"$shorty".md "$press_base_dir"/"$to_site"/urls/

#var=$( cat foo.txt )
#note=$( cat "$press_base_dir/$from_site/notes/$shorty.md" )

# use awk to grab rel note url and append md.
rel_note_url=`awk 'FNR==2{print $2}' urls/${shorty}.md`
#rel_note_url=`awk 'FNR==2{print $2}' ${press_base_dir}/${from_site}/urls/${shorty}.md`
#rel_note_url=$(cat ${press_base_dir}/${from_site}/urls/${shorty}.md | awk 'FNR==2{print $2}')
# ${myString:1}
note_file="${rel_note_url:1}.md"
note_file_path="${rel_note_url:1}.md" # no need to add `notes/` already in shorty
#rsync -avP "$press_base_dir"/"$from_site"/notes/"$note_file" "$press_base_dir"/"$to_site"/notes/
shorty_file="$shorty.md"
shorty_file_path="urls/$shorty.md"

rsync -avP --relative $shorty_file_path $note_file_path ../$to_site/
#rsync -avP --relative urls/$shorty_file notes/$note_file ../$to_site/
# rsync -avP --relative urls/halloween-sandwich.md notes/2020-10-31-halloween-sandwich.md ../carat.ai/
#rsync -avP "$press_base_dir/$from_site/notes/$note_file $press_base_dir/$to_site/notes/"
#rsync -avP "$press_base_dir/$from_site/notes/$note_file $press_base_dir/$to_site/notes/"
set +x

url="https://$to_site/notes/${rel_note_url:1}"
shorty_url="https://$to_site/$shorty"
echo 
echo $shorty_url" -> "$url
echo 


while true; do
    read -p "Publish? N to add [skip ci] in git commit message: " yn
    case $yn in
        [Yy]* ) cd ../$to_site; git add $note_file_path $shorty_file_path ; git commit -m "repost 1y note from $from_site : $url and repost 1y shorty: $shorty_url"; git push -u origin master ; break ;;
        [Nn]* ) cd ../$to_site; git add $note_file_path $shorty_file_path ; git commit -m "repost 1y note  from $from_site: $url and repost 1y shorty: $shorty_url [skip ci]" ; git push -u origin master ; break ;;
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


