#!/bin/bash


STUDENT_CODE_DIR="student-code-directories"
# SEMESTER="winter2019"

for file in "$1"/*.zip;
do
  echo "Processing: [$file]"
  ./extract_java.sh $file $STUDENT_CODE_DIR
  echo "Done"
done
