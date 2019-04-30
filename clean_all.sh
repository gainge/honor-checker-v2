#!/bin/bash


usage() {
  echo "usage: $0 <PARENT DIRECTORY> [NOISE DIRECTORY]"
}


if [[ "$#" -eq 0 ]]; then
  usage
	exit 1
fi

PARENT_DIR=$1
NOISE_DIR="./"    # init as current directory as default
# Clean the input
PARENT_DIR=${PARENT_DIR%%/}

if [[ ! -d $PARENT_DIR ]]; then
  echo "Directory: $PARENT_DIR does not exist.  Exiting..."
  usage
  exit 1
fi

# Attempt to retrieve the noise directory
shift # Shift ops down
if [[ "$#" -ge 1 ]]; then
	NOISE_DIR="$1"
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
    ./clean_java.sh "$ALLJAVA" "$CLEANED" "$NOISE_DIR"
  fi

done
