#!/bin/bash

# STUDENT_CODE_DIR="student-code-directories"
# SEMESTER="winter2019"

if [[ "$#" -ne 2 ]]
then
	echo "usage: $0 <ZIP FILE> <TARGET DIRECTORY>"
	exit 1
fi

FILENAME="$1"
STUDENT_CODE_DIR="$2"

# Make sure our directoies are set
if [[ ! -d "$STUDENT_CODE_DIR" ]]
then
    mkdir "$STUDENT_CODE_DIR"
fi

# Extract the zip
echo "Extracting java source..."
EXTRACTED="temp/"
mkdir "$EXTRACTED"
unzip $FILENAME -d $EXTRACTED -x "*.jar" "*.html" "*.json" "*.zip" "*.css" ".class" ".xml" "app/src/main/res/*" "app/build/" &>/dev/null

# Strip off extension to get file name
NAME=$(echo $FILENAME | sed 's@\(.*\)\.zip@\1@' )

# Pull out only java files
ALLJAVA="$STUDENT_CODE_DIR/$NAME.txt"
find $EXTRACTED -name '*.java' -exec cat {} \; >"$ALLJAVA"

rm -rf "$EXTRACTED"

echo "Finished!"
