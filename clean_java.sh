#!/bin/bash

# This is where we remove a bunch of gunk in the java files
NOISE_PATTERNS="noise.txt"
LINE_NOISE="line_noise.txt"

if [[ "$#" -lt 2 ]]; then
  echo "usage: $0 <SOURCE FILE> <DESTINATION FILE>"
	exit 1
fi

FILE="$1"
DESTINATION_FILE="$2"

if [[ "$#" -eq 3 ]]; then
  PARENT_DIR="$3"
  PARENT_DIR=${PARENT_DIR%/[^/]*}
  NOISE_PATTERNS="$PARENT_DIR/$NOISE_PATTERNS" # Kind of ghetto navigate back but w/e
  LINE_NOISE="$PARENT_DIR/$LINE_NOISE"
fi

# Make a backup of the input file
cp $FILE $DESTINATION_FILE

# Perform the necessary replacements
sed -i 's/[{}]//g' $DESTINATION_FILE                              # Remove brackets
sed -i 's/^[[:blank:]]*\(.*\)[[:blank:]]*$/\1/' $DESTINATION_FILE             # Remove leading/trailing whitespace
sed -i 's/^[[:blank:]]*\*[[:blank:]]\(.*\)/\1/' $DESTINATION_FILE # convert javadoc lines to strings
sed -i '/^$/d' $DESTINATION_FILE                                  # Remove blank lines
sed -i 's/\(.*\)/\L\1/g' $DESTINATION_FILE                        # Lowercase

# Now we do the reverse grep on the silly patterns
TEMP="temp.txt"
grep -i -v -f $NOISE_PATTERNS $DESTINATION_FILE > $TEMP; mv $TEMP $DESTINATION_FILE

# Remove the lame lines
grep -i -x -v -f $LINE_NOISE $DESTINATION_FILE > $TEMP; mv $TEMP $DESTINATION_FILE

# Finally sort things to make our lives easier
sort $DESTINATION_FILE | sed "s/[[:blank:]]*$//" | uniq > $TEMP;  mv $TEMP $DESTINATION_FILE
