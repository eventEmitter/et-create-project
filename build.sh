#!/bin/bash

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
PACKAGE="build/$VERSION"

echo $PACKAGE
echo $VERSION

# create the build dir if it not already exists
if [ -d "$PACKAGE" ]; then
	echo "package $VERSION was already created. remove the existing package or create a new git version using the git tag command!"
	exit 11
fi


echo $VERSION
