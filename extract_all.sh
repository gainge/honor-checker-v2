#!/bin/bash


STUDENT_CODE_DIR="student-code-directories"
TARGET_DIR=$STUDENT_CODE_DIR # Default output directory
# SEMESTER="winter2019"

if [[ "$#" -eq 0 ]]; then
  echo "usage: $0 <ZIPS> [TARGET DIRECTORY]"
	exit 1
fi

if [[ "$#" -ge 2 ]]; then
  TARGET_DIR=$2
else
  echo "No target directory specified, using [$TARGET_DIR]"
fi

echo "Processin Files in: '$1'"

# Remove whitespace from file names
for f in "$1"/*.zip; do mv "$f" "${f// /}" 2>/dev/null; done # Suppress output as well

for file in "$1"/*.zip;
do
  # Sanitize the input
  file=$(realpath -m --relative-to="${PWD}" $file)

  # Extract the code
  ./extract_java.sh "$file" "$TARGET_DIR"
done
echo "Done"
