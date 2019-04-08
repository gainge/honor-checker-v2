#!/bin/bash

# STUDENT_CODE_DIR="student-code-directories"
# SEMESTER="winter2019"
# TODO: integrate semester tracking when making directories

if [[ "$#" -ne 2 ]]
then
	echo "usage: $0 <ZIP FILE> <TARGET DIRECTORY>"
	exit 1
fi

FILENAME="$1"
STUDENT_CODE_DIR="$2"

# extract the netID from the file
NETID=${FILENAME%.*}
NETID=${NETID%_[a-zA-Z]*}
NETID=${NETID##[a-zA-Z]*_}

# Make sure our directoies are set
if [[ ! -d "$STUDENT_CODE_DIR" ]]
then
    mkdir "$STUDENT_CODE_DIR"
fi

FULL_STUDENT_DIR="$STUDENT_CODE_DIR/$NETID"
ALLJAVA="$FULL_STUDENT_DIR/original_$NETID.txt"
CLEANED="$FULL_STUDENT_DIR/$NETID.txt"

# Make a clean slate for file system
rm -rf "$FULL_STUDENT_DIR"
mkdir "$FULL_STUDENT_DIR"

touch $ALLJAVA
touch $CLEANED

# Extract the zip as java source only
echo "Extracting java source..."
EXTRACTED="temp/"
mkdir "$EXTRACTED"
unzip $FILENAME -d $EXTRACTED -x "*.jar" "*.html" "*.json" "*.zip" "*.css" ".class" ".xml" "app/src/main/res/*" "app/build/" &>/dev/null

# Pull out only java files
find $EXTRACTED -name '*.java' -exec cat {} \; >"$ALLJAVA"

rm -rf "$EXTRACTED"

# Clean the extracted code
./clean_java.sh $ALLJAVA $CLEANED

echo "Finished!"
