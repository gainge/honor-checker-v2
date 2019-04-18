#!/bin/bash

getCleanedJava() {
  local DIR=$1
  # Lol we actually don't need this anymore either
  local PARENT=$(echo $DIR | cut -d/ -f1)
  # Netid is no longer necessary, as all cleaend java files are uniformly named
  # local NETID=${DIR#$PARENT/}
  local CLEANED_SOURCE="$DIR/cleaned.txt"

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

  # Write the legend/key
  echo -n "NetID/Comparison," >> $OUTPATH

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
  echo -ne "\n" >> $OUTPATH
}

getMatches() {
  local FILE1=$1
  local FILE2=$2

  # Check the matches
  local MATCHES=$(./compare_java.sh "$FILE1" "$FILE2")

  echo $MATCHES
}

getNumMatches() {
  local FILE1=$1
  local FILE2=$2

  # Check the match count using our comparison script
  local NUM_MATCHES=$(./compare_java.sh "-c" "$FILE1" "$FILE2")

  echo $NUM_MATCHES
}

compareFiles() {
  local RESULTS=$1
  local FILE1=$2
  local FILE2=$3

  # Compare the files
  # local MATCHES=$(getMatches $FILE1 $FILE2)
  # local NUM_MATCHES=$(echo "$MATCHES" | wc -l)
  local NUM_MATCHES=$(getNumMatches $FILE1 $FILE2)

  # Write the number to the output file, and the total matches to the output dir
  # I might hold off on the dir for now though
  # TODO: Eventually someday log the matches as well?
  #       Or just give instructions for comparison at the end?
  #       Yeah I like that a lot better.
  #         I'll just bust out a script that compares two files
  echo -n "$NUM_MATCHES," >> $RESULTS
}


STUDENT_CODE_DIR="student-code-directories"
REPO_DIR="repos"
RESULT_DIR="./results"

# Attempt to overwrite defaults
if [[ "$#" -eq 3 ]]; then
  STUDENT_CODE_DIR="$1"
  REPO_DIR="$2"
  RESULT_DIR="$3"
fi

# Find all entries in each directory, repos and students
REPOS=( $(find $REPO_DIR -maxdepth 1 \( ! -wholename $REPO_DIR \) -type d) )
DIRECTORIES=( $(find $STUDENT_CODE_DIR -maxdepth 1 \( ! -wholename $STUDENT_CODE_DIR \) -type d) )
TOTAL=${#DIRECTORIES[@]}

# Create the spreadsheet to store our results
RESULTS="$RESULT_DIR/results.csv"

# prepare the testing directory
if [[ -d $RESULT_DIR ]]; then
  rm -r $RESULT_DIR
fi
mkdir $RESULT_DIR

if [[ -f $RESULTS ]]; then
  rm $RESULTS
fi

touch $RESULTS

# Write out the header for the results file
writeResultsHeader "$RESULTS" REPOS DIRECTORIES

# Finally, perform the comparison of the files against eachother
for ((i = 0; i < $TOTAL; ++i)) do
  CURRENT_DIR=${DIRECTORIES[$i]}
  # Extract the NETID from the file path
  NETID=$(getNetID $CURRENT_DIR)

  echo "Currently Processing: $NETID"
  echo -n "$NETID," >> $RESULTS # Write out net id for this row's results

  CLEANED_SOURCE=$(getCleanedJava $CURRENT_DIR)

  # First compare against the repositories
  for ((j = 0; j < ${#REPOS[@]}; ++j)) do
    CURRENT_REPO=${REPOS[$j]}
    # Compare the two files and log the result
    OTHER_CLEANED=$(getCleanedJava $CURRENT_REPO)

    compareFiles $RESULTS $CLEANED_SOURCE $OTHER_CLEANED
  done

  # Following repositories, compare against the other students
  for ((j = $TOTAL - 1; j > i; --j)) do
    # don't compare students against themselves
    if [[ j == i ]]; then
      echo -n "-1" >> $RESULTS
    else
      CURRENT_STUDENT=${DIRECTORIES[$j]}

      OTHER_CLEANED=$(getCleanedJava $CURRENT_STUDENT)

      compareFiles $RESULTS $CLEANED_SOURCE $OTHER_CLEANED
    fi
  done

  # Legit, there's definitely a way to refactor this, but idk if it's that useful given the
  #   backwards iteration over the students array

  # But, anyway, at this point in the program we should be done with the current student!
  # Just finish off the current line of the results file and call it a day

  # Remove last comma
  truncate -s-1 $RESULTS
  # add in the line break
  echo -ne "\n" >> $RESULTS
done
