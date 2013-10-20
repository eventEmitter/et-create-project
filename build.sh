#!/bin/bash

PACKAGENAME=${PWD##*/}
TARGETDIR="build/deb"
CURRENT=$PWD
BUILD="build"
BUILDVARS="$BUILD/build-vars.sh"
FILECOPY="$BUILD/copy-files.sh"
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
if [ -d "$PACKAGEDIR" ]; then
	echo "package «$PACKAGE» was already created. remove the existing package or create a new git version using the git tag command!"
	exit 11
fi

#create package dir
mkdir "$PACKAGEDIR"

if [ $? != 0 ]; then
	echo "failed to create target dir for dep packaging!"
	exit 12
fi

# get variables required for package building
. $BUILDVARS

# copy files to targetdir
echo "copying files ..."
. $FILECOPY


echo "moving into package directory «$TARGETDIR .."
cd "$TARGETDIR"

# create tar gz fromdirectory
echo "packing sources ...."
tar -cvzf "$PACKAGE.tar.gz" "$PACKAGE/"
mv "$PACKAGE.tar.gz" "$PACKAGE/"


## goto folder
echo "moving into package directory «$PACKAGE .."
cd "$PACKAGE"



# run dh_make
echo "preparing dep package ..."
dh_make -e "$EMAIL" -c "$LICENCE" -f "$PACKAGE.tar.gz" -C "$PACKAGECLASS" --yes

# remove tarball
rm "$PACKAGE.tar.gz"


# remove example files
echo "removing unused & example files ...."
rm debian/*.ex 2> /dev/null
rm debian/*.Ex 2> /dev/null
rm debian/*.EX 2> /dev/null
rm debian/README.* 2> /dev/null


# go back to original dir
echo "switching back to project dir «$CURRENT» ..."
cd "$CURRENT"

# copy project specific files
echo "copying build files into package dir ..."
chmod 755 "$BUILD/debian/rules" 
cp $BUILD/debian/* "$PACKAGEDIR/debian"

echo "-------------------"
echo "preparations finished! please check the generated files in the «bin/dep» directory. Build you package usgin the «debuild -S -sd» or «debuild -S -sa» command!"
echo "upload your package using the «dput ppa:yourLaunchpadID/ppa projectnmae_version_source.changes» command."