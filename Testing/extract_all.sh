#!/bin/bash


STUDENT_CODE_DIR="student-code-directories"
TARGET_DIR=$STUDENT_CODE_DIR # Default output directory
# SEMESTER="winter2019"

if [[ "$#" -eq 0 ]]; then
  echo "usage: $0 <ZIP FILE> [TARGET DIRECTORY]"
	exit 1
fi

if [[ "$#" -ge 2 ]]; then
  TARGET_DIR=$2
fi

for file in "$1"/*.zip;
do
  echo "Processing: [$file]"
  ./extract_java.sh $file $TARGET_DIR
  echo "Done"
done
