#!/bin/bash

getCleanedJava() {
  local DIR=$1
  local NETID=${DIR#$STUDENT_CODE_DIR/}
  local CLEANED_SOURCE="$DIR/$NETID.txt"

  echo $CLEANED_SOURCE
}

getNetID() {
  local DIR=$1
  local NETID=${DIR#$STUDENT_CODE_DIR/}
  echo $NETID
}

writeResultsHeader() {
  local OUTPATH=$1
  local -n REPO_DIRS=$2
  local -n STUDENT_DIRS=$3

  # Write out each repository
  local len=${#REPO_DIRS[@]}
  for ((i = 0; i < $len; ++i)) do
    local repo=${REPO_DIRS[$i]}

    echo -n "$repo," >> $OUTPATH
  done

  # Do the same for each student, in reverse order
  len=${#STUDENT_DIRS[@]}

  for ((i = $len - 1; i >= 0; --i)) do
    local NETID=$(getNetID ${STUDENT_DIRS[$i]})

    echo -n "$NETID," >> $OUTPATH
  done

  # Remove last traling comma
  truncate -s-1 $OUTPATH

  # End the header row
  echo -e "\n" >> $OUTPATH
}


STUDENT_CODE_DIR="student-code-directories"

REPOS=("asdf" "asdf") # TODO actually support repos for real
DIRECTORIES=( $(find $STUDENT_CODE_DIR -maxdepth 1 \( ! -name $STUDENT_CODE_DIR \) -type d) )
TOTAL=${#DIRECTORIES[@]}

# Create the spreadsheet to store our results
RESULTS="./results.csv"

if [[ -f $RESULTS ]]; then
  rm $RESULTS
fi

touch $RESULTS

# Write out the header for the results file
writeResultsHeader "$RESULTS" REPOS DIRECTORIES

for ((i = 0; i < $TOTAL; ++i)) do
  CURRENT_DIR=${DIRECTORIES[$i]}
  # Extract the NETID from the file path
  NETID=$(getNetID $CURRENT_DIR)
  CLEANED_SOURCE=$(getCleanedJava $CURRENT_DIR)
  echo $CLEANED_SOURCE
  echo "NETID: $NETID"
  echo "$i, $CURRENT_DIR"
  # TODO: Add support for the repositories directory and potentially other semesters

  for ((j = $TOTAL - 1; j > i; --j)) do
    echo -e "\t${DIRECTORIES[$j]}"
  done
done
