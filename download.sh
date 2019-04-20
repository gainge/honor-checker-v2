#!/bin/bash

# Extracts the base URL from a github repository
extractUrl() {
	local URL="$1"

	# Make it look mighty fine
	PARSED=$(echo $URL | sed 's@\(http[s]*:\/\/github\.com\/[_[:alnum:]-]*\/[_[:alnum:]-]*\)[\/]*.*@\1@')

	echo $PARSED
}


# Check args
if [[ "$#" -ne 2 ]]; then
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
URL=$(extractUrl "$URL")

# Check to see if the repo exists
export GIT_ASKPASS
GIT_ASKPASS=true
git ls-remote "$URL" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
    echo "[ERROR] Repository '$URL' Does not exist, exiting"
    exit 1;
fi


# Download the file to <username>.zip
USER=$(echo $URL | sed 's@[a-zA-Z]*:\/\/github\.com\/\([_[:alnum:]-]*\)\/\([_[:alnum:]-]*\)@\1_\2@' )

# Create a fresh target dir and final java file
TARGET_DIR="$TARGET_DIR/$USER"
ALLJAVA="$TARGET_DIR/alljava.txt"

if [[ -f $ALLJAVA ]]; then
	echo $ALLJAVA
	exit 0 # Do nothing, it's already been made
fi

if [[ -d $TARGET_DIR ]]; then
	rm -rf $TARGET_DIR
fi

mkdir $TARGET_DIR
touch $ALLJAVA


# Clone the repo into the temp directory
git clone $URL $TEMP # &>/dev/nul # add to suppress output

if [[ -d $TEMP ]]; then
	# extract all the sick nasty java files and build the final java file
	find $TEMP -name '*.java' -not -path "*app/build*" -exec cat {} \; >"$ALLJAVA"

	# Clean up after ourselves
	rm -rf $TEMP

	echo $ALLJAVA
else
	echo "### Download failed! ###"
fi
