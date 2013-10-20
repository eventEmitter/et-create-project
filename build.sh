#!/bin/bash

PACKAGENAME=${PWD##*/}
VERSION=$(git describe)

# need the current git tag
if [ $? != 0 ]; then
	echo "failed to get latest git tag version!"
	exit 10
fi


# create packaging folder, exit if it exists
if [ ! -d "build" ]; then
	mkdir build
fi

# path to package build dir
PACKAGE="build/$PACKAGENAME-$VERSION"


# the target build dir must not exist
if [ ! -d "$PACKAGE" ]; then
	echo "package «$PACKAGE» was already created. remove the existing package or create a new git version using the git tag command!"
	exit 11
fi

#create package dir
#mkdir "$PACKAGE"

# copy project files
cp -R lib/* "$PACKAGE"

if [ -d "files" ]; then
	cp -R files "$PACKAGE"
fi



echo $PACKAGE
