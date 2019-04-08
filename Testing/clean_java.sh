#!/bin/bash

# This is where we remove a bunch of gunk in the java files
NOISE_PATTERNS="./noise.txt"

FILE="$1"
DESTINATION_FILE="$2"

# Make a backup of the input file
cp $FILE $DESTINATION_FILE

# Perform the necessary replacements
sed -i 's/[{}]//g' $DESTINATION_FILE
sed -i 's/^[[:blank:]]*\(.*\)$/\1/' $DESTINATION_FILE # Remove leading/trailing whitespace
sed -i '/^$/d' $DESTINATION_FILE
sed -i 's/\(.*\)/\L\1/g' $DESTINATION_FILE  

# Now we do the reverse grep on the silly patterns
TEMP="temp.txt"
grep -i -v -f $NOISE_PATTERNS $DESTINATION_FILE > $TEMP; mv $TEMP $DESTINATION_FILE

# Finally sort things to make our lives easier
sort -u $DESTINATION_FILE -o $DESTINATION_FILE
