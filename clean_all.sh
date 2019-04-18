#!/bin/bash

if [[ "$#" -ne 1 ]]; then
  echo "usage: $0 <PARENT DIRECTORY>"
	exit 1
fi

PARENT_DIR=$1
# Clean the input
# PARENT_DIR=$(echo $PARENT_DIR | cut -d/ -f1) # Why did I want to do this?
PARENT_DIR=${PARENT_DIR%%/}

if [[ ! -d $PARENT_DIR ]]; then
  echo "Directory: $PARENT_DIR does not exist.  Exiting..."
  exit 1
fi

# Loop over all subdirectories and clean the java file
DIRECTORIES=( $(find $PARENT_DIR -maxdepth 1 \( ! -wholename $PARENT_DIR \) -type d) )
len=${#DIRECTORIES[@]}

for ((i = 0; i < $len; ++i)) do
  CURRENT_DIR=${DIRECTORIES[i]}
  ALLJAVA="$CURRENT_DIR/alljava.txt"

  # Guard against files that aren't there
  if [[ ! -f $ALLJAVA ]]; then
    echo "File: $ALLJAVA not found, skipping"
  else
    # Otherwise, clean things regularly
    echo "Cleaning Source File: $ALLJAVA"
    CLEANED="$CURRENT_DIR/cleaned.txt"
    ./clean_java.sh "$ALLJAVA" "$CLEANED" "$PARENT_DIR"
  fi

done
