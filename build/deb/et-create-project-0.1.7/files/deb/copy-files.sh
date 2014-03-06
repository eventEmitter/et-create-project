#!bin/bash

# copy project files
cp -R lib/* "$PACKAGEDIR"

if [ -d "files" ]; then
	cp -R files "$PACKAGEDIR"
fi