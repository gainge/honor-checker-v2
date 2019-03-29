#!/bin/bash

# This is where we remove a bunch of gunk in the java files
NOISE_PATTERNS="./noise.txt"

FILE="$1"
sed -i 's/[{}]//g' $FILE
sed -i 's/^[[:blank:]]*\(.*\)$/\1/' $FILE # Remove leading/trailing whitespace
sed -i '/^$/d' $FILE

# Now we do the reverse grep on the dumb patterns
TEMP="temp.txt"
grep -i -v -f $NOISE_PATTERNS $FILE > $TEMP; mv $TEMP $FILE
