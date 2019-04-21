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
NETID=$(echo $NETID | sed 's/[[:blank:][:space:]]//g' )
PARTS=(${NETID//\// })
NETID=${PARTS[-1]}
NETID=${NETID##.*/}
NETID=${NETID%%/*}
PARTS=(${NETID//_/ })
NETID=${PARTS[2]}

# Make sure our directoies are set
if [[ ! -d "$STUDENT_CODE_DIR" ]]
then
    mkdir "$STUDENT_CODE_DIR"
fi

FULL_STUDENT_DIR="$STUDENT_CODE_DIR/$NETID"
ALLJAVA="$FULL_STUDENT_DIR/alljava.txt"

if [[ -f $ALLJAVA ]]; then
	echo -e "\tFile [$ALLJAVA] already exists, exiting..."
	exit 1
fi

# Make a clean slate for file system
rm -rf "$FULL_STUDENT_DIR"
mkdir "$FULL_STUDENT_DIR"

touch $ALLJAVA

# Extract the zip as java source only
echo "Extracting java source... [NetID: $NETID]"
EXTRACTED="temp/"
mkdir "$EXTRACTED"
unzip "$FILENAME" -d "$EXTRACTED" -x "*.jar" "*.html" "*.json" "*.zip" "*.css" "*.class" "*.xml" "*.png" "**/app/src/main/res/*" "**/app/build/*" "**/.gradle/*" "**/app/src/debug/*" &>/dev/null

# Pull out only java files
find $EXTRACTED -name '*.java' -exec cat {} \; >"$ALLJAVA"

rm -rf "$EXTRACTED"

echo -e "\tExtracted to [$ALLJAVA]"
