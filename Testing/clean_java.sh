#!/bin/bash

# This is where we remove a bunch of gunk in the java files
NOISE_PATTERNS="./noise.txt"

if [[ "$#" -ne 2 ]]; then
  echo "usage: $0 <SOURCE FILE> <DESTINATION FILE>"
	exit 1
fi

FILE="$1"
DESTINATION_FILE="$2"

# Make a backup of the input file
cp $FILE $DESTINATION_FILE

# Perform the necessary replacements
sed -i 's/[{}]//g' $DESTINATION_FILE                              # Remove brackets
sed -i 's/^[[:blank:]]*\(.*\)$/\1/' $DESTINATION_FILE             # Remove leading/trailing whitespace
sed -i 's/^[[:blank:]]*\*[[:blank:]]\(.*\)/\1/' $DESTINATION_FILE # convert javadoc lines to strings
sed -i 's/^[[:blank:]]*\*[[:blank:]]*$//' $DESTINATION_FILE       # Remove lines with only asterisks
sed -i 's/^[[:blank:]]*\/\*[[:blank:]]*$//' $DESTINATION_FILE     # Remove lines with only multiline comment header
sed -i 's/^[[:blank:]]*static[[:blank:]]*$//' $DESTINATION_FILE   # Remove random static lines I guess (?)
sed -i '/^$/d' $DESTINATION_FILE                                  # Remove blank lines
sed -i 's/\(.*\)/\L\1/g' $DESTINATION_FILE                        # Lowercase

# Now we do the reverse grep on the silly patterns
TEMP="temp.txt"
grep -i -v -f $NOISE_PATTERNS $DESTINATION_FILE > $TEMP; mv $TEMP $DESTINATION_FILE

# Finally sort things to make our lives easier
sort -u $DESTINATION_FILE -o $DESTINATION_FILE
