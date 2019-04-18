#!/bin/bash

# Extracts the base URL from a github repository
extractUrl() {
	local URL="$1"

	# Make it look mighty fine
	PARSED=$(echo $URL | sed 's@\(http[s]*:\/\/github\.com\/[a-zA-Z]*\/[a-zA-Z]*\)[\/]*.*@\1@')

	echo $PARSED
}



if [[ "$#" -ne 2 ]]
then
	echo "usage: $0 <URL> <TARGET DIRECTORY>"
	exit 1
fi

# Extract the URL
URL="$1"
TARGET_DIR="$2"
TARGET_DIR=${TARGET_DIR%%/} # Strip off trailing slash
TEMP="temp"

if [[ ! -d $TARGET_DIR ]]; then
	mkdir $TARGET_DIR
fi

# Clean up the URL so it's ready for cloning
CLEANED=$(extractUrl "$URL")


# Download the file to <username>.zip
USER=$(echo $CLEANED | sed 's@[a-zA-Z]*:\/\/github\.com\/\([a-zA-Z]*\)\/\([a-zA-Z]*\)@\1_\2@' )

# Create a fresh target dir and final java file
TARGET_DIR="$TARGET_DIR/$USER"
if [[ -d $TARGET_DIR ]]; then
	rm -rf $TARGET_DIR
fi

mkdir $TARGET_DIR

ALLJAVA="$TARGET_DIR/alljava.txt"

touch $ALLJAVA


# Clone the repo into the temp directory
git clone $URL $TEMP # &>/dev/nul # add to suppress output

# extract all the sick nasty java files and build the final java file
find $TEMP -name '*.java' -not -path "*app/build*" -exec cat {} \; >"$ALLJAVA"

# Clean up after ourselves
rm -rf $TEMP

echo $ALLJAVA
