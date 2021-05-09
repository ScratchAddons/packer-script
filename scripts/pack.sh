#!/bin/bash
cd $GITHUB_WORKSPACE

echo $(printf "Packing build for %s" $ENVIRONMENT)

node $GITHUB_ACTION_PATH/scripts/manifest.js
mkdir $GITHUB_WORKSPACE/.dist 2>/dev/null

VERSION_NAME=$(cat $GITHUB_WORKSPACE/manifest.json | jq -r ".version_name" | sed "s/[.-]/_/g;s/prerelease/pre/")
FILENAME=$(printf "%s-%s-scratchaddons.zip" $ENVIRONMENT $VERSION_NAME) 

git config user.email "73682299+scratchaddons-bot[bot]@users.noreply.github.com"
git config user.name "scratchaddons-bot[bot]"

git add .
git commit --no-gpg-sign -m $FILENAME

ZIP_PATH=$GITHUB_WORKSPACE/.dist/$FILENAME

git archive --format=zip -o $ZIP_PATH HEAD
unzip -d $GITHUB_WORKSPACE/.dist/extracted $ZIP_PATH
rm $ZIP_PATH
rm $GITHUB_WORKSPACE/manifest.json
mv $GITHUB_WORKSPACE/.manifest.json.bak $GITHUB_WORKSPACE/manifest.json

echo $(printf "::set-output name=filename::%s" $FILENAME)
echo $(printf "Filename is: %s" $FILENAME)