#!/usr/bin/env bash

sync-git()
{
# go to git root folder
cd "$1" || { echo "failed to enter folder: $1!!!" >&2; exit 1;  }

[[ ! -d ./.git ]] && { echo "NOT a git repo!!" >&2; cd - > /dev/null; exit 1; }
# need push ?
declare -i local_modified=0
[[ -n "`git ls-files -m`" ]] && local_modified=1

# need pull ?
git fetch -q origin  || { echo "$1: fetch failed!!!" >&2; cd - > /dev/null; exit 1; }
# See if there are any incoming changes
if [[ -n "`git log HEAD..origin/master --oneline`" ]]
then
    if (( local_modified == 0 ))
    then
	echo "$1: pulling..." && git pull && echo "pull done!"
    else
	echo "$1: both modified!!!"
    fi
else
    (( local_modified == 1 )) && echo "$1: local dirty! Please commit & push"
fi
cd - > /dev/null
}

cd ../

for gitdir in config/*
do
    [[ -d "$gitdir" ]] && sync-git $gitdir 	# sync for this git repo
done
