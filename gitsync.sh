#!/bin/bash

local_modified=0

sync-git()
{
echo "for repo $1:"
# go to git root folder

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
	git pull && echo "pull done!"
    else
	echo "both modified!!!"
    fi
else
    if [ $local_modified -eq 1 ]
    then
	echo "local dirty! Please commit & push"
    else
	echo "up to date, do nothing."
    fi
fi
}

cd ../

for gitdir in config/*
do
    if [ -d "$gitdir" ]
    then
	cd $gitdir
	# call handle
	sync-git $gitdir
	cd ../../
    fi
done
