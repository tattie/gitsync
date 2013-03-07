#!/bin/bash

local_modified=0

sync-git()
{
# go to git root folder
cd "$1"
# need push ?
local_modified=0

if [ -n "`git ls-files -m`" ]
then
    local_modified=1
fi

# need pull ?
git fetch origin
# See if there are any incoming changes
if [ -n "`git log HEAD..origin/master --oneline`" ]
then
    if [ $local_modified -eq 0 ]
    then
	echo "$1: pulling..." && git pull && echo "pull done!"
    else
	echo "$1: both modified!!!"
    fi
else
    if [ $local_modified -eq 1 ]
    then
	echo "$1: local dirty! Please commit & push"
    fi
fi
cd - >> /dev/null
}

cd ../

for gitdir in config/*
do
    if [ -d "$gitdir" ]
    then
	# sync for this git repo
	sync-git $gitdir
    fi
done
