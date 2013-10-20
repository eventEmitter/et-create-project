#!/bin/bash

PACKAGENAME=${PWD##*/}
TARGETDIR="bin/deb"
BUILDVARS="build/build-vars.sh"
FILECOPY="build/copy-files.sh"
PACKAGECLASS="s"

	
# check for git
GITVERSION=$(git --version)

if [ $? != 0 ]; then
	echo "git is required for this application, please install it using «sudo apt-get install git-core»"
	exit 10
fi

# check for dh_make
GITVERSION=$(dh_make --version)

if [ $? != 0 ]; then
	echo "dh_make is required for this application, please install it using «sudo apt-get install dh-make»"
	exit 10
fi


VERSION=$(git describe)

# need the current git tag
if [ $? != 0 ]; then
	echo "failed to get latest git tag version!"
	exit 10
fi


# create packaging folder, exit if it exists
if [ ! -d $TARGETDIR ]; then
	mkdir -p "$TARGETDIR"
fi

# path to package build dir
PACKAGE="$PACKAGENAME-$VERSION"
PACKAGEDIR="$TARGETDIR/$PACKAGE"


# the target build dir must not exist
if [ ! -d "$PACKAGEDIR" ]; then
	echo "package «$PACKAGE» was already created. remove the existing package or create a new git version using the git tag command!"
	exit 11
fi

#create package dir
#mkdir "$PACKAGEDIR"

if [ $? != 0 ]; then
	echo "failed to create target dir for dep packaging!"
	exit 10
fi

# get variables required for package building
. $BUILDVARS

# copy files to targetdir
. $FILECOPY


# create tar gz fromdirectory
tar -cvzf "$TARGETDIR/$PACKAGE.tar.gz" "$PACKAGEDIR/"
mv "$TARGETDIR/$PACKAGE.tar.gz" "$PACKAGEDIR/"

## goto folder
cd "$PACKAGEDIR"


# run dh_make
dh_make -e $EMAIL -c $LICENCE -f "$PACKAGEDIR/$PACKAGE.tar.gz" -C $PACKAGECLASS




echo $PACKAGE
