#!/bin/bash
cd $GITHUB_WORKSPACE

echo $(printf "Packing build for %s" $ENVIRONMENT)

node $GITHUB_ACTION_PATH/scripts/manifest.js
mkdir $GITHUB_WORKSPACE/.dist 2>/dev/null

VERSION_NAME=$(cat $GITHUB_WORKSPACE/manifest.json | jq -r ".version_name" | sed "s/[.-]/_/g;s/prerelease/pre/")
FILENAME=$(printf "ScratchAddons-%s-%s.zip" $VERSION_NAME $ENVIRONMENT) 

git archive --format=zip -o $GITHUB_WORKSPACE/.dist/$FILENAME HEAD
rm $GITHUB_WORKSPACE/manifest.json
mv $GITHUB_WORKSPACE/.manifest.json.bak $GITHUB_WORKSPACE/manifest.json

echo $(printf "Packed as %s" $FILENAME)